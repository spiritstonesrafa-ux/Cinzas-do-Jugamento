extends DamageSource
## Single travelling oath-flame: visible crystalline crest and physical 18x18 core.
const FLAME: Texture2D=preload("res://assets/art/m4b/oath_flame.png")
var direction: int=1
var guardian: OathGuardian
var travelled: float=0
var consumed: bool=false
var armed: bool=true
var age: float=0
const SPEED: float=110
const RANGE: float=170
var collider: CollisionShape2D
func _ready() -> void:
 collision_layer=32
 collision_mask=16
 monitoring=false
 process_physics_priority=-3
 collider=CollisionShape2D.new()
 var box: RectangleShape2D=RectangleShape2D.new()
 box.size=Vector2(18,18)
 collider.shape=box
 collider.position=Vector2(0,-9)
 add_child(collider)
func disarm() -> void:
 armed=false
 if is_instance_valid(collider):collider.set_deferred("disabled",true)
func _physics_process(delta: float) -> void:
 if not armed:return
 if not is_instance_valid(guardian) or not guardian.awake or guardian.target.survival.is_dead:
  disarm();queue_free();return
 var step: float=minf(SPEED*delta,RANGE-travelled)
 var query: PhysicsRayQueryParameters2D=PhysicsRayQueryParameters2D.create(global_position+Vector2(0,-9),global_position+Vector2(direction*(step+9),-9),1)
 if not get_world_2d().direct_space_state.intersect_ray(query).is_empty():
  disarm();queue_free();return
 position.x+=direction*step
 travelled+=step
 age+=delta
 if travelled>=RANGE:disarm();queue_free()
 queue_redraw()
func contact_damage(receiver_id: int) -> int:
 if not armed or consumed:return 0
 var player: KnightController=instance_from_id(receiver_id) as KnightController
 if player==null or player.survival.is_dead:return 0
 consumed=true
 return 1
func _draw() -> void:
 if not armed:return
 draw_set_transform(Vector2.ZERO,0,Vector2(direction,1))
 draw_texture_rect_region(FLAME,Rect2(-34,-24,48,24),Rect2(40,238,1432,550))
