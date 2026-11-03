extends Node2D
## Original geometry; no downloaded art or imported skeleton sprites.

func _draw() -> void:
	var skeleton: SkeletonPatrol = get_parent() as SkeletonPatrol
	if skeleton.state == SkeletonPatrol.State.DEAD:
		draw_set_transform(Vector2(0, -2), -PI / 2.0)
	var bone: Color = Color("fff5d6") if skeleton.state == SkeletonPatrol.State.HURT else Color("c4c1ac")
	var step: int = 1 if int(skeleton.position.x / 4.0) % 2 == 0 else -1
	if skeleton.velocity.x == 0.0:
		step = 0
	draw_rect(Rect2(-5, -10, 3, 10 + step), bone)
	draw_rect(Rect2(2, -10, 3, 10 - step), bone)
	draw_rect(Rect2(-5, -20, 10, 11), Color("60686d"))
	for y: int in [-18, -15, -12]:
		draw_rect(Rect2(-3, y, 7, 1), bone)
	draw_rect(Rect2(-2, -21, 2, 13), bone)
	draw_rect(Rect2(-7, -20, 4, 5), Color("786f56"))
	draw_rect(Rect2(-7, -15, 2, 6), bone)
	draw_rect(Rect2(4, -20, 3, 9), bone)
	draw_rect(Rect2(-5, -29, 10, 9), bone)
	draw_rect(Rect2(-3, -26, 3, 3), Color("252a30"))
	draw_rect(Rect2(2, -26, 3, 3), Color("252a30"))
	draw_rect(Rect2(1, -22, 3, 2), Color("252a30"))
	if skeleton.state == SkeletonPatrol.State.ATTACK:
		match skeleton.attack_phase:
			SkeletonPatrol.AttackPhase.WINDUP:
				draw_rect(Rect2(7, -31, 2, 17), Color("d79072"))
			SkeletonPatrol.AttackPhase.ACTIVE:
				draw_rect(Rect2(7, -16, 21, 3), Color("f2be8b"))
			SkeletonPatrol.AttackPhase.RECOVERY:
				draw_line(Vector2(7, -12), Vector2(21, -4), Color("8c969b"), 2.0)
	else:
		draw_rect(Rect2(7, -14, 2, 14), Color("8c969b"))
