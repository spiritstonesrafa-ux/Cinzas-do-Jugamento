extends SceneTree
## M2 real-physics/contact tests. Manual visual homologation remains separate.

var _checks: int = 0
var _failures: int = 0
var _deaths: int = 0
var _health_events: int = 0
var _activations: int = 0
var _knight: KnightController
var _health: KnightSurvival

func _initialize() -> void:
	_run.call_deferred()

func _frames(count: int) -> void:
	for frame: int in range(count):
		await physics_frame
		await process_frame

func _check(condition: bool, description: String) -> void:
	_checks += 1
	if condition:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)

func _press(action: String) -> void:
	Input.action_press(action)
	await _frames(1)
	Input.action_release(action)

func _wait_for_respawn() -> bool:
	for frame: int in range(90):
		await _frames(1)
		if not _health.is_dead:
			return true
	return false

func _run() -> void:
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	var stage: Node2D = main.get_node("PrototypeStage") as Node2D
	_knight = stage.get_node("Knight") as KnightController
	_health = _knight.survival
	var hud: Label = stage.get_node("HealthHUD/Life") as Label
	var checkpoint: RespawnCheckpoint = stage.get_node("RespawnCheckpoint") as RespawnCheckpoint
	_health.died.connect(func() -> void: _deaths += 1)
	_health.health_changed.connect(func(_current: int, _maximum: int) -> void: _health_events += 1)
	checkpoint.activated.connect(func() -> void: _activations += 1)
	await _frames(4)
	_check(_health.max_health == 5 and _health.current_health == 5, "Initial health is 5/5")
	_check(hud.text == "VIDA 5/5", "HUD binds initial health")
	_check(_knight.hurtbox.collision_layer == 16 and _knight.hurtbox.collision_mask == 32, "Hurtbox layers are separate from offensive hitbox")
	_check(not _knight.receive_damage(-5) and not _knight.receive_damage(0), "Negative and zero damage rejected")
	_check(_health.current_health == 5 and _health_events == 0, "Invalid damage neither heals nor emits health change")

	# A configurable standalone health component also clamps lethal damage.
	var configured: KnightSurvival = KnightSurvival.new()
	configured.max_health = 3
	root.add_child(configured)
	_check(configured.current_health == 3, "Configured maximum sets initial health")
	configured.max_health = 2
	_check(configured.current_health == 2, "Reducing maximum clamps current health")
	configured.receive_damage(999)
	_check(configured.current_health == 0 and configured.is_dead, "Overkill clamps health to zero")
	configured.restore()
	_check(configured.current_health == 2 and not configured.is_dead, "Restore respects configured maximum")
	configured.queue_free()

	_knight.reset_to(Vector2(490, 156))
	await _frames(1)
	_check(_health.current_health == 4 and _health_events == 1, "Actual hazard contact removes exactly one point")
	_check(_health.invulnerability_remaining > 0.7, "Accepted damage starts configurable 0.8-second protection")
	_check(hud.text == "VIDA 4/5" and _knight.visual.modulate != Color.WHITE, "HUD and damage feedback update")
	_check(not _knight.receive_damage(1) and _health.current_health == 4, "Central method rejects damage during invulnerability")
	await _frames(20)
	_check(_health.current_health == 4, "Sustained overlap cannot drain health during protection")
	_knight.reset_to(Vector2(450, 156))
	await _frames(35)
	_check(_health.invulnerability_remaining == 0.0 and _knight.visual.modulate == Color.WHITE, "Protection expires and visual returns exactly to neutral")
	_knight.reset_to(Vector2(490, 156))
	await _frames(1)
	_check(_health.current_health == 3, "New contact after expiry causes one more point")
	_knight.reset_to(Vector2(48, 156))
	_health.restore()
	await _frames(3)

	await _press("attack")
	await _frames(7)
	_check(_knight.sword_attack.phase == SwordAttack.Phase.ACTIVE, "Sword active before lethal contact")
	_knight.receive_damage(999)
	_check(_health.current_health == 0 and _knight.state == KnightController.MovementState.DEAD, "Zero health enters DEAD")
	_check(_deaths == 1 and hud.text == "VIDA 0/5", "Death emits once and HUD shows zero")
	_check(_knight.sword_attack.phase == SwordAttack.Phase.NEUTRAL and _knight.sword_attack.hit_shape.disabled, "Death immediately cancels sword and disables offensive shape")
	for hit: int in range(5):
		_knight.receive_damage(999)
	_check(_deaths == 1 and _health.current_health == 0, "Repeated lethal events cannot duplicate death")
	var dead_position: Vector2 = _knight.position
	Input.action_press("move_right")
	Input.action_press("jump")
	Input.action_press("attack")
	await _frames(10)
	_check(_knight.position == dead_position and _knight.velocity == Vector2.ZERO, "Movement and jump controls blocked while dead")
	_check(_knight.sword_attack.phase == SwordAttack.Phase.NEUTRAL, "New attacks blocked while dead")
	_check(_knight.visual.rotation != 0.0 and _health.is_dead, "Death pose and configurable delay are present")
	Input.action_release("move_right")
	Input.action_release("jump")
	# Keep attack held through respawn to verify no pending attack gets queued.
	_check(await _wait_for_respawn(), "Default death timer requests respawn")
	_check(_knight.position.distance_to(Vector2(48, 156)) < 0.1 and _knight.velocity == Vector2.ZERO, "Without activated checkpoint death returns to safe default")
	_check(_health.current_health == 5 and hud.text == "VIDA 5/5", "Respawn restores maximum health and HUD")
	_check(_health.invulnerability_remaining == 0.0 and _knight.visual.modulate == Color.WHITE and _knight.visual.rotation == 0.0, "Respawn clears damage, invulnerability and death presentation")
	await _frames(4)
	_check(_knight.sword_attack.phase == SwordAttack.Phase.NEUTRAL and _knight.is_on_floor(), "Held attack and dead-frame jump do not carry into respawn")
	Input.action_release("attack")
	_check(_health.current_health == 5, "Safe default does not cause immediate respawn damage")

	_knight.reset_to(Vector2(690, 156))
	await _frames(4)
	_check(checkpoint.active and _knight.active_checkpoint == checkpoint and _activations == 1, "Physical contact activates reusable checkpoint")
	_knight.activate_checkpoint(checkpoint)
	_knight.activate_checkpoint(checkpoint)
	_check(_activations == 1, "Repeated contact avoids duplicate activation")
	_check(_knight.is_respawn_safe(checkpoint.respawn_point.global_position), "Checkpoint marker has floor support and no solid/hazard overlap")
	_check(not _knight.is_respawn_safe(Vector2(590, 156)), "A marker over the pit is not considered safe")
	_check(not _knight.is_respawn_safe(Vector2(490, 156)), "A marker touching the hazard is not considered safe")
	var extra: RespawnCheckpoint = (load("res://scenes/props/respawn_checkpoint.tscn") as PackedScene).instantiate() as RespawnCheckpoint
	extra.position = Vector2(840, 156)
	stage.add_child(extra)
	_knight.reset_to(Vector2(840, 156))
	await _frames(4)
	_check(extra.active and not checkpoint.active and _knight.active_checkpoint == extra, "Reusable second checkpoint replaces and deactivates old checkpoint")
	_knight.reset_to(Vector2(690, 156))
	await _frames(4)
	_check(checkpoint.active and not extra.active, "Returning to an earlier checkpoint activates it again")
	extra.position = Vector2(490, 156)
	extra.respawn_point.position = Vector2.ZERO
	await _frames(3)
	_knight.activate_checkpoint(extra)
	_check(_knight.active_checkpoint == checkpoint, "Unsafe checkpoint cannot replace the last safe marker")
	extra.queue_free()

	await _press("attack")
	await _frames(7)
	_knight.receive_damage(999)
	_check(await _wait_for_respawn(), "Death at checkpoint finishes its delay")
	_check(_knight.position.distance_to(Vector2(666, 156)) < 0.1 and _knight.velocity == Vector2.ZERO, "Death respawns at last active checkpoint marker")
	_check(_health.current_health == 5 and _health.invulnerability_remaining == 0.0 and _knight.sword_attack.hit_shape.disabled, "Checkpoint respawn clears all temporary combat/survival states")
	await _frames(20)
	_check(_health.current_health == 5 and _knight.is_on_floor(), "Checkpoint respawn stays safe with no immediate collision damage")
	var target: TrainingTarget = stage.get_node("TrainingTarget") as TrainingTarget
	target.position = Vector2(690, 156)
	await _frames(3)
	await _press("attack")
	await _frames(8)
	_check(target.hit_count == 1, "Sword hits normally after death/respawn")
	await _frames(25)
	Input.action_press("move_right")
	await _frames(10)
	Input.action_release("move_right")
	_check(_knight.position.x > 675, "Movement control restored after checkpoint respawn")
	await _press("jump")
	_check(_knight.velocity.y < 0.0, "Jump restored after checkpoint respawn")
	await _frames(60)

	# Alive falls deliberately keep M0's original spawn and do not refill HP.
	_knight.receive_damage(1)
	await _press("attack")
	_knight.position = Vector2(590, 225)
	await _frames(1)
	_check(_knight.position.distance_to(Vector2(48, 156)) < 0.1 and _knight.velocity == Vector2.ZERO, "Alive fall still returns to M0 original start, not checkpoint")
	_check(_health.current_health == 4 and _knight.active_checkpoint == checkpoint, "Alive fall neither heals nor forgets the active checkpoint")
	_check(_knight.sword_attack.phase == SwordAttack.Phase.NEUTRAL and _knight.sword_attack.hit_shape.disabled, "M0 fall still cancels attack")
	await _frames(50)
	_knight.receive_damage(999)
	_knight.position = Vector2(590, 225)
	await _frames(1)
	_check(_health.is_dead and _knight.position.y > 224, "Fall boundary cannot prematurely revive a dead player")
	_check(await _wait_for_respawn(), "Dead player below fall boundary still completes death timer")
	_check(_knight.position.distance_to(Vector2(666, 156)) < 0.1, "Death after an alive fall still uses the last checkpoint")
	var camera: Camera2D = stage.get_node("Camera2D") as Camera2D
	_check(camera.position.x == 666.0, "Camera follows checkpoint respawn on the same physics step")

	# Direct regressions for the two M0 input forgiveness windows.
	_knight.reset_to(Vector2(540, 156))
	await _frames(3)
	Input.action_press("move_right")
	for frame: int in range(30):
		await _frames(1)
		if not _knight.is_on_floor():
			break
	Input.action_release("move_right")
	await _press("jump")
	_check(_knight.velocity.y < 0.0, "M0 coyote jump remains available just after leaving an edge")
	_knight.reset_to(Vector2(450, 130))
	await _frames(2)
	for frame: int in range(30):
		await _frames(1)
		if _knight.position.y >= 150.0:
			break
	await _press("jump")
	var buffered_jump: bool = false
	for frame: int in range(8):
		await _frames(1)
		if _knight.velocity.y < 0.0:
			buffered_jump = true
			break
	_check(buffered_jump, "M0 buffered jump remains available before landing")
	# Prove the full authored hazard -> repeated contacts -> death -> checkpoint loop.
	_health.restore()
	_knight.reset_to(Vector2(490, 156))
	var deaths_before: int = _deaths
	for frame: int in range(300):
		await _frames(1)
		if _health.is_dead:
			break
	_check(_health.current_health == 0 and _deaths == deaths_before + 1, "Continuous hazard contact eventually causes exactly one real death")
	_check(await _wait_for_respawn(), "Natural contact death completes respawn")
	_check(_knight.position.distance_to(Vector2(666, 156)) < 0.1 and _health.current_health == 5, "Natural contact death restores life at safe checkpoint")
	# A checkpoint made unsafe after activation must fall back to the default.
	checkpoint.respawn_point.global_position = Vector2(490, 156)
	_knight.receive_damage(999)
	_check(await _wait_for_respawn(), "Unsafe active marker still permits default respawn")
	_check(_knight.position.distance_to(Vector2(48, 156)) < 0.1 and _health.current_health == 5, "Unsafe active marker falls back to safe default")
	main.queue_free()
	await _frames(1)
	print("M2 checks: ", _checks, "; failures: ", _failures)
	quit(0 if _failures == 0 else 1)
