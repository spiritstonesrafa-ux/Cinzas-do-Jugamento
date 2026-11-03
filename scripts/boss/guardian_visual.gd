extends Node2D
## Original atlas; visual segments are registered to the boss's new attack only.
const ART: Texture2D=preload("res://assets/art/m4a/guardian_poses.png")
const ATTACK_SCRIPT: GDScript=preload("res://scripts/boss/guardian_attack.gd")
const ROOTS: Array[Vector2]=[Vector2(330,555),Vector2(1025,555),Vector2(330,1180),Vector2(1010,1180)]
const REGIONS: Array[Rect2]=[Rect2(0,0,632,622),Rect2(632,0,632,622),Rect2(0,622,632,622),Rect2(632,622,632,622)]
const BLADE: Rect2=Rect2(450,875,286,65)
func _piece(rect: Rect2,root: Vector2,tint: Color) -> void:
 if rect.has_area():draw_texture_rect_region(ART,Rect2(((rect.position-root)*0.125).round(),(rect.size*0.125).round()),rect,tint)
func _draw() -> void:
 var boss: OathGuardian=get_parent() as OathGuardian
 var frame: int=0
 if boss.state==OathGuardian.State.TELEGRAPH:frame=1
 elif boss.state==OathGuardian.State.ATTACK:frame=2
 elif boss.state in [OathGuardian.State.PUNISH,OathGuardian.State.HURT,OathGuardian.State.DEFEATED]:frame=3
 var tint: Color=Color(1.35,1.35,1.4)
 if boss.flash>0:tint=Color(2,1.3,1.2)
 if boss.state==OathGuardian.State.DEFEATED:tint=Color(0.55,0.62,0.65,0.85)
 var rect: Rect2=REGIONS[frame]
 var anchor: Vector2=ROOTS[frame]
 if frame>=2:
  # Remove neighbor blade / old placement without touching source pixels.
  var cut: Rect2=rect.intersection(BLADE)
  _piece(Rect2(rect.position,Vector2(rect.size.x,cut.position.y-rect.position.y)),anchor,tint)
  _piece(Rect2(Vector2(rect.position.x,cut.end.y),Vector2(rect.size.x,rect.end.y-cut.end.y)),anchor,tint)
  _piece(Rect2(Vector2(rect.position.x,cut.position.y),Vector2(cut.position.x-rect.position.x,cut.size.y)),anchor,tint)
  _piece(Rect2(Vector2(cut.end.x,cut.position.y),Vector2(rect.end.x-cut.end.x,cut.size.y)),anchor,tint)
 else:_piece(rect,anchor,tint)
 if frame==2:
  var hilt: Vector2=ATTACK_SCRIPT.HILT
  var delta: Vector2=ATTACK_SCRIPT.TIP-hilt
  draw_set_transform(hilt,delta.angle())
  draw_texture_rect_region(ART,Rect2(0,-5,delta.length(),10),BLADE,tint)
  draw_set_transform(Vector2.ZERO)
 if boss.state==OathGuardian.State.TELEGRAPH:
  draw_circle(Vector2(0,-70),3,Color("f3ce8e"))
  draw_line(Vector2(-3,-76),Vector2(3,-76),Color("f3ce8e"),1)
 if boss.state==OathGuardian.State.WAKE:
  draw_arc(Vector2(0,-26),34,0,TAU,24,Color("72b9b3"),1)
