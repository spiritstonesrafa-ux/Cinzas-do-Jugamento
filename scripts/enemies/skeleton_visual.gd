extends PixelCanvas
## FIX03 authored visual poses, bound only to the unchanged skeleton FSM.
func _draw() -> void:
 var actor: SkeletonPatrol=get_parent() as SkeletonPatrol
 if actor.state==SkeletonPatrol.State.DEAD: draw_set_transform(Vector2(0,-2),-PI/2)
 var frame: int=(absi(int(actor.position.x/4))%2) if actor.velocity.x!=0 else 0
 if actor.state==SkeletonPatrol.State.ATTACK:
  if actor.attack_phase==SkeletonPatrol.AttackPhase.WINDUP: frame=2
  elif actor.attack_phase==SkeletonPatrol.AttackPhase.ACTIVE: frame=3
  else: frame=0
 var tint: Color=Color(1.5,1.5,1.4,1) if actor.state==SkeletonPatrol.State.HURT else Color(1.12,1.12,1.08,1)
 CemeterySpriteArt.skeleton(self,frame,tint)
 if frame==2:
  r(0,-37,2,3,AMBER)
 elif frame==3:
  l(Vector2(16,-20),Vector2(27,-19),Color(SILVER,0.45))
 if actor.state==SkeletonPatrol.State.HURT:
  l(Vector2(-9,-23),Vector2(-13,-27),AMBER)
  l(Vector2(9,-7),Vector2(12,-3),LIGHT)
