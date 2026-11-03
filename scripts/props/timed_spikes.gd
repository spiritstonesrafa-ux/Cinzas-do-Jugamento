class_name TimedSpikes
extends DamageSource
## M2 source with deterministic, visible warning; only ACTIVE has a shape.
enum State { SAFE, WARNING, ACTIVE, RECOVER }
@export_range(0.1,10.0,0.1) var safe_duration: float = 1.5
@export_range(0.2,10.0,0.1) var warning_duration: float = 0.6
@export_range(0.1,10.0,0.1) var active_duration: float = 0.8
@export_range(0.1,10.0,0.1) var recovery_duration: float = 0.4
var state: State = State.SAFE
var remaining: float = 1.5
@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	process_physics_priority = -2
	reset_hazard()

func reset_hazard() -> void:
	state = State.SAFE
	remaining = maxf(0.1,safe_duration)
	_sync()

func _physics_process(delta: float) -> void:
	remaining -= delta
	while remaining <= 0:
		state = ((int(state) + 1) % 4) as State
		remaining += maxf(0.1,[safe_duration,warning_duration,active_duration,recovery_duration][state])
	_sync()

func _sync() -> void:
	shape.disabled = state != State.ACTIVE
	queue_redraw()

func contact_damage(_receiver_id: int) -> int:
	return 1 if state == State.ACTIVE else 0

func _draw() -> void:
	var tint: Color = [Color("72b9b3"),Color("f3ce8e"),Color("e09583"),Color("7c839f")][state]
	draw_rect(Rect2(-12,-3,24,3),Color("242a3b"))
	draw_rect(Rect2(-12,-3,24,1),Color("8b847c"))
	for x: int in [-11,9]: draw_rect(Rect2(x,-2,2,2),Color("ba9865"))
	for x: int in [-7,-1,5]: draw_rect(Rect2(x,-2,3,1),tint)
	for x: int in [-10,-4,2,8]:
		draw_rect(Rect2(x,-3,3,1),Color("1a202e"))
	if state==State.SAFE or state==State.RECOVER:
		for x: int in [-7,5]: draw_rect(Rect2(x,-4,3,1),tint)
	if state == State.ACTIVE:
		CemeterySpriteArt.draw(self,11,Rect2(-12,-12,24,12),Color(1.25,1.25,1.2,1))
	elif state == State.WARNING:
		draw_line(Vector2(-11,-5),Vector2(11,-5),Color(tint,0.5),1)
		draw_rect(Rect2(-3,-22,7,16),Color("191b2d"))
		draw_rect(Rect2(-1,-21,3,7),tint)
		draw_rect(Rect2(-1,-12,3,2),Color("fff2d3"))
		for x: int in [-9,8]:
			draw_line(Vector2(x,-5),Vector2(x-2,-8),tint,1)
