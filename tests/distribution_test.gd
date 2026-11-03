extends SceneTree
## B3 authored distribution with all six enemies active; no production AI changes.
const EXPECTED: Dictionary = {
	"SkeletonPatrol": Vector2(744,140), "CursedRaven": Vector2(1050,112),
	"CryptSkeleton": Vector2(1328,220), "BridgeRaven": Vector2(1552,112),
	"CathedralSkeleton": Vector2(2120,156), "CathedralRaven": Vector2(2188,112)
}
var _checks: int = 0
var _failures: int = 0
var _stage: Node2D
var _knight: KnightController
var _camera: Camera2D
var _enemies: Node2D

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

func _release() -> void:
	for action: String in ["move_left", "move_right", "jump", "attack"]:
		Input.action_release(action)

func _place(point: Vector2, reset: bool = true) -> void:
	_release()
	_knight.reset_to(point)
	if reset:
		_knight.survival.restore()
		_stage._restore_enemies()
	await _frames(4)

func _wait_raven(enemy: CursedRaven, wanted: CursedRaven.State, limit: int = 400) -> bool:
	for frame: int in range(limit):
		if enemy.state == wanted:
			return true
		await _frames(1)
	return false

func _swing() -> void:
	Input.action_press("attack")
	await _frames(1)
	Input.action_release("attack")
	await _frames(7)

func _face(side: int) -> void:
	Input.action_press("move_right" if side > 0 else "move_left")
	await _frames(1)
	_release()
	await _frames(3)

func _skeleton_counter(enemy: SkeletonPatrol, side: int, reset: bool = true) -> void:
	await _place((enemy.origin if reset else enemy.position) + Vector2(side * 20,0), reset)
	await _face(-side)
	_check(enemy.state == SkeletonPatrol.State.ATTACK, enemy.name + " warns before ground counter")
	for hit: int in range(3):
		await _swing()
		_check(enemy.current_health == 2 - hit, enemy.name + " receives exactly one real M1 hit %d" % (hit+1))
		await _frames(18)
	_check(enemy.state == SkeletonPatrol.State.DEAD and not enemy.attack_source.active, enemy.name + " defeated with inert source")
	_check(_knight.survival.current_health == 5, enemy.name + " controllable ground strategy costs zero HP, side %d" % side)

func _raven_counter(enemy: CursedRaven, side: int, reset: bool = true) -> void:
	var feet: float = 156.0
	var horizontal: float = 20.0 if enemy.name == "BridgeRaven" else 24.0
	await _place(Vector2(enemy.origin.x + side * horizontal, feet), reset)
	_check(await _wait_raven(enemy, CursedRaven.State.ALERT, 120), enemy.name + " detects grounded target")
	var locked: Vector2 = enemy.dive_destination
	Input.action_press("move_right" if side > 0 else "move_left")
	await _frames(12)
	_release()
	await _frames(4)
	_check(await _wait_raven(enemy, CursedRaven.State.RECOVER), enemy.name + " completes physical dive")
	_check(enemy.position.distance_to(locked) < 0.2 and enemy.visible_for_attack(), enemy.name + " fixed low endpoint visible for counter")
	_check(_knight.is_on_floor() and _knight.survival.current_health == 5, enemy.name + " walking evasion on firm floor costs zero HP, side %d" % side)
	await _face(-side)
	await _swing()
	_check(enemy.current_health == 1, enemy.name + " first grounded sword counter hits once")
	await _frames(24)
	_check(enemy.current_health == 1, enemy.name + " same swing never duplicates damage")
	await _swing()
	_check(enemy.current_health == 0 and enemy.state == CursedRaven.State.DEAD and not enemy.attack_source.active, enemy.name + " second counter defeats and clears source")
	_check(_knight.survival.current_health == 5, enemy.name + " two-counter strategy costs zero HP")

func _finish_ground_live(enemy: SkeletonPatrol) -> void:
	# Walk to the actual moving enemy, preserving all actors, health and timers.
	for frame: int in range(180):
		if absf(enemy.position.x - _knight.position.x) <= 22:
			break
		Input.action_press("move_right" if enemy.position.x > _knight.position.x else "move_left")
		await _frames(1)
	_release()
	for hit: int in range(3):
		await _swing()
		_check(enemy.current_health == 2-hit, "Continuous final ground counter %d uses actual current position" % (hit+1))
		await _frames(18)

func _finish_air_live(enemy: CursedRaven) -> void:
	# Approach until the actual warning, then evade/counter without moving fixtures.
	for frame: int in range(180):
		if enemy.state == CursedRaven.State.ALERT:
			break
		Input.action_press("move_right" if enemy.position.x > _knight.position.x else "move_left")
		await _frames(1)
	_release()
	_check(enemy.state == CursedRaven.State.ALERT, "Continuous final air approach reaches visible warning")
	await _frames(4) # Brake the approach before reversing; original Aren acceleration.
	var side: int = 1 if _knight.position.x > enemy.position.x else -1
	Input.action_press("move_right" if side > 0 else "move_left")
	await _frames(16)
	_release()
	await _frames(4)
	_check(await _wait_raven(enemy,CursedRaven.State.RECOVER), "Continuous final air dive completes before counter")
	await _face(-side)
	await _swing()
	_check(enemy.current_health == 1, "Continuous final air first real sword hit")
	await _frames(24)
	await _swing()
	_check(enemy.current_health == 0, "Continuous final air second real sword hit")
	# Finish recovery before the next input sequence.
	await _frames(20)

func _ray(a: Vector2, b: Vector2) -> bool:
	return not _knight.get_world_2d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters2D.create(a, b, 1)).is_empty()

func _traverse(direction: int, destination: float) -> bool:
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
		# Real live route: anticipate ground enemies; reserve bridge jumps for actual lips.
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
	Input.action_release(action)
	Input.action_release("jump")
	return false

func _run() -> void:
	var main: Node = (load("res://tests/fixtures/m3_b3_main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	_stage = main.get_node("ForgottenCemetery") as Node2D
	_knight = _stage.get_node("Knight") as KnightController
	_camera = _stage.get_node("Camera2D") as Camera2D
	_enemies = _stage.get_node("Enemies") as Node2D
	await _frames(5)
	_check(_enemies.get_child_count() == 6, "Exactly six planned enemies, no unplanned duplication")
	var counts: Array[int] = [0,0,0,0,0,0]
	for name: String in EXPECTED:
		var enemy: Node2D = _enemies.get_node(name) as Node2D
		_check(enemy.origin == EXPECTED[name] and enemy.target == _knight, name + " authored coordinate and live target")
		counts[_stage.sector_at(enemy.origin.x)] += 1
		_check(enemy.damage == 1 and enemy.current_health == (3 if enemy is SkeletonPatrol else 2), name + " homologated damage and HP")
		var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
		var rect: RectangleShape2D = RectangleShape2D.new()
		rect.size = Vector2(10,22) if enemy is SkeletonPatrol else Vector2(12,8)
		query.shape = rect
		query.transform = Transform2D(0, enemy.position + Vector2(0,-12) if enemy is SkeletonPatrol else enemy.position)
		query.collision_mask = 1
		_check(_knight.get_world_2d().direct_space_state.intersect_shape(query).is_empty(), name + " body clear of authored solids")
		_check(enemy.origin.distance_to(_stage.get_node("Spawn").position) > 600, name + " separated from real respawn")
	_check(counts == [0,1,1,1,1,2], "Sector counts 0/1/1/1/1/2; one crypt skeleton justified by floor length")
	var crypt: SkeletonPatrol = _enemies.get_node("CryptSkeleton") as SkeletonPatrol
	var bridge: CursedRaven = _enemies.get_node("BridgeRaven") as CursedRaven
	var final_ground: SkeletonPatrol = _enemies.get_node("CathedralSkeleton") as SkeletonPatrol
	var final_air: CursedRaven = _enemies.get_node("CathedralRaven") as CursedRaven
	_check(crypt.origin.x + crypt.patrol_left >= 1264 and crypt.origin.x + crypt.patrol_right <= 1392, "Crypt ground leash leaves stairs and landing margins clear")
	_check(bridge.detection_distance == 38 and bridge.patrol_half_width == 8 and bridge.max_dive_distance == 48, "Bridge uses local short detection, flight and dive bounds")
	_check(final_ground.origin.x + final_ground.patrol_left - 24 > 1984 + 64, "Final melee cannot attack directly at sector entry")
	_check(final_air.origin.x - final_air.patrol_half_width - final_air.detection_distance > 2080, "Final air detection allows isolating ground threat on left")
	var bounded: bool = true
	for frame: int in range(600):
		await _frames(1)
		for enemy: Node2D in _enemies.get_children():
			if enemy is SkeletonPatrol:
				bounded = bounded and enemy.position.x >= enemy.origin.x + enemy.patrol_left - 0.1 and enemy.position.x <= enemy.origin.x + enemy.patrol_right + 0.1 and absf(enemy.position.y - enemy.origin.y) < 0.2
			else:
				bounded = bounded and absf(enemy.position.x - enemy.origin.x) <= enemy.patrol_half_width + 0.1 and enemy.position.y == enemy.origin.y
			bounded = bounded and not enemy.attack_source.active
	_check(bounded and _knight.survival.current_health == 5, "Ten seconds of all live patrols stay bounded and cannot attack distant safe spawn")

	for side: int in [-1,1]:
		await _skeleton_counter(crypt,side)
		await _raven_counter(bridge,side)
	# No teleport, reset, healing or target changes between participants in either order.
	for repeat: int in range(2):
		await _place(final_ground.origin + Vector2(-20,0))
		await _face(1)
		await _finish_ground_live(final_ground)
		_check(final_air.current_health == 2 and not final_air.attack_source.active, "Final forward ground fight leaves air threat independent")
		await _finish_air_live(final_air)
		_check(final_ground.current_health == 0 and final_air.current_health == 0 and _knight.survival.current_health == 5, "Uninterrupted combined final forward costs zero HP, repetition %d" % repeat)
		await _place(final_air.origin + Vector2(24,44))
		await _finish_air_live(final_air)
		await _finish_ground_live(final_ground)
		_check(final_ground.current_health == 0 and final_air.current_health == 0 and _knight.survival.current_health == 5, "Uninterrupted combined final reverse costs zero HP, repetition %d" % repeat)

	# Recovery at authored bridge position, without killing it.
	await _place(Vector2(1532,156))
	_check(await _wait_raven(bridge,CursedRaven.State.ALERT), "Bridge recovery probe starts alert")
	await _face(-1)
	Input.action_press("move_left")
	await _frames(8)
	_release()
	_check(await _wait_raven(bridge,CursedRaven.State.RECOVER), "Bridge reaches recovery without passing floor")
	# Player stays beyond detection; recovery must return without target edits.
	await _place(Vector2(1480,172),false)
	_check(await _wait_raven(bridge,CursedRaven.State.PATROL), "Bridge physical recovery returns to patrol without getting stuck")

	# All six disrupted in different states; production M2 respawn restores all.
	for enemy: Node2D in _enemies.get_children():
		enemy.receive_hit()
		enemy.attack_source.set_active(true)
	_knight.receive_damage(999)
	await _frames(2)
	var stopped: bool = true
	for enemy: Node2D in _enemies.get_children(): stopped = stopped and not enemy.attack_source.active
	_check(stopped, "Aren DEAD cancels attacks across all six enemies")
	await _frames(60)
	var restored: bool = true
	for enemy: Node2D in _enemies.get_children():
		restored = restored and enemy.current_health == enemy.max_health and not enemy.attack_source.active and enemy.position.distance_to(enemy.origin) <= 20
	_check(restored and _knight.position.distance_to(Vector2(48,156)) < 0.1 and _knight.survival.current_health == 5, "M2 default respawn restores all enemies without immediate damage")
	_knight.receive_damage(1)
	for enemy: Node2D in _enemies.get_children(): enemy.receive_hit()
	_knight.position = Vector2(1740,300)
	await _frames(1)
	var fall_reset: bool = true
	for enemy: Node2D in _enemies.get_children(): fall_reset = fall_reset and enemy.current_health == enemy.max_health and not enemy.attack_source.active and enemy.position.distance_to(enemy.origin) < 0.1
	_check(fall_reset and _knight.survival.current_health == 4 and _knight.position.distance_to(Vector2(48,156)) < 0.1, "Alive bridge fall restores all six without healing or new checkpoint")
	await _place(Vector2(48,156))
	_check(await _traverse(1,2288), "Full uninterrupted live route reaches Cathedral marker")
	_check(_knight.survival.current_health == 5, "Fresh forward live route demonstrates zero-damage traversal")
	_check(_knight.active_checkpoint == null, "Future checkpoint marks remain nonfunctional")
	print("LIVE TURN enemy HP: ", _enemies.get_children().map(func(e: Node2D) -> int: return e.current_health))
	_check(await _traverse(-1,48), "Full uninterrupted return with live enemies and no teleport")
	# Independent reverse fixture starts with every enemy alive, not survivors only.
	await _place(Vector2(2288,156))
	var all_alive: bool = true
	for enemy: Node2D in _enemies.get_children(): all_alive = all_alive and enemy.current_health == enemy.max_health
	_check(all_alive, "Independent reverse starts with all six enemies alive")
	_check(await _traverse(-1,48), "Fresh reverse route with all six initially alive reaches safe start")
	_check(_knight.survival.current_health == 5, "Fresh reverse live route also demonstrates zero-damage traversal")
	_release()
	main.queue_free()
	await _frames(1)
	print("M3-B3 checks: ",_checks,"; failures: ",_failures)
	quit(0 if _failures == 0 else 1)
