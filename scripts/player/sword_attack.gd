class_name SwordAttack
extends Node2D
## Local M1 attack cycle. Physics queries include overlaps on the first active tick.

enum Phase { NEUTRAL, WINDUP, ACTIVE, RECOVERY }

@export_range(0.01, 1.0, 0.01) var windup_duration: float = 0.10
@export_range(0.01, 1.0, 0.01) var active_duration: float = 0.10
@export_range(0.01, 1.0, 0.01) var recovery_duration: float = 0.20

var phase: Phase = Phase.NEUTRAL
var direction: int = 1
var _remaining: float = 0.0
var _hit_targets: Array[int] = []

@onready var hitbox: Area2D = $Hitbox
@onready var hit_shape: CollisionShape2D = $Hitbox/CollisionShape2D

func tick(delta: float, grounded: bool, facing: int) -> void:
	# Check input before advancing the cycle: presses during recovery are discarded.
	if phase == Phase.NEUTRAL:
		if grounded and Input.is_action_just_pressed("attack"):
			direction = facing
			hitbox.position.x = 17.0 * direction
			_hit_targets.clear()
			phase = Phase.WINDUP
			_remaining = windup_duration
	else:
		_remaining -= delta
		if _remaining <= 0.00001:
			match phase:
				Phase.WINDUP:
					phase = Phase.ACTIVE
					_remaining += active_duration
				Phase.ACTIVE:
					phase = Phase.RECOVERY
					_remaining += recovery_duration
				Phase.RECOVERY:
					cancel()
	# No monitoring callbacks or cached overlap list: the query uses this tick's transform.
	hit_shape.disabled = phase != Phase.ACTIVE
	if phase == Phase.ACTIVE:
		_find_hits()
	queue_redraw()

func cancel() -> void:
	phase = Phase.NEUTRAL
	_remaining = 0.0
	_hit_targets.clear()
	direction = 1
	hit_shape.disabled = true
	queue_redraw()

func _find_hits() -> void:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = hit_shape.shape
	query.transform = hit_shape.global_transform
	query.collision_mask = hitbox.collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for result: Dictionary in space.intersect_shape(query):
		var target: SwordReceiver = result["collider"] as SwordReceiver
		if target == null or _hit_targets.has(target.get_instance_id()):
			continue
		if (target.global_position.x - global_position.x) * direction <= 0.0:
			continue
		if _blocked_by_world(space, target.global_position.x):
			continue
		_hit_targets.append(target.get_instance_id())
		target.receive_hit()

func _blocked_by_world(space: PhysicsDirectSpaceState2D, target_x: float) -> bool:
	# Conservative blade corridor, not just a ray: even thin/corner walls block.
	var corridor: RectangleShape2D = RectangleShape2D.new()
	corridor.size = Vector2(absf(target_x - global_position.x), 14.0)
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = corridor
	query.transform = Transform2D(0.0, Vector2((global_position.x + target_x) * 0.5, global_position.y - 14.0))
	query.collision_mask = 1 # World only; player and targets never block the blade.
	return not space.intersect_shape(query, 1).is_empty()

func _draw() -> void:
	if phase == Phase.NEUTRAL:
		return
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(float(direction), 1.0))
	match phase:
		Phase.WINDUP:
			draw_rect(Rect2(5, -31, 3, 18), Color("a5b5bd"))
			draw_rect(Rect2(2, -15, 9, 2), Color("c49b60"))
		Phase.ACTIVE:
			draw_rect(Rect2(7, -17, 21, 5), Color("e6dfba"))
			draw_rect(Rect2(8, -20, 2, 12), Color("c49b60"))
		Phase.RECOVERY:
			draw_line(Vector2(6, -12), Vector2(22, -3), Color("778798"), 3.0)
			draw_rect(Rect2(5, -15, 3, 7), Color("9a7d59"))
