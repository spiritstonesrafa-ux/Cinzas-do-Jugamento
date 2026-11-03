class_name RavenAttackSource
extends DamageSource
## M2 contact delivery, enabled only for a single straight dive at a time.
var damage: int = 1
var active: bool = false
var _consumed: bool = false
@onready var shape: CollisionShape2D = $CollisionShape2D

func set_active(value: bool) -> void:
	active = value
	shape.disabled = not value
	if not value:
		_consumed = false

func contact_damage(receiver_id: int) -> int:
	if not active or _consumed:
		return 0
	var receiver: KnightController = instance_from_id(receiver_id) as KnightController
	if receiver == null or receiver.survival.is_dead:
		return 0
	var ray: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position, receiver.global_position + Vector2(0, -12), 1)
	if not get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
		return 0
	_consumed = true # Protected contacts consume the attack too, as in B1.
	return maxi(0, damage)

func _draw() -> void:
	pass # The raven visual supplies the attack presentation.
