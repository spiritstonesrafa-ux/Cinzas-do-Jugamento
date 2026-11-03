extends SceneTree
## Real cemetery/CharacterBody/input/contact integration; parameter probes are explicit.
var _checks: int = 0
var _failures: int = 0
var _stage: Node2D
var _knight: KnightController
var _enemy: SkeletonPatrol
var _defeats: int = 0

func _initialize() -> void:
	_run.call_deferred()

func _frames(count: int) -> void:
	for frame: int in range(count):
		await physics_frame
		await process_frame

func _check(value: bool, description: String) -> void:
	_checks += 1
	if value:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)

func _place(player_x: float, sees_player: bool = true) -> void:
	for action: String in ["attack", "move_left", "move_right", "jump"]:
		Input.action_release(action)
	_knight.reset_to(Vector2(player_x, 140))
	_knight.survival.restore()
	_enemy.reset_enemy()
	_enemy.target = _knight if sees_player else null
	await _frames(4)

func _swing() -> void:
	Input.action_press("attack")
	await _frames(1)
	Input.action_release("attack")
	await _frames(7)

func _spawn(position: Vector2) -> SkeletonPatrol:
	var extra: SkeletonPatrol = (load("res://scenes/enemies/skeleton_patrol.tscn") as PackedScene).instantiate() as SkeletonPatrol
	extra.position = position
	_stage.get_node("Enemies").add_child(extra)
	return extra

func _wait_respawn() -> bool:
	for frame: int in range(90):
		await _frames(1)
		if not _knight.survival.is_dead:
			return true
	return false

func _run() -> void:
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	_stage = main.get_node("ForgottenCemetery") as Node2D
	_knight = _stage.get_node("Knight") as KnightController
	_enemy = _stage.get_node("Enemies/SkeletonPatrol") as SkeletonPatrol
	_enemy.defeated.connect(func() -> void: _defeats += 1)
	_check(_enemy.state == SkeletonPatrol.State.IDLE and _enemy.current_health == 3, "Enemy starts IDLE with 3 HP")
	_check(_enemy.attack_source.shape.disabled and not _enemy.attack_source.active, "Initial offensive hitbox inactive")
	_check(_enemy.target == _knight and _enemy.origin == Vector2(744, 140), "Scene binds player and authored safe enemy origin")
	_check(_enemy.patrol_speed == 25 and _enemy.chase_speed == 35 and _enemy.attack_interval == 1.2, "Default movement and attack parameters")
	_enemy.target = null
	var min_x: float = 744.0
	var max_x: float = 744.0
	var turned: bool = false
	for frame: int in range(500):
		await _frames(1)
		min_x = minf(min_x, _enemy.position.x)
		max_x = maxf(max_x, _enemy.position.x)
		turned = turned or _enemy.facing == -1
	_check(turned and min_x < 720 and max_x > 775, "IDLE transitions to patrol and reverses direction")
	_check(min_x >= 704 and max_x <= 784 and _enemy.is_on_floor(), "Patrol remains inside configured limits")
	var edge_enemy: SkeletonPatrol = _spawn(Vector2(510, 144))
	edge_enemy.patrol_left = -200
	edge_enemy.patrol_right = 200
	var safe_edges: bool = true
	for frame: int in range(400):
		await _frames(1)
		safe_edges = safe_edges and edge_enemy.position.x >= 486 and edge_enemy.position.x <= 538 and edge_enemy.position.y < 145
	_check(safe_edges, "Floor probes stop patrol at both edges of a real cemetery slab")
	_knight.reset_to(Vector2(576, 156))
	edge_enemy.target = _knight
	await _frames(120)
	_check(edge_enemy.state == SkeletonPatrol.State.CHASE and edge_enemy.position.x <= 538 and edge_enemy.position.y < 145, "Chase also refuses to step into a real gap")
	edge_enemy.queue_free()
	var wall: StaticBody2D = StaticBody2D.new()
	wall.collision_layer = 1
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(4, 60)
	shape.shape = rect
	wall.position = Vector2(770, 110)
	wall.add_child(shape)
	_stage.add_child(wall)
	await _place(800)
	_check(_enemy.state != SkeletonPatrol.State.CHASE and _enemy.state != SkeletonPatrol.State.ATTACK, "World wall occludes player detection")
	_enemy.patrol_right = 150
	await _frames(180)
	_check(_enemy.position.x <= 762.1, "Patrol respects wall collision/probe")
	_enemy.patrol_right = 40
	wall.queue_free()
	await _frames(2)
	await _place(800)
	_check(_enemy.state == SkeletonPatrol.State.CHASE and _enemy.velocity.x > 0, "Within 85 px enemy detects and chases Aren")
	_knight.reset_to(Vector2(1000, 156))
	await _frames(15)
	_check(_enemy.state == SkeletonPatrol.State.CHASE, "Loss-of-target grace interval is honored")
	await _frames(50)
	_check(_enemy.state == SkeletonPatrol.State.IDLE or _enemy.state == SkeletonPatrol.State.PATROL, "Lost target returns to idle/patrol")
	_check(_enemy.position.x <= 784.1, "Chase cannot escape authored leash")
	await _place(700, false)
	Input.action_press("move_right")
	await _frames(55)
	Input.action_release("move_right")
	_check(_knight.position.x > _enemy.position.x + 12 and _knight.is_on_floor(), "Enemy body cannot impose a mandatory physical block on route")
	await _place(700)
	Input.action_press("move_right")
	Input.action_press("jump")
	await _frames(1)
	Input.action_release("jump")
	await _frames(54)
	Input.action_release("move_right")
	_check(_knight.position.x > 780 and _knight.survival.current_health == 5, "Real-input jump bypasses the live encounter without forced combat")

	await _place(764)
	_check(_enemy.state == SkeletonPatrol.State.ATTACK and _enemy.attack_phase == SkeletonPatrol.AttackPhase.WINDUP, "Attack range starts telegraphed windup")
	_check(_knight.survival.current_health == 5 and _enemy.attack_source.shape.disabled, "Windup cannot damage player")
	var gates: bool = true
	var active_seen: bool = false
	var recovery_seen: bool = false
	var starts: Array[int] = []
	var was_attack: bool = true
	for frame: int in range(225):
		await _frames(1)
		var attacking: bool = _enemy.state == SkeletonPatrol.State.ATTACK
		var active: bool = attacking and _enemy.attack_phase == SkeletonPatrol.AttackPhase.ACTIVE
		gates = gates and (_enemy.attack_source.active == active) and (_enemy.attack_source.shape.disabled != active)
		active_seen = active_seen or active
		recovery_seen = recovery_seen or (attacking and _enemy.attack_phase == SkeletonPatrol.AttackPhase.RECOVERY)
		if attacking and not was_attack:
			starts.append(frame)
		was_attack = attacking
	_check(gates and active_seen and recovery_seen, "Offensive shape active only during active phase, including recovery cleanup")
	_check(starts.size() >= 2 and starts[1] - starts[0] >= 72, "Consecutive attack starts respect 1.2-second cooldown")
	_check(_knight.survival.current_health == 2, "Three complete valid attacks remove exactly three points through M2")

	await _place(764)
	_knight.survival.invulnerability_duration = 0.01 # Explicit dedup probe, not production tuning.
	await _frames(40)
	_check(_knight.survival.current_health == 4, "Even protection shorter than active window cannot cause duplicate damage per swing")
	_knight.survival.invulnerability_duration = 0.8
	await _place(764)
	_knight.receive_damage(1)
	await _frames(50)
	_check(_knight.survival.current_health == 4, "Enemy contact respects existing M2 invulnerability")
	await _frames(50)
	_check(_knight.survival.current_health == 3, "Following valid swing can hurt after protection expires")
	await _place(724)
	await _frames(35)
	_check(_knight.survival.current_health == 4 and _enemy.facing == -1, "Enemy attacks left with exactly one point of damage")
	await _place(764)
	_knight.reset_to(Vector2(724, 140)) # Explicit behind-the-telegraph contact probe.
	await _frames(8)
	_check(_enemy.facing == 1 and _enemy.attack_source.position.x > 0, "Attack direction remains fixed during telegraph")
	await _frames(28)
	_check(_knight.survival.current_health == 5, "Aren behind the locked attack receives no damage")
	await _place(764)
	var barrier: StaticBody2D = StaticBody2D.new()
	barrier.collision_layer = 1
	var barrier_shape: CollisionShape2D = CollisionShape2D.new()
	var barrier_rect: RectangleShape2D = RectangleShape2D.new()
	barrier_rect.size = Vector2(2, 20)
	barrier_shape.shape = barrier_rect
	barrier.add_child(barrier_shape)
	barrier.position = Vector2(754, 126)
	_stage.add_child(barrier)
	await _frames(36)
	_check(_knight.survival.current_health == 5, "Wall appearing during telegraph blocks active enemy blade contacts")
	barrier.queue_free()
	await _frames(1)

	await _place(720)
	for hit: int in range(3):
		await _swing()
		_check(_enemy.current_health == 2 - hit, "Real M1 sword removes one enemy HP, swing %d" % hit)
		if hit < 2:
			_check(_enemy.state == SkeletonPatrol.State.HURT and not _enemy.attack_source.active, "Sword contact produces HURT and interrupts enemy attack")
		await _frames(30)
	_check(_enemy.state == SkeletonPatrol.State.DEAD and _defeats == 1, "Third sword hit defeats enemy exactly once")
	_check(_enemy.hurt_shape.disabled and _enemy.body_shape.disabled and _enemy.attack_source.shape.disabled, "Death disables offensive, defensive and body collisions")
	_enemy.receive_hit()
	_check(_defeats == 1 and _enemy.current_health == 0, "Dead enemy ignores late hit events")
	_knight.reset_to(_enemy.position + Vector2(20, 0))
	var hp: int = _knight.survival.current_health
	await _frames(150)
	_check(_knight.survival.current_health == hp and not _enemy.attack_source.active, "Dead enemy remains inert and cannot damage Aren")

	await _place(720, false)
	var sibling: SkeletonPatrol = _spawn(Vector2(748, 140))
	await _frames(3)
	await _swing()
	_check(_enemy.current_health == 2 and sibling.current_health == 2, "One player swing can hit each of two independent enemies exactly once")
	sibling.receive_hit()
	sibling.receive_hit()
	_check(sibling.state == SkeletonPatrol.State.DEAD and _enemy.current_health == 2, "One enemy death does not mutate sibling health/state")
	sibling.queue_free()
	await _frames(1)
	await _place(764)
	var attacker: SkeletonPatrol = _spawn(Vector2(748, 140))
	attacker.target = _knight
	await _frames(35)
	_check(_knight.survival.current_health == 4, "Two overlapping enemy swings respect one M2 protection interval")
	attacker.queue_free()
	await _frames(1)
	await _place(764)
	_knight.receive_damage(999)
	await _frames(2)
	_check(_enemy.state == SkeletonPatrol.State.IDLE and not _enemy.attack_source.active, "Living enemy cancels windup and ignores DEAD player")
	_check(await _wait_respawn(), "Respawn restores control after interrupted live encounter")
	await _place(720, false)
	_enemy.receive_hit()
	_enemy.receive_hit()
	_enemy.receive_hit()
	_knight.receive_damage(999)
	await _frames(2)
	_check(not _enemy.attack_source.active, "Enemies cannot attack while Aren is DEAD")
	_check(await _wait_respawn(), "Existing M2 death timer/respawn completes")
	_check(_enemy.state == SkeletonPatrol.State.IDLE and _enemy.current_health == 3 and _enemy.position == _enemy.origin and _enemy.velocity == Vector2.ZERO, "Player death respawn deterministically restores enemy initial state")
	_check(_enemy.attack_phase == SkeletonPatrol.AttackPhase.WINDUP and _enemy.facing == 1 and _enemy.attack_source.position == Vector2(17,-14), "Enemy reset restores initial attack phase, direction and source transform")
	_check(_knight.survival.current_health == 5 and _knight.position.distance_to(Vector2(48,156)) < 0.1, "Player still uses M2 safe spawn and full health")
	_enemy.receive_hit()
	_knight.receive_damage(1)
	_knight.position = Vector2(560, 300)
	await _frames(1)
	_check(_enemy.current_health == 3 and _enemy.position == _enemy.origin and not _enemy.attack_source.active, "Alive fall also restores enemies and clears attack contact caches")
	_check(_knight.survival.current_health == 4 and _knight.position.distance_to(Vector2(48,156)) < 0.1, "Alive fall retains original no-healing rule")
	main.queue_free()
	await _frames(1)
	print("M3-B1 checks: ", _checks, "; failures: ", _failures)
	quit(0 if _failures == 0 else 1)
