extends PixelCanvas
## FIX03 original raven atlas; existing AI owns time, state, facing and motion.
func _draw() -> void:
 var bird: CursedRaven=get_parent() as CursedRaven
 if bird.state==CursedRaven.State.DEAD: draw_set_transform(Vector2.ZERO,PI/2)
 var frame: int=[0,1,2,1][int(bird.flight_time*10)%4]
 if bird.state==CursedRaven.State.DIVE: frame=3
 var tint: Color=Color(1.5,1.5,1.5,1) if bird.state==CursedRaven.State.HURT else Color(1.15,1.15,1.2,1)
 CemeterySpriteArt.raven(self,frame,tint)
 if bird.state==CursedRaven.State.ALERT:
  r(-2,-28,5,12,INK)
  r(0,-27,2,6,AMBER)
  r(0,-19,2,2,LIGHT)
 elif bird.state==CursedRaven.State.DIVE:
  l(Vector2(-17,-4),Vector2(-11,-4),Color("cf8a95"))
 elif bird.state==CursedRaven.State.RECOVER:
  r(-2,-18,4,1,TEAL)
 elif bird.state==CursedRaven.State.HURT:
  l(Vector2(-10,-9),Vector2(-13,-13),AMBER)
