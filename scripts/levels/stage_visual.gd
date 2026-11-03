extends Node2D
## Non-colliding background. All traversable geometry lives in the scene.

func _draw() -> void:
	draw_rect(Rect2(0, 0, 960, 180), Color("101722"))
	draw_circle(Vector2(83, 37), 15.0, Color("9caaa9"))
	draw_circle(Vector2(90, 33), 13.0, Color("101722"))
	for x: int in range(0, 960, 80):
		draw_rect(Rect2(x + 8, 50, 35, 110), Color("1b2533"))
		draw_colored_polygon(PackedVector2Array([
			Vector2(x + 5, 50), Vector2(x + 25, 29), Vector2(x + 46, 50)
		]), Color("1b2533"))
		draw_rect(Rect2(x + 21, 65, 8, 28), Color("101722"))
	for x: int in range(0, 960, 32):
		draw_rect(Rect2(x, 145, 25, 2), Color("273345"))
	# Marks on both edges make the gap readable against the dark background.
	draw_rect(Rect2(552, 152, 8, 4), Color("cf9c60"))
	draw_rect(Rect2(624, 152, 8, 4), Color("cf9c60"))
