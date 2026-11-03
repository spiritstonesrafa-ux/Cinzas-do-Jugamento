extends SceneTree
## Run after importing: godot --headless --path . --script res://tests/smoke_test.gd
## Physics regression checks; does not replace interactive playtesting.

var _failures: int = 0

func _initialize() -> void:
	_run.call_deferred()

func _frames(count: int) -> void:
	for frame: int in range(count):
		await physics_frame
		await process_frame

func _check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)

func _run() -> void:
	var scene: PackedScene = load("res://tests/fixtures/baseline_main.tscn") as PackedScene
	if scene == null:
		push_error("Cannot load main scene")
		quit(1)
		return
	var main: Node = scene.instantiate()
	root.add_child(main)
	var stage: Node2D = main.get_node("PrototypeStage") as Node2D
	var knight: KnightController = stage.get_node("Knight") as KnightController
	var camera: Camera2D = stage.get_node("Camera2D") as Camera2D
	await _frames(5)
	_check(knight.is_on_floor(), "Safe spawn lands on solid ground")
	_check(stage.get_node("WorldGeometry").get_child_count() == 8, "Eight solid bodies instantiated")
	Input.action_press("move_right")
	await _frames(25)
	Input.action_release("move_right")
	_check(knight.position.x > 75.0 and knight.facing == 1, "Horizontal motion and facing right")
	Input.action_press("jump")
	await _frames(1)
	Input.action_release("jump")
	_check(knight.velocity.y < 0.0 and knight.state == KnightController.MovementState.JUMP, "Jump enters ascent")
	await _frames(60)
	_check(knight.is_on_floor(), "Jump lands without crossing floor")
	Input.action_press("move_left")
	await _frames(100)
	Input.action_release("move_left")
	_check(knight.position.x >= 5.9 and knight.position.x < 8.0, "Left wall blocks movement")
	_check(knight.facing == -1, "Facing left")
	_check(camera.position.x == 160.0, "Camera clamps at left edge")
	knight.reset_to(Vector2(930, 156))
	await _frames(5)
	Input.action_press("move_right")
	await _frames(30)
	Input.action_release("move_right")
	_check(knight.position.x <= 954.1, "Right wall blocks movement")
	_check(camera.position.x == 800.0, "Camera clamps at right edge")
	# Walk off the west edge of the pit and fall naturally.
	knight.reset_to(Vector2(540, 156))
	await _frames(3)
	Input.action_press("move_right")
	await _frames(35)
	Input.action_release("move_right")
	_check(not knight.is_on_floor(), "Pit has no invisible floor")
	var returned: bool = false
	for frame: int in range(90):
		await _frames(1)
		if knight.position.distance_to(Vector2(48, 156)) < 0.1:
			returned = true
			_check(knight.velocity == Vector2.ZERO, "Respawn clears velocity")
			_check(camera.position.x == 160.0, "Camera returns with player")
			break
	_check(returned, "Falling below stage returns to safe spawn")
	main.queue_free()
	await _frames(1)
	print("M0 physics checks finished; failures: ", _failures)
	quit(0 if _failures == 0 else 1)
