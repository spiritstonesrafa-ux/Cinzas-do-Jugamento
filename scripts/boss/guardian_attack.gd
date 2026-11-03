extends DamageSource
## Visible blade segment and physical box share coordinates. One M2 delivery per swing.
const HILT: Vector2=Vector2(15,-38)
const TIP: Vector2=Vector2(75,-12)
const THICKNESS: float=10
var active: bool=false
var consumed: bool=false
@onready var shape: CollisionShape2D=$CollisionShape2D
func set_direction(side: int) -> void:
 var center: Vector2=(HILT+TIP)*0.5
 position=Vector2(center.x*side,center.y)
 rotation=(TIP-HILT).angle()*side
func set_active(value: bool) -> void:
 active=value
 shape.set_deferred("disabled",not value)
 if not value:consumed=false
func contact_damage(receiver_id: int) -> int:
 if not active or consumed:return 0
 var player: KnightController=instance_from_id(receiver_id) as KnightController
 if player==null or player.survival.is_dead:return 0
 var ray: PhysicsRayQueryParameters2D=PhysicsRayQueryParameters2D.create(get_parent().global_position+Vector2(0,-28),player.global_position+Vector2(0,-12),1)
 if not get_world_2d().direct_space_state.intersect_ray(ray).is_empty():return 0
 consumed=true
 return 1
func _draw() -> void:
 pass
