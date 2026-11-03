class_name TrainingTarget
extends Area2D
## Non-solid practice dummy: hit feedback only, no health or offensive behavior.

@export var flash_duration: float = 0.14
var hit_count: int = 0
var flash_remaining: float = 0.0

func receive_hit() -> void:
	hit_count += 1
	flash_remaining = flash_duration
	queue_redraw()

func _physics_process(delta: float) -> void:
	if flash_remaining > 0.0:
		flash_remaining = maxf(0.0, flash_remaining - delta)
		queue_redraw()

func _draw() -> void:
	var flashing: bool = flash_remaining > 0.0
	var wood: Color = Color("efd99b") if flashing else Color("957052")
	draw_rect(Rect2(-2, -29, 4, 29), Color("65534b"))
	draw_rect(Rect2(-9, -3, 18, 3), Color("65534b"))
	draw_rect(Rect2(-7, -25, 14, 18), wood)
	draw_rect(Rect2(-10, -20, 20, 4), wood)
	draw_circle(Vector2(0, -16), 5.0, Color("fff5d6") if flashing else Color("5ba6a0"))
	draw_rect(Rect2(-4, -31, 8, 6), wood)
	if flashing:
		draw_line(Vector2(-11, -28), Vector2(-15, -32), Color("fff5d6"), 1.0)
		draw_line(Vector2(11, -28), Vector2(15, -32), Color("fff5d6"), 1.0)
