class_name DamageSource
extends Area2D
## Static test hazard. Each accepted contact costs exactly one health point.

func _draw() -> void:
	draw_rect(Rect2(-12, -3, 24, 3), Color("693345"))
	for x: int in [-10, -2, 6]:
		draw_colored_polygon(PackedVector2Array([
			Vector2(x, -3), Vector2(x + 3, -12), Vector2(x + 6, -3)
		]), Color("d79072"))
