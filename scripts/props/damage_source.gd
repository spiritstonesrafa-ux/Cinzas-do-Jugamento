class_name DamageSource
extends Area2D
## M2 contact contract; the default static hazard delivers one health point.

func contact_damage(_receiver_id: int) -> int:
	return 1

func _draw() -> void:
	draw_rect(Rect2(-12, -3, 24, 3), Color("693345"))
	for x: int in [-10, -2, 6]:
		draw_colored_polygon(PackedVector2Array([
			Vector2(x, -3), Vector2(x + 3, -12), Vector2(x + 6, -3)
		]), Color("d79072"))
