extends SceneTree
## Real Godot physics with original inputs. Isolated legs reset position;
## cemetery_test.gd independently proves the uninterrupted two-way route.

const ROUTE: Array[String] = [
	"GateFloor", "GraveSlabA", "GraveSlabB", "GraveSlabC", "GardenRise",
	"GardenDescent", "GardenRest", "CryptEntryUpper", "CryptEntryLower",
	"CryptFloor", "CryptExitLower", "CryptExitUpper", "BridgeApproach",
	"BridgeSpanA", "BridgeSpanB", "CathedralFloor"
]
const LAUNCH_OFFSETS: Array[float] = [8.0, 12.0, 16.0, 20.0]
var _checks: int = 0
var _failures: int = 0
var _knight: KnightController
var _stage: Node2D
var _camera: Camera2D
var _apex: float = 0.0
var _camera_ok: bool = true

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
	for action: String in ["move_right", "move_left", "jump"]:
		Input.action_release(action)

func _surface(name: String) -> Rect2:
	var body: StaticBody2D = _stage.get_node("WorldGeometry/" + name) as StaticBody2D
	var collider: CollisionShape2D = body.get_node("CollisionShape2D") as CollisionShape2D
	var shape: RectangleShape2D = collider.shape as RectangleShape2D
	return Rect2(collider.global_position - shape.size * 0.5, shape.size)

func _measure_jump(running: bool) -> Vector2:
	_release()
	_knight.reset_to(Vector2(160, 156)) # Broad, flat first-sector floor.
	await _frames(4)
	if running:
		Input.action_press("move_right")
		await _frames(20)
	var start: Vector2 = _knight.position
	Input.action_press("move_right")
	Input.action_press("jump")
	await _frames(1)
	Input.action_release("jump")
	var min_y: float = _knight.position.y
	for frame: int in range(90):
		await _frames(1)
		min_y = minf(min_y, _knight.position.y)
		if _knight.is_on_floor():
			break
	var result: Vector2 = Vector2(start.y - min_y, _knight.position.x - start.x)
	_release()
	return result

func _leg(from: Rect2, to: Rect2, direction: int, offset: float) -> bool:
	_release()
	var edge: float = from.end.x if direction > 0 else from.position.x
	_knight.reset_to(Vector2(edge - direction * (offset + 20.0), from.position.y))
	await _frames(4)
	var action: String = "move_right" if direction > 0 else "move_left"
	Input.action_press(action)
	for frame: int in range(40):
		if (_knight.position.x - (edge - direction * offset)) * direction >= 0.0:
			break
		await _frames(1)
	if not _knight.is_on_floor():
		_release()
		return false
	# The landing center is already inside the camera at takeoff.
	var landing: Vector2 = Vector2(to.position.x + 12.0 if direction > 0 else to.end.x - 12.0, to.position.y)
	var view: Rect2 = Rect2(_camera.position - Vector2(160, 90), Vector2(320, 180))
	var visible: bool = view.has_point(landing + Vector2(0, 8)) and view.has_point(landing + Vector2(0, -24))
	if not visible:
		print("CAMERA: landing=", landing, " viewport=", view)
	_camera_ok = _camera_ok and visible
	# Adjacent descending stairs need walking, not a jump that skips the tread.
	var adjacent_descent: bool = to.position.y > from.position.y and (
		absf(to.position.x - from.end.x) < 0.1 if direction > 0 else absf(from.position.x - to.end.x) < 0.1)
	if not adjacent_descent:
		Input.action_press("jump")
		await _frames(1)
		Input.action_release("jump")
	for frame: int in range(100):
		await _frames(1)
		var p: Vector2 = _knight.position
		if _knight.is_on_floor() and absf(p.y - to.position.y) < 0.2 and p.x >= to.position.x + 6.0 and p.x <= to.end.x - 6.0:
			_release()
			return true
		if p.y > 250.0 or (p.x - to.get_center().x) * direction > to.size.x:
			break
	_release()
	return false

func _run() -> void:
	var layout: String = "res://scenes/levels/forgotten_cemetery.tscn"
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--layout="):
			layout = argument.trim_prefix("--layout=")
	_stage = (load(layout) as PackedScene).instantiate() as Node2D
	root.add_child(_stage)
	_knight = _stage.get_node("Knight") as KnightController
	_camera = _stage.get_node("Camera2D") as Camera2D
	await _frames(5)
	var running: Vector2 = await _measure_jump(true)
	var standing: Vector2 = await _measure_jump(false)
	_apex = running.x
	print("MEASURE: running rise=", running.x, " center travel=", running.y,
		"; standing-start rise=", standing.x, " center travel=", standing.y)
	_check(running.x > 37.0 and running.x < 42.0, "Real maximum jump height measured without coyote time")
	_check(_knight.speed == 100.0 and _knight.gravity == 680.0 and _knight.jump_impulse == -230.0, "Homologated movement parameters preserved")
	var roof: Rect2 = _surface("CryptRoof")
	var floor_rect: Rect2 = _surface("CryptFloor")
	print("ROOF: rise from crypt floor=", floor_rect.position.y - roof.position.y, "; headroom=", floor_rect.position.y - roof.end.y)
	_check(floor_rect.position.y - roof.position.y > _apex, "CryptRoof top is intentionally outside jump reach; not a route platform")
	_check(floor_rect.position.y - roof.end.y > _apex + 24.0, "Roof leaves room for full jump with physical body underneath")
	for direction: int in [1, -1]:
		for step: int in range(ROUTE.size() - 1):
			var index: int = step if direction > 0 else ROUTE.size() - 1 - step
			var from_name: String = ROUTE[index]
			var to_name: String = ROUTE[index + direction]
			var from: Rect2 = _surface(from_name)
			var to: Rect2 = _surface(to_name)
			var passed: int = 0
			for offset: float in LAUNCH_OFFSETS:
				if await _leg(from, to, direction, offset):
					passed += 1
			var gap: float = maxf(0.0, to.position.x - from.end.x if direction > 0 else from.position.x - to.end.x)
			var rise: float = from.position.y - to.position.y
			print("LEG: ", from_name, " -> ", to_name, " gap=", gap, " rise=", rise, " landings=", passed, "/4")
			_check(passed == LAUNCH_OFFSETS.size(), "Four grounded approaches with full-body landing: " + from_name + " -> " + to_name)
	_check(_camera_ok, "All landing areas/body heights visible at takeoff in both directions")
	_stage.queue_free()
	await _frames(1)
	print("Reachability checks: ", _checks, "; failures: ", _failures, "; physical trials: 120")
	quit(0 if _failures == 0 else 1)
