class_name CemeteryCheckpoint
extends RespawnCheckpoint
## Stage-specific monotonic progress; M2 activation/safety/respawn unchanged.
@export_range(1,2,1) var progression_index: int = 1

func _on_body_entered(body: Node2D) -> void:
	var knight: KnightController = body as KnightController
	if knight == null:
		return
	var current: CemeteryCheckpoint = knight.active_checkpoint as CemeteryCheckpoint
	if current != null and current.progression_index > progression_index:
		return
	super._on_body_entered(body)

func _draw() -> void:
	super._draw()
	for index: int in range(progression_index):
		draw_line(Vector2(-2+index*3,-14),Vector2(-2+index*3,-9),Color("f3ce8e"),1)
