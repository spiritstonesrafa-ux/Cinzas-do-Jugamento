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
	var top: Vector2 = (anchor-position).round()
	draw_rect(Rect2(top-Vector2(5,3),Vector2(10,5)),Color("343a4c"))
	draw_rect(Rect2(top-Vector2(4,3),Vector2(8,1)),Color("a9a9a4"))
	draw_colored_polygon(PackedVector2Array([top+Vector2(-7,-1),top+Vector2(0,-7),top+Vector2(7,-1),top+Vector2(0,5)]),Color("777d77"))
	draw_rect(Rect2(top+Vector2(-1,-4),Vector2(3,6)),Color("343f46"))
	draw_rect(Rect2(top+Vector2(0,-4),Vector2(1,2)),Color("c6b991"))
	for y: int in range(int(top.y)+3,-7,5):
		draw_rect(Rect2(-1,y,3,5),Color("151b2a"))
		draw_line(Vector2(0,y),Vector2(0,y+3),Color("81909a"),1)
		draw_rect(Rect2(1,y+3,1,1),Color("c5c0a6"))
	# The authored disc still has exactly the homologated 20px visual diameter.
	CemeterySpriteArt.draw(self,9,Rect2(-10,-10,20,20),Color(1.3,1.3,1.2,1))
