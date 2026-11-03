extends Node2D
## Original native geometric bird, separate from physical flight and damage.
func _draw() -> void:
	var raven: CursedRaven = get_parent() as CursedRaven
	if raven.state == CursedRaven.State.DEAD:
		draw_set_transform(Vector2.ZERO, PI / 2.0)
	var body: Color = Color("d9e6de") if raven.state == CursedRaven.State.HURT else Color("454b62")
	var wing: float = -11.0 if int(raven.flight_time * 8) % 2 == 0 else 5.0
	if raven.state == CursedRaven.State.DIVE:
		wing = -3.0
	if raven.state == CursedRaven.State.DEAD:
		wing = 2.0
	draw_colored_polygon(PackedVector2Array([Vector2(-3, -2), Vector2(-13, wing), Vector2(-8, 4), Vector2(1, 3)]), body)
	draw_rect(Rect2(-6, -4, 13, 9), body)
	draw_rect(Rect2(3, -7, 8, 7), body)
	draw_colored_polygon(PackedVector2Array([Vector2(10,-4), Vector2(16,-1), Vector2(10,0)]), Color("b9a67a"))
	draw_line(Vector2(-6, 2), Vector2(-12, 5), body, 3.0)
	draw_rect(Rect2(7, -5, 2, 2), Color("ef816f"))
	if raven.state == CursedRaven.State.ALERT:
		draw_rect(Rect2(0, -18, 2, 6), Color("f3bc72"))
		draw_rect(Rect2(0, -10, 2, 2), Color("f3bc72"))
	elif raven.state == CursedRaven.State.DIVE:
		draw_line(Vector2(-15, -3), Vector2(-8, -3), Color("cf8b9f"), 1.0)
	elif raven.state == CursedRaven.State.RECOVER:
		draw_rect(Rect2(-3, -1, 3, 1), Color("8b9ca5"))
