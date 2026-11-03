class_name KnightHurtbox
extends Area2D
## Defensive contact query; never shares the sword's layer or shape.

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func has_damage_contact() -> bool:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = collision_shape.shape
	query.transform = collision_shape.global_transform
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false
	for result: Dictionary in get_world_2d().direct_space_state.intersect_shape(query):
		if result["collider"] is DamageSource:
			return true
	return false
