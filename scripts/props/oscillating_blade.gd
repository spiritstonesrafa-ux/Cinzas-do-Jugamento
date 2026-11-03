class_name OscillatingBlade
extends DamageSource
## Vertical, deterministic damage area. Chain/anchor are harmless presentation.
@export var travel: Vector2 = Vector2(0,28)
@export_range(0.5,10.0,0.1) var period: float = 2.8
@export var anchor_offset: Vector2 = Vector2(0,-56)
var origin: Vector2
var elapsed: float = 0.0
var anchor: Vector2

func _ready() -> void:
	process_physics_priority = -2
	origin = position
	anchor = origin + anchor_offset
	reset_hazard()

func reset_hazard() -> void:
	elapsed = 0.0
	position = origin - travel
	queue_redraw()

func _physics_process(delta: float) -> void:
	elapsed = fmod(elapsed + delta, maxf(period,0.5))
	position = origin - travel * cos(TAU * elapsed / maxf(period,0.5))
	queue_redraw()

func _draw() -> void:
	draw_line(anchor - position,Vector2.ZERO,Color("89919e"),1)
	draw_rect(Rect2(anchor - position - Vector2(3,2),Vector2(6,4)),Color("b9a67a"))
	var points: PackedVector2Array = PackedVector2Array()
	for i: int in range(8):
		points.append(Vector2.from_angle(i * TAU / 8) * 10)
	draw_circle(Vector2.ZERO,10,Color("cb8d83"))
	draw_colored_polygon(points,Color("9f7077"))
	draw_circle(Vector2.ZERO,4,Color("505c70"))
	draw_line(Vector2(-6,-6),Vector2(6,6),Color("f0d1a2"),1)
