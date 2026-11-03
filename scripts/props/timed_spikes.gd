class_name TimedSpikes
extends DamageSource
## M2 source with deterministic, visible warning; only ACTIVE has a shape.
enum State { SAFE, WARNING, ACTIVE, RECOVER }
@export_range(0.1,10.0,0.1) var safe_duration: float = 1.5
@export_range(0.2,10.0,0.1) var warning_duration: float = 0.6
@export_range(0.1,10.0,0.1) var active_duration: float = 0.8
@export_range(0.1,10.0,0.1) var recovery_duration: float = 0.4
var state: State = State.SAFE
var remaining: float = 1.5
@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	process_physics_priority = -2
	reset_hazard()

func reset_hazard() -> void:
	state = State.SAFE
	remaining = maxf(0.1,safe_duration)
	_sync()

func _physics_process(delta: float) -> void:
	remaining -= delta
	while remaining <= 0:
		state = ((int(state) + 1) % 4) as State
		remaining += maxf(0.1,[safe_duration,warning_duration,active_duration,recovery_duration][state])
	_sync()

func _sync() -> void:
	shape.disabled = state != State.ACTIVE
	queue_redraw()

func contact_damage(_receiver_id: int) -> int:
	return 1 if state == State.ACTIVE else 0

func _draw() -> void:
	var tint: Color = [Color("729f98"),Color("f2c67f"),Color("d79072"),Color("85839b")][state]
	draw_rect(Rect2(-12,-3,24,3),tint)
	if state == State.ACTIVE:
		for x: int in [-12,-4,4]:
			draw_colored_polygon(PackedVector2Array([Vector2(x,0),Vector2(x+4,-12),Vector2(x+8,0)]),tint)
	elif state == State.WARNING:
		draw_rect(Rect2(-1,-20,2,7),tint)
		draw_rect(Rect2(-1,-11,2,2),tint)
		for x: int in [-8,0,8]:
			draw_line(Vector2(x,-5),Vector2(x,-8),tint,1)
