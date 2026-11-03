extends SceneTree
## Real scene, inputs, collisions and M1/M2 contracts. Each scenario resets actors.
var _checks: int = 0
var _failures: int = 0
var _stage: Node2D
var _knight: KnightController
var _raven: CursedRaven
var _camera: Camera2D
var _skeleton: SkeletonPatrol
var _defeats: int = 0

func _initialize() -> void:
	_run.call_deferred()

func _frames(count: int) -> void:
	for frame: int in range(count):
		await physics_frame
		await process_frame

func _check(ok: bool, description: String) -> void:
	_checks += 1
	if ok:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)

func _place(x: float) -> void:
	for action: String in ["move_left", "move_right", "jump", "attack"]:
		Input.action_release(action)
	_stage.set_physics_process(true)
	_knight.reset_to(Vector2(x, 156))
	_knight.survival.restore()
	_raven.reset_enemy()
	_raven.target = null
	await _frames(4)

func _wait_state(wanted: CursedRaven.State, limit: int = 400) -> bool:
	for frame: int in range(limit):
		if _raven.state == wanted:
			return true
		await _frames(1)
	return false

func _alert() -> void:
	_raven.target = _knight
	await _frames(1)

func _counter(side: int) -> void:
	await _place(1050.0 + side * 24.0)
	await _alert()
	var direction: Vector2 = _raven.dive_direction
	var away: String = "move_right" if side > 0 else "move_left"
	Input.action_press(away)
	await _frames(12)
	Input.action_release(away)
	await _frames(4)
	_check(await _wait_state(CursedRaven.State.RECOVER), "Completed predictable dive before counter, side %d" % side)
	_check(_knight.survival.current_health == 5, "Real walking inputs evade the locked dive, side %d" % side)
	_check(_raven.dive_direction == direction, "Dive never homes on moving Aren, side %d" % side)
	_check(absf(_raven.position.y - (_knight.position.y - 14.0)) < 0.2, "Real dive endpoint is inside ground sword height, side %d" % side)
	var toward: String = "move_left" if side > 0 else "move_right"
	Input.action_press(toward)
	await _frames(1)
	Input.action_release(toward)
	await _frames(3)
	Input.action_press("attack")
	await _frames(1)
	Input.action_release("attack")
	await _frames(7)
	_check(_raven.current_health == 1 and _raven.state == CursedRaven.State.HURT, "Unmodified grounded M1 sword physically hits recovering raven once, side %d" % side)
	_check(not _raven.attack_source.active, "HURT cancels offensive source, side %d" % side)
	await _frames(24)
	_check(_raven.current_health == 1, "Same player swing never duplicates raven damage, side %d" % side)
	Input.action_press("attack")
	await _frames(1)
	Input.action_release("attack")
	await _frames(7)
	_check(_raven.state == CursedRaven.State.DEAD and _raven.current_health == 0, "Second real counter defeats raven, side %d" % side)
	_check(_raven.attack_source.shape.disabled and _raven.hurt_shape.disabled and _raven.body_shape.disabled, "DEAD clears all attack/receiver/body shapes")
	var count: int = _defeats
	_raven.receive_hit()
	await _frames(40)
	_check(_defeats == count and _knight.survival.current_health == 5, "Dead raven is inert and cannot emit duplicate defeat")

func _run() -> void:
	var main: Node = (load("res://tests/fixtures/m3_b3_main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	_stage = main.get_node("ForgottenCemetery") as Node2D
	_knight = _stage.get_node("Knight") as KnightController
	_raven = _stage.get_node("Enemies/CursedRaven") as CursedRaven
	_camera = _stage.get_node("Camera2D") as Camera2D
	_skeleton = _stage.get_node("Enemies/SkeletonPatrol") as SkeletonPatrol
	_raven.defeated.connect(func() -> void: _defeats += 1)
	_check(_raven.state == CursedRaven.State.IDLE and _raven.current_health == 2, "Initial raven is IDLE with 2 HP")
	_check(_stage.get_node("Enemies").get_child_count() == 6 and _stage.get_node("Enemies/CursedRaven") == _raven and _stage.get_node("Enemies/SkeletonPatrol") == _skeleton, "Six planned B3 instances coexist with the preserved original raven and skeleton")
	_check(_raven.origin == Vector2(1050,112) and _raven.target == _knight, "Safe Garden origin and local target binding")
	_check(_raven.patrol_speed == 24 and _raven.dive_speed == 85 and _raven.alert_duration == 0.45 and _raven.attack_interval == 1.8, "Requested movement/timing defaults")
	_check(_raven.attack_source.shape.disabled, "No contact damage in initial hover")
	_raven.target = null
	var low: float = 1050.0
	var high: float = 1050.0
	var bounded: bool = true
	for frame: int in range(240):
		await _frames(1)
		low = minf(low, _raven.position.x)
		high = maxf(high, _raven.position.x)
		bounded = bounded and absf(_raven.position.y - 112.0) < 0.01 and _raven.velocity.length() <= 24.01
	_check(low < 1035 and high > 1065 and bounded, "Air patrol traverses deterministic horizontal route without gravity")
	_check(low >= 1030 and high <= 1070, "Air patrol honors configured bounds")
	var patrol_wall: StaticBody2D = StaticBody2D.new()
	patrol_wall.collision_layer = 1
	var patrol_shape: CollisionShape2D = CollisionShape2D.new()
	var patrol_rect: RectangleShape2D = RectangleShape2D.new()
	patrol_rect.size = Vector2(4,40)
	patrol_shape.shape = patrol_rect
	patrol_wall.add_child(patrol_shape)
	patrol_wall.position = Vector2(1066,112)
	_stage.add_child(patrol_wall)
	_raven.reset_enemy()
	_raven.target = null
	var collision_safe: bool = true
	for frame: int in range(180):
		await _frames(1)
		collision_safe = collision_safe and _raven.position.x < 1057.1
	_check(collision_safe, "Air patrol reverses at a physical wall without crossing it")
	patrol_wall.queue_free()
	await _frames(1)
	await _place(1026)
	_check(_raven.visible_for_attack(), "Entire raven is visible before Garden encounter")
	await _alert()
	_check(_raven.state == CursedRaven.State.ALERT and _raven.velocity == Vector2.ZERO, "Detection enters stationary visible ALERT")
	_check(not _raven.attack_source.active, "Alert telegraph has no offensive contact")
	await _frames(26)
	_check(_raven.state == CursedRaven.State.ALERT and _knight.survival.current_health == 5, "Preparation lasts at least 0.433 seconds without damage")
	await _frames(1)
	_check(_raven.state == CursedRaven.State.DIVE and _raven.attack_source.active, "At 0.45 seconds dive enables offensive source")
	var locked: Vector2 = _raven.dive_direction
	var end: Vector2 = _raven.dive_destination
	_check(_raven.position.distance_to(end) <= _raven.max_dive_distance + 0.01, "Dive endpoint respects configured maximum travel")
	_knight.reset_to(Vector2(1100,156))
	var limited: bool = true
	for frame: int in range(90):
		await _frames(1)
		limited = limited and _raven.velocity.length() <= 85.01 and _raven.dive_direction == locked
		if _raven.state == CursedRaven.State.RECOVER:
			break
	_check(limited and _raven.position.distance_to(end) < 0.2, "Dive follows locked endpoint and speed limit despite target relocation")
	_check(_raven.state == CursedRaven.State.RECOVER and not _raven.attack_source.active, "Dive ends in harmless recovery")
	_raven.target = null
	var rest: Vector2 = _raven.position
	await _frames(25)
	_check(_raven.position == rest and _raven.state == CursedRaven.State.RECOVER, "Low recovery counter-window persists before ascent")
	_check(await _wait_state(CursedRaven.State.PATROL), "Full collision-based recovery returns to patrol")
	_check(_raven.position.distance_to(_raven.origin) < 0.2, "Recovery returns physically to authored patrol origin")

	await _place(1026)
	await _alert()
	_check(await _wait_state(CursedRaven.State.RECOVER), "Contact dive completes")
	_check(_knight.survival.current_health == 4, "One valid dive applies exactly 1 HP through M2")
	await _frames(25)
	_check(_knight.survival.current_health == 4, "Recovery overlap cannot cause contact damage")
	await _place(1026)
	_knight.survival.invulnerability_duration = 0.01 # Explicit source dedup stress probe.
	await _alert()
	await _wait_state(CursedRaven.State.RECOVER)
	_check(_knight.survival.current_health == 4, "A dive cannot repeat damage even if protection expires inside contact window")
	_knight.survival.invulnerability_duration = 0.8
	await _place(1026)
	await _alert()
	_knight.receive_damage(1)
	await _wait_state(CursedRaven.State.RECOVER)
	_check(_knight.survival.current_health == 4, "Protected contact respects M2 0.8 seconds and consumes this dive")
	await _counter(-1)
	await _counter(1)

	# Explicit short-distance probe leaves time to observe the default cooldown.
	await _place(1042)
	_raven.max_dive_distance = 8
	await _alert()
	_check(await _wait_state(CursedRaven.State.PATROL), "Short dive/recovery probe returns before default interval")
	await _frames(8)
	_check(_raven.state == CursedRaven.State.PATROL and not _raven.attack_source.active, "Cooldown forbids immediate second alert/dive")
	_check(await _wait_state(CursedRaven.State.ALERT, 60), "A new attack becomes possible only after cooldown")
	_raven.max_dive_distance = 96

	await _place(1026)
	_stage.set_physics_process(false)
	_camera.position = Vector2(160,90)
	_camera.force_update_scroll()
	await _frames(2)
	_raven.target = _knight
	await _frames(45)
	_check(not _raven.visible_for_attack() and _raven.state != CursedRaven.State.ALERT and _raven.state != CursedRaven.State.DIVE, "Offscreen raven cannot acquire an attack")
	await _place(1026)
	await _alert()
	_stage.set_physics_process(false)
	_camera.position = Vector2(160,90)
	_camera.force_update_scroll()
	await _frames(30)
	_check(_raven.state == CursedRaven.State.RECOVER and not _raven.attack_source.active, "Moving camera away during ALERT prevents offscreen dive launch")
	_stage.set_physics_process(true)

	await _place(1026)
	await _alert()
	var wall: StaticBody2D = StaticBody2D.new()
	wall.collision_layer = 1
	var collider: CollisionShape2D = CollisionShape2D.new()
	var rectangle: RectangleShape2D = RectangleShape2D.new()
	rectangle.size = Vector2(4,12)
	collider.shape = rectangle
	wall.add_child(collider)
	wall.position = Vector2(1038,126)
	_stage.add_child(wall)
	_check(await _wait_state(CursedRaven.State.RECOVER), "Dive hitting solid obstacle enters recovery")
	_check(_raven.position.distance_to(_raven.dive_destination) > 5 and not _raven.attack_source.active and _knight.survival.current_health == 5, "Obstacle stops body and offensive hit without passing through")
	wall.queue_free()
	await _frames(2)
	_raven.target = null
	_check(await _wait_state(CursedRaven.State.PATROL), "Recovery after collision still reaches aerial route")

	for wait_dive: bool in [false, true]:
		await _place(1026)
		await _alert()
		if wait_dive:
			await _wait_state(CursedRaven.State.DIVE)
		_knight.receive_damage(999)
		await _frames(2)
		_check(_raven.state == CursedRaven.State.IDLE and not _raven.attack_source.active, "DEAD Aren interrupts ALERT/DIVE without more damage")
		for frame: int in range(90):
			await _frames(1)
			if not _knight.survival.is_dead:
				break
		_check(_raven.state == CursedRaven.State.IDLE and _raven.current_health == 2 and _raven.position == _raven.origin and _raven.dive_direction == Vector2.ZERO, "M2 respawn restores raven position, health and attack state")
		_check(_skeleton.current_health == 3 and _skeleton.position == _skeleton.origin and _knight.survival.current_health == 5, "Raven reset coexists with original skeleton and M2 health restore")
	await _place(1026)
	await _alert()
	await _wait_state(CursedRaven.State.DIVE)
	_raven.receive_hit()
	_check(_raven.state == CursedRaven.State.HURT and not _raven.attack_source.active, "HURT can interrupt live dive immediately")
	_knight.receive_damage(1)
	_knight.position = Vector2(560,300)
	await _frames(1)
	_check(_raven.current_health == 2 and _raven.state == CursedRaven.State.IDLE and _raven.position == _raven.origin and _raven.attack_source.shape.disabled, "Alive fall restores raven and clears offensive state")
	_check(_knight.survival.current_health == 4 and _knight.position.distance_to(Vector2(48,156)) < 0.1, "Alive fall keeps original no-healing behavior")

	for side: int in [-1,1]:
		await _place(1050.0 + side * 58.0)
		_raven.target = _knight
		var action: String = "move_right" if side < 0 else "move_left"
		Input.action_press(action)
		await _frames(80)
		Input.action_release(action)
		_check((_knight.position.x - 1050) * -side > 40 and _knight.is_on_floor() and _knight.survival.current_health >= 4, "Live Garden encounter can be crossed without mandatory combat, direction %d" % -side)
	main.queue_free()
	await _frames(1)
	print("M3-B2 checks: ", _checks, "; failures: ", _failures)
	quit(0 if _failures == 0 else 1)
