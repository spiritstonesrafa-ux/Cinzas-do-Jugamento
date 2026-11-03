extends Node2D
## Original geometric placeholder, drawn on the internal pixel grid.

func _draw() -> void:
	var knight: KnightController = get_parent() as KnightController
	var stride: int = 0
	if knight.state == KnightController.MovementState.RUN:
		stride = 2 if int(knight.position.x / 5.0) % 2 == 0 else -2
	var airborne: bool = knight.state == KnightController.MovementState.JUMP or knight.state == KnightController.MovementState.FALL
	var cape_tail: int = -2 if airborne else 0
	draw_colored_polygon(PackedVector2Array([
		Vector2(-5, -21), Vector2(-10, -19), Vector2(-11 + cape_tail, -3),
		Vector2(-6, -5), Vector2(-3, -15)
	]), Color("693345"))
	# Sheath, hilt and guard: decorative rectangles only.
	draw_rect(Rect2(-9, -15, 3, 14), Color("302c3b"))
	draw_rect(Rect2(-9, -20, 2, 5), Color("c49b60"))
	draw_rect(Rect2(-11, -16, 6, 2), Color("a68857"))
	draw_rect(Rect2(-5, -9, 4, 8 + stride), Color("778798"))
	draw_rect(Rect2(1, -9, 4, 8 - stride), Color("a5b5bd"))
	draw_rect(Rect2(-6, -2 + stride, 6, 2), Color("39465c"))
	draw_rect(Rect2(1, -2 - stride, 6, 2), Color("39465c"))
	draw_rect(Rect2(-6, -20, 12, 12), Color("596d82"))
	draw_rect(Rect2(-3, -19, 7, 8), Color("a5b5bd"))
	draw_rect(Rect2(-6, -10, 12, 2), Color("9a7d59"))
	draw_rect(Rect2(3, -20, 5, 5), Color("c0cbd0"))
	draw_rect(Rect2(4, -15, 3, 6), Color("778798"))
	draw_rect(Rect2(-5, -28, 11, 9), Color("a5b5bd"))
	draw_rect(Rect2(-3, -29, 7, 2), Color("c0cbd0"))
	draw_rect(Rect2(0, -25, 6, 3), Color("202738"))
	draw_rect(Rect2(2, -24, 3, 1), Color("d7ad72"))
