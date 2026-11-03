extends "res://tests/distribution_test.gd"
## Actual M3-C scene. Trap units isolate enemies; navigation/encounters enable all six.
var spikes: DamageSource
var blade: OscillatingBlade
var timed: TimedSpikes
var cp1: CemeteryCheckpoint
var cp2: CemeteryCheckpoint
var activations: Array[int] = [0,0]
var deaths: int = 0
var respawns: int = 0

func _clear_checkpoints() -> void:
	_knight.active_checkpoint = null
	cp1.set_active(false)
	cp2.set_active(false)

func _cross_spikes(side: int) -> void:
	await _place(Vector2(800,140) if side > 0 else Vector2(850,116))
	Input.action_press("move_right" if side > 0 else "move_left")
	Input.action_press("jump")
	await _frames(1)
	Input.action_release("jump")
	var landed: bool = false
	for frame: int in range(80):
		await _frames(1)
		if _knight.is_on_floor() and (_knight.position.x-824)*side > 22:
			landed = true
			break
	_release()
	_check(landed and _knight.survival.current_health == 5, "Real spike jump and landing costs zero HP, direction %d" % side)

func _cross_blade(side: int) -> void:
	await _place(Vector2(1354 if side > 0 else 1402,220))
	await _frames(60) # Deliberately arrive during the low/dangerous part of its cycle.
	for frame: int in range(180):
		if blade.elapsed / blade.period >= 0.74: break
		await _frames(1)
	Input.action_press("move_right" if side > 0 else "move_left")
	await _frames(34)
	_release()
	await _frames(3)
	_check((_knight.position.x >= 1400 if side > 0 else _knight.position.x <= 1358) and _knight.survival.current_health == 5, "Observe high blade window and walk through without damage, direction %d" % side)

func _cross_timed(side: int) -> void:
	await _place(Vector2(1988 if side > 0 else 2044,156))
	for frame: int in range(180):
		if timed.state == TimedSpikes.State.ACTIVE: break
		await _frames(1)
	_check(timed.state == TimedSpikes.State.ACTIVE, "Timed jump probe starts with visible extended spikes")
	Input.action_press("move_right" if side > 0 else "move_left")
	Input.action_press("jump")
	await _frames(1)
	Input.action_release("jump")
	await _frames(43)
	_release()
	_check((_knight.position.x-2016)*side > 20 and _knight.survival.current_health == 5, "Real jump clears active timed hazard without damage, direction %d" % side)

func _hazard_route(direction: int, destination: float) -> bool:
	var action: String = "move_right" if direction > 0 else "move_left"
	var visited: Array[int] = []
	var camera_valid: bool = true
	var crypt_seen: bool = false
	var previous_x: float = _knight.position.x
	var frames_stuck: int = 0
	var start_health: int = _knight.survival.current_health
	Input.action_press(action)
	for frame: int in range(2400):
		Input.action_release("jump")
		Input.action_release("attack")
		var p: Vector2 = _knight.position
		var index: int = _stage.sector_at(p.x)
		if not visited.has(index):
			visited.append(index)
		crypt_seen = crypt_seen or (index == 3 and p.y > 210.0)
		camera_valid = camera_valid and _camera.position == _camera.position.round()
		camera_valid = camera_valid and _camera.position.x >= 160.0 and _camera.position.x <= 2208.0
		camera_valid = camera_valid and _camera.position.y >= 90.0 and _camera.position.y <= 154.0
		# Ground lookahead detects a lip; low forward ray detects a raised block.
		if _knight.is_on_floor():
			var ahead: Vector2 = p + Vector2(8 * direction, 0)
			if not _ray(ahead + Vector2(0, -2), ahead + Vector2(0, 6)) or _ray(p + Vector2(0, -4), ahead + Vector2(0, -4)):
				Input.action_press("jump")
		# New traps are observed before crossing; enemy processing remains active.
		var spike_distance: float = (824.0-p.x)*direction
		if _knight.is_on_floor() and spike_distance > 0 and spike_distance < 26:
			Input.action_press("jump")
		var timed_distance: float = (2016.0-p.x)*direction
		if _knight.is_on_floor() and timed_distance > 0 and timed_distance < 30:
			Input.action_press("jump")
		# Resolve crypt ground threat first; blade has a separate observation space.
		var crypt: SkeletonPatrol = _enemies.get_node("CryptSkeleton") as SkeletonPatrol
		if _knight.is_on_floor() and absf(p.y-220) < 1 and crypt.current_health > 0 and absf(crypt.position.x-p.x) < 25:
			Input.action_release(action)
			for attempt: int in range(4):
				if crypt.current_health == 0: break
				await _swing()
				await _frames(18)
			Input.action_press(action)
		# Wait outside the blade circle; its top window lasts long enough for walking.
		var blade_distance: float = (1384.0-p.x)*direction
		if _knight.is_on_floor() and absf(p.y-220) < 30 and blade_distance > 17 and blade_distance < 40:
			var phase: float = blade.elapsed / blade.period
			if phase > 0.08 and phase < 0.74:
				Input.action_release(action)
				await _frames(1)
				previous_x = _knight.position.x
				frames_stuck = 0
				continue
			Input.action_press(action)
		# Existing ground-threat anticipation.

		for enemy: Node2D in _enemies.get_children():
			if enemy is SkeletonPatrol and enemy.current_health > 0 and _knight.is_on_floor():
				var ahead_distance: float = (enemy.position.x - p.x) * direction
				if ahead_distance > 12 and ahead_distance < 48 and absf(enemy.position.y - p.y) < 20:
					Input.action_press("jump")
		if frame % 26 == 0 and _knight.is_on_floor():
			Input.action_press("attack")
		await _frames(1)
		if _knight.survival.is_dead or (_knight.position.x - previous_x) * direction < -100.0:
			break
		if absf(_knight.position.x - previous_x) < 0.1:
			frames_stuck += 1
		else:
			frames_stuck = 0
		previous_x = _knight.position.x
		# A fall return or an impassable obstacle must fail, never be hidden by retry.
		if _knight.position.y > 250.0 or frames_stuck > 90:
			print("Traversal blocked at ", _knight.position, " direction ", direction)
			break
		if (_knight.position.x - destination) * direction >= 0.0:
			Input.action_release("attack")
			Input.action_release(action)
			Input.action_release("jump")
			await _frames(30)
			_check(visited == ([0, 1, 2, 3, 4, 5] if direction > 0 else [5, 4, 3, 2, 1, 0]), "All six sectors traversed in order, direction %d" % direction)
			_check(crypt_seen, "Route actually descends underground, direction %d" % direction)
			_check(camera_valid, "Camera stays integer and inside bounds throughout live traversal")
			print("LIVE ROUTE direction=", direction, " HP ", start_health, " -> ", _knight.survival.current_health)
			return true
	print("M3C ROUTE FAILED pos=",_knight.position," HP=",_knight.survival.current_health," dead=",_knight.survival.is_dead," blade=",blade.position," direction=",direction)
	Input.action_release(action)
	Input.action_release("jump")
	return false

func _run() -> void:
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	_stage = main.get_node("ForgottenCemetery") as Node2D
	_knight = _stage.get_node("Knight") as KnightController
	_camera = _stage.get_node("Camera2D") as Camera2D
	_enemies = _stage.get_node("Enemies") as Node2D
	spikes = _stage.get_node("Mechanisms/GardenSpikes") as DamageSource
	blade = _stage.get_node("Mechanisms/CryptBlade") as OscillatingBlade
	timed = _stage.get_node("Mechanisms/CathedralTimed") as TimedSpikes
	cp1 = _stage.get_node("Mechanisms/Checkpoint1") as CemeteryCheckpoint
	cp2 = _stage.get_node("Mechanisms/Checkpoint2") as CemeteryCheckpoint
	cp1.activated.connect(func() -> void: activations[0] += 1)
	cp2.activated.connect(func() -> void: activations[1] += 1)
	_knight.survival.died.connect(func() -> void: deaths += 1)
	_knight.survival.respawn_requested.connect(func() -> void: respawns += 1)
	await _frames(5)
	_check(_knight.active_checkpoint == null and not cp1.active and not cp2.active, "Checkpoints do not activate before contact")
	_check(_enemies.get_child_count() == 6 and _stage.get_node("Mechanisms").get_child_count() == 5, "Six original enemies plus exactly three traps and two checkpoints")
	for name: String in EXPECTED:
		_check(_enemies.get_node(name).origin == EXPECTED[name], "Preserved B3 origin: " + name)
	_check(_knight.is_respawn_safe(Vector2(48,156)) and _knight.is_respawn_safe(cp1.position) and _knight.is_respawn_safe(cp2.position), "Default and both checkpoint respawns physically supported and hazard-free")
	_check(spikes.position == Vector2(824,140) and blade.origin == Vector2(1384,176) and timed.position == Vector2(2016,156), "Three authored trap coordinates in sectors 3,4,6; bridge has none")
	await _frames(180)
	_check(_knight.survival.current_health == 5 and deaths == 0, "Start remains safe with all six enemies and three traps processing")
	# Isolated trap units retain actual M1/M2 physics; live integration follows.
	_stage._restore_enemies()
	_enemies.process_mode = Node.PROCESS_MODE_DISABLED
	await _place(Vector2(824,140))
	_check(_knight.survival.current_health == 4, "Static spikes apply exactly 1 HP through real M2 overlap")
	await _frames(30)
	_check(_knight.survival.current_health == 4, "Static contact cannot duplicate damage during 0.8s protection")
	await _frames(20)
	_check(_knight.survival.current_health == 3, "Continuing contact damages again only after M2 protection expires")
	_check(_stage.get_node("HealthHUD/Life").text == "VIDA 3/5", "HUD reflects environmental damage")
	var shape: RectangleShape2D = spikes.get_node("CollisionShape2D").shape as RectangleShape2D
	_check(shape.size == Vector2(20,12), "Spike danger fits the visible 24px base and 12px teeth")
	for side: int in [1,-1]: await _cross_spikes(side)
	await _place(Vector2(1402,220))
	var first: Array[Vector2] = []
	var bounded: bool = true
	for frame: int in range(336):
		await _frames(1)
		first.append(blade.position)
		bounded = bounded and is_equal_approx(blade.position.x,1384) and blade.position.y >= 147.99 and blade.position.y <= 204.01
	_check(bounded, "Blade follows its limited vertical path for two whole periods")
	_check(_knight.survival.current_health == 5, "No ghost hit outside visible 10px blade radius across all phases")
	await _place(Vector2(1402,220))
	var deterministic: bool = true
	for frame: int in range(336):
		await _frames(1)
		deterministic = deterministic and blade.position.is_equal_approx(first[frame])
	_check(deterministic, "Reset reproduces the same physical blade path, no homing/randomness")
	await _place(Vector2(1384,220))
	for frame: int in range(100):
		await _frames(1)
		if _knight.survival.current_health == 4: break
	_check(_knight.survival.current_health == 4, "Low blade applies exactly 1 HP via M2")
	await _frames(12)
	_check(_knight.survival.current_health == 4, "Blade overlap respects original invulnerability")
	for side: int in [1,-1]: await _cross_blade(side)
	await _place(Vector2(2016,156))
	_check(timed.state == TimedSpikes.State.SAFE and timed.shape.disabled and _knight.survival.current_health == 5, "Timed SAFE retracts shape and causes no contact damage")
	for frame: int in range(100):
		if timed.state == TimedSpikes.State.WARNING: break
		await _frames(1)
	_check(timed.state == TimedSpikes.State.WARNING and timed.shape.disabled and _knight.survival.current_health == 5, "Visible WARNING precedes activation without dangerous shape")
	await _frames(30)
	_check(timed.state == TimedSpikes.State.WARNING and _knight.survival.current_health == 5, "Warning lasts at least 0.5 seconds without silent activation")
	for frame: int in range(60):
		await _frames(1)
		if timed.state == TimedSpikes.State.ACTIVE: break
	_check(timed.state == TimedSpikes.State.ACTIVE and not timed.shape.disabled and _knight.survival.current_health == 4, "Only ACTIVE enables shape and deals 1 HP")
	await _frames(12)
	_check(_knight.survival.current_health == 4, "Timed hazard cannot repeat inside M2 protection")
	for frame: int in range(60):
		if timed.state == TimedSpikes.State.RECOVER: break
		await _frames(1)
	_check(timed.shape.disabled and timed.contact_damage(0) == 0, "RECOVER is harmless in both source and physical shape")
	timed.safe_duration = 0.3
	timed.warning_duration = 0.2
	timed.active_duration = 0.2
	timed.recovery_duration = 0.2
	timed.reset_hazard()
	await _frames(19)
	_check(timed.state == TimedSpikes.State.WARNING, "Per-instance configurable SAFE duration honored")
	await _frames(12)
	_check(timed.state == TimedSpikes.State.ACTIVE, "Per-instance configurable warning honored")
	timed.safe_duration = 1.5
	timed.warning_duration = 0.6
	timed.active_duration = 0.8
	timed.recovery_duration = 0.4
	timed.reset_hazard()
	for side: int in [1,-1]: await _cross_timed(side)
	# Live temporary enemy probes are outside the disabled historical enemy container.
	# They use the existing species with a zero-width leash, never added to gameplay.
	await _place(Vector2(180,156))
	for point: Vector2 in [Vector2(824,140),Vector2(1384,220),Vector2(2016,156)]:
		var probe: SkeletonPatrol = (load("res://scenes/enemies/skeleton_patrol.tscn") as PackedScene).instantiate() as SkeletonPatrol
		probe.position = point
		probe.patrol_left = 0
		probe.patrol_right = 0
		_stage.add_child(probe)
		await _frames(336)
		_check(probe.current_health == 3 and probe.is_on_floor(), "Live enemy remains unharmed in real environmental contact at " + str(point))
		probe.queue_free()
		await _frames(1)
	await _place(Vector2(824,140))
	var before_respawn: int = respawns
	for frame: int in range(300):
		await _frames(1)
		if respawns > before_respawn: break
	_check(respawns == before_respawn+1 and _knight.position.distance_to(Vector2(48,156)) < 0.1, "Lethal continuing spike contact emits one death/respawn and returns to safe default")
	_check(_knight.survival.current_health == 5 and timed.state == TimedSpikes.State.SAFE, "Environmental death restores HP and resets trap cycle")
	var enemies_unharmed: bool = true
	for enemy: Node2D in _enemies.get_children(): enemies_unharmed = enemies_unharmed and enemy.current_health == enemy.max_health
	_check(enemies_unharmed, "Environmental contact does not damage enemies")
	_enemies.process_mode = Node.PROCESS_MODE_INHERIT
	_clear_checkpoints()
	await _place(cp1.position)
	_check(_knight.active_checkpoint == cp1 and cp1.active and activations[0] == 1, "CP1 activates automatically on real contact once")
	await _frames(10)
	_check(activations[0] == 1, "Continuing checkpoint contact does not duplicate activation")
	await _place(cp2.position,false)
	_check(_knight.active_checkpoint == cp2 and cp2.active and not cp1.active, "CP2 supersedes CP1 with distinct active flag")
	await _place(cp1.position,false)
	_check(_knight.active_checkpoint == cp2 and not cp1.active, "Returning through CP1 never regresses CP2 progression")
	await _place(cp2.position,false)
	var death_base: int = deaths
	var respawn_base: int = respawns
	for repetition: int in range(3):
		_knight.receive_damage(999)
		await _frames(50)
		_check(not _knight.survival.is_dead and _knight.survival.current_health == 5 and _knight.position.distance_to(cp2.position) < 0.1, "Repeated death returns safely to CP2 with full HP, iteration %d" % repetition)
		_check(timed.state == TimedSpikes.State.SAFE and not blade.get_node("CollisionShape2D").disabled, "Death resets timed cycle and preserves valid blade source")
	_check(deaths-death_base == 3 and respawns-respawn_base == 3, "Exactly one respawn event for each death")
	await _frames(180)
	_check(_knight.survival.current_health == 5 and _camera.position == Vector2(1936,90), "CP2 remains safe for three seconds with all enemies/traps active and camera aligned")
	_knight.receive_damage(1)
	for enemy: Node2D in _enemies.get_children(): enemy.receive_hit()
	_knight.position = Vector2(1740,300)
	await _frames(1)
	var restored: bool = true
	for enemy: Node2D in _enemies.get_children(): restored = restored and enemy.current_health == enemy.max_health and not enemy.attack_source.active
	_check(restored and _knight.position.distance_to(Vector2(48,156)) < 0.1 and _knight.survival.current_health == 4, "Alive fall returns to original start without healing, restores enemies")
	_check(_knight.active_checkpoint == cp2 and timed.state == TimedSpikes.State.SAFE and blade.position == blade.origin-blade.travel, "Alive fall retains checkpoint progression and resets trap phases")
	_clear_checkpoints()
	await _place(cp1.position)
	await _place(Vector2(1308,220),false)
	_knight.receive_damage(999)
	await _frames(50)
	_check(_knight.position.distance_to(cp1.position) < 0.1 and _knight.survival.current_health == 5, "Death also returns to safe CP1 with full HP")
	await _frames(180)
	_check(_knight.survival.current_health == 5, "CP1 respawn remains outside raven/crypt threats for three seconds")
	# Actual combined B3 combat with the M3-C timed trap cycling nearby.
	var ground: SkeletonPatrol = _enemies.get_node("CathedralSkeleton") as SkeletonPatrol
	var air: CursedRaven = _enemies.get_node("CathedralRaven") as CursedRaven
	await _place(ground.origin + Vector2(-20,0))
	await _face(1)
	await _finish_ground_live(ground)
	await _finish_air_live(air)
	_check(ground.current_health == 0 and air.current_health == 0 and _knight.survival.current_health == 5, "Combined final combat remains possible without damage while timed trap cycles")
	_clear_checkpoints()
	await _place(Vector2(48,156))
	_check(await _hazard_route(1,2288), "Full real M3-C route reaches finish with traps and six enemies active")
	_check(_knight.active_checkpoint == cp2, "Continuous forward route physically activates both checkpoints in progression")
	_check(await _hazard_route(-1,48), "Continuous full return crosses traps, stairs and bridge")
	_check(_knight.active_checkpoint == cp2, "Full return never regresses active checkpoint")
	_release()
	main.queue_free()
	await _frames(1)
	print("M3-C checks: ",_checks,"; failures: ",_failures)
	quit(0 if _failures == 0 else 1)
