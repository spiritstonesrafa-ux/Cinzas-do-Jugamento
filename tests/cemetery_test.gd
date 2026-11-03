extends SceneTree
## Real input/physics traversal. No teleport on the forward or reverse route.

var _checks: int = 0
var _failures: int = 0
var _stage: Node2D
var _knight: KnightController
var _camera: Camera2D

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
	Input.action_press(action)
	for frame: int in range(2400):
		Input.action_release("jump")
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
		await _frames(1)
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
			Input.action_release(action)
			Input.action_release("jump")
			await _frames(30)
			_check(visited == ([0, 1, 2, 3, 4, 5] if direction > 0 else [5, 4, 3, 2, 1, 0]), "All six sectors traversed in order, direction %d" % direction)
			_check(crypt_seen, "Route actually descends underground, direction %d" % direction)
			_check(camera_valid, "Camera stays integer and inside bounds throughout traversal")
			return true
	Input.action_release(action)
	Input.action_release("jump")
	return false

func _run() -> void:
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	_stage = main.get_node("ForgottenCemetery") as Node2D
	_knight = _stage.get_node("Knight") as KnightController
	_camera = _stage.get_node("Camera2D") as Camera2D
	await _frames(5)
	_check(_knight.is_on_floor() and _knight.is_respawn_safe(Vector2(48, 156)), "Safe initial spawn with floor support")
	_check(_stage.get_node("HealthHUD/Life").text == "VIDA 5/5", "Existing M2 HUD bound")
	_check(_stage.get_node("WorldGeometry").get_child_count() == 19, "Nineteen authored solids loaded")
	_check(ProjectSettings.get_setting("display/window/size/viewport_width") == 320 and ProjectSettings.get_setting("display/window/size/viewport_height") == 180, "Internal viewport remains 320x180")
	_check(ProjectSettings.get_setting("display/window/stretch/scale_mode") == "integer", "Integer scaling preserved")
	for node: Node in _stage.get_children():
		_check(not node is RespawnCheckpoint and not node is DamageSource and not node is TrainingTarget, "No active checkpoint, hazard or target added: " + node.name)
	for marker: String in ["FutureCheckpoint1", "FutureCheckpoint2", "Finish"]:
		var point: Marker2D = _stage.get_node(marker) as Marker2D
		_check(point != null and _knight.is_respawn_safe(point.position), marker + " is a safe, non-trigger marker")
	var forward: bool = await _traverse(1, 2288.0)
	_check(forward and _knight.is_on_floor(), "Uninterrupted start-to-finish traversal with original movement")
	if forward:
		_check(_stage.get_node("StageHUD/Hint").text.contains("FIM PROVISÓRIO"), "Provisional finish is identified without boss or transition")
		_check(_knight.active_checkpoint == null, "Crossing future checkpoint marks never activates a checkpoint")
		Input.action_press("move_right")
		await _frames(60)
		Input.action_release("move_right")
		_check(_knight.position.x <= 2362.1 and _camera.position.x == 2208.0, "Right wall and camera end clamp")
		_check(await _traverse(-1, 48.0), "Full reverse route has no softlock")
	Input.action_press("move_left")
	await _frames(50)
	Input.action_release("move_left")
	_check(_knight.position.x >= 5.9 and _camera.position.x == 160.0, "Left wall and camera start clamp")
	# Explicit fall probes cover each independent gap; no health refill or damage.
	_knight.receive_damage(1)
	for point: Vector2 in [Vector2(464,156), Vector2(560,156), Vector2(656,156), Vector2(1624,156), Vector2(1740,156), Vector2(1860,156)]:
		_knight.reset_to(point)
		await _frames(5)
		_check(not _knight.is_on_floor(), "Gap has no invisible floor at x=%d" % int(point.x))
		var returned: bool = false
		for frame: int in range(100):
			await _frames(1)
			if _knight.position.distance_to(Vector2(48,156)) < 0.1:
				returned = true
				_check(_knight.velocity == Vector2.ZERO and _camera.position == Vector2(160,90), "Fall clears velocity and resets camera in same tick")
				break
		_check(returned and _knight.survival.current_health == 4, "Gap fall recovers at original spawn without healing")
	# Death still uses the existing survival signal and safe default, no new system.
	_knight.reset_to(Vector2(1320,220))
	await _frames(4)
	_check(_camera.position.y == 154.0, "Crypt camera reveals lower floor")
	_knight.receive_damage(999)
	await _frames(50)
	_check(_knight.position.distance_to(Vector2(48,156)) < 0.1 and _knight.survival.current_health == 5, "M2 death/respawn integration restores existing safe default")
	Input.action_press("attack")
	await _frames(1)
	Input.action_release("attack")
	_check(_knight.sword_attack.phase == SwordAttack.Phase.WINDUP, "M1 sword still starts after respawn")
	main.queue_free()
	await _frames(1)
	print("M3-A checks: ", _checks, "; failures: ", _failures)
	quit(0 if _failures == 0 else 1)
