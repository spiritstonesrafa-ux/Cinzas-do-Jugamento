class_name KnightController
extends CharacterBody2D
## M0 movement with an independent local M1 sword cycle.

enum MovementState { IDLE, RUN, JUMP, FALL }

@export var speed: float = 100.0
@export var acceleration: float = 1200.0
@export var deceleration: float = 1600.0
@export var gravity: float = 680.0
@export var jump_impulse: float = -230.0
@export var max_fall_speed: float = 360.0
@export_range(0.0, 0.3, 0.01) var coyote_time: float = 0.10
@export_range(0.0, 0.3, 0.01) var jump_buffer_time: float = 0.10

var state: MovementState = MovementState.IDLE
var facing: int = 1
var _coyote_remaining: float = 0.0
var _buffer_remaining: float = 0.0

@onready var visual: Node2D = $Visual
@onready var sword_attack: SwordAttack = $SwordAttack

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_coyote_remaining = coyote_time
	else:
		_coyote_remaining = maxf(0.0, _coyote_remaining - delta)
	_buffer_remaining = maxf(0.0, _buffer_remaining - delta)
	var jump_pressed: bool = Input.is_action_just_pressed("jump")
	if jump_pressed:
		_buffer_remaining = jump_buffer_time

	var direction: float = Input.get_axis("move_left", "move_right")
	var rate: float = acceleration if direction != 0.0 else deceleration
	velocity.x = move_toward(velocity.x, direction * speed, rate * delta)
	if direction != 0.0:
		facing = 1 if direction > 0.0 else -1
		visual.scale.x = float(facing)

	velocity.y = minf(velocity.y + gravity * delta, max_fall_speed)
	if (jump_pressed or _buffer_remaining > 0.0) and (is_on_floor() or _coyote_remaining > 0.0):
		velocity.y = jump_impulse
		_coyote_remaining = 0.0
		_buffer_remaining = 0.0

	move_and_slide()
	sword_attack.tick(delta, is_on_floor(), facing)
	visual.scale.x = float(facing if sword_attack.phase == SwordAttack.Phase.NEUTRAL else sword_attack.direction)
	_update_state()
	visual.queue_redraw()

func _update_state() -> void:
	if not is_on_floor():
		state = MovementState.JUMP if velocity.y < 0.0 else MovementState.FALL
	else:
		state = MovementState.RUN if absf(velocity.x) > 0.1 else MovementState.IDLE

func reset_to(spawn_position: Vector2) -> void:
	sword_attack.cancel()
	global_position = spawn_position
	velocity = Vector2.ZERO
	_coyote_remaining = 0.0
	_buffer_remaining = 0.0
	state = MovementState.IDLE
	facing = 1
	visual.scale.x = 1.0
	visual.queue_redraw()
