class_name RespawnCheckpoint
extends Area2D
## Reusable trigger with an authored, independently positioned safe spawn marker.

signal activated

var active: bool = false
@onready var respawn_point: Marker2D = $RespawnPoint

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var knight: KnightController = body as KnightController
	if knight != null:
		knight.activate_checkpoint(self)

func set_active(value: bool) -> void:
	if active == value:
		return
	active = value
	queue_redraw()
	if active:
		activated.emit()

# Cosmetic time/activation feedback; never changes the checkpoint contract.
var _art_time: float = 0.0
var _art_active_last: bool = false
var _art_burst: float = 0.0

func _process(delta: float) -> void:
	_art_time += delta
	if active and not _art_active_last: _art_burst = 0.6
	_art_active_last = active
	_art_burst = maxf(0,_art_burst-delta)
	queue_redraw()

func _draw() -> void:
	var glow: Color = Color("f3ce8e") if active else Color("72b9b3")
	CemeterySpriteArt.draw(self,10,Rect2(-3,-35,22,35),Color(1.15,1.15,1.1,1))
	var center: Vector2=Vector2(8,-28)
	if active:
		draw_colored_polygon(PackedVector2Array([center+Vector2(0,-6),center+Vector2(4,0),center+Vector2(0,6),center+Vector2(-4,0)]),glow)
		draw_line(center+Vector2(0,-4),center+Vector2(-2,0),Color("fff0c8"),1)
	for index: int in range(8):
		var angle: float=index*TAU/8.0+_art_time*0.15
		var mark: Vector2=center+(Vector2.from_angle(angle)*14).round()
		draw_line(mark,mark+Vector2.from_angle(angle)*2,Color(glow,0.45),1)
	if _art_burst>0:
		for side: int in [-1,1]:
			draw_line(Vector2(side*(12+int((0.6-_art_burst)*18)),-10),Vector2(side*19,-14),Color(glow,_art_burst),1)
