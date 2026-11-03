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

func _draw() -> void:
	draw_rect(Rect2(-2, -33, 3, 33), Color("a5b5bd"))
	draw_rect(Rect2(1, -32, 13, 12), Color("d7ad72") if active else Color("5b8194"))
	draw_rect(Rect2(-6, -3, 12, 3), Color("596d82"))
	if active:
		draw_rect(Rect2(5, -29, 4, 6), Color("fff5d6"))
