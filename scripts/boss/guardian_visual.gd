extends Node2D
## Original atlas; visual segments are registered to the boss's new attack only.
const ART: Texture2D=preload("res://assets/art/m4a/guardian_poses.png")
const ATTACK_SCRIPT: GDScript=preload("res://scripts/boss/guardian_attack.gd")
const ROOTS: Array[Vector2]=[Vector2(330,555),Vector2(1025,555),Vector2(330,1180),Vector2(1010,1180)]
const REGIONS: Array[Rect2]=[Rect2(0,0,632,622),Rect2(632,0,632,622),Rect2(0,622,632,622),Rect2(632,622,632,622)]
const BLADE: Rect2=Rect2(450,875,286,65)
func _piece(rect: Rect2,root: Vector2,tint: Color) -> void:
 if rect.has_area():draw_texture_rect_region(ART,Rect2(((rect.position-root)*0.125).round(),(rect.size*0.125).round()),rect,tint)
func _without(rect: Rect2,cuts: Array[Rect2],anchor: Vector2,tint: Color) -> void:
 var pieces: Array[Rect2]=[rect]
 for omission: Rect2 in cuts:
  var next: Array[Rect2]=[]
  for piece: Rect2 in pieces:
   var cut: Rect2=piece.intersection(omission)
   if not cut.has_area():next.append(piece);continue
   next.append(Rect2(piece.position,Vector2(piece.size.x,cut.position.y-piece.position.y)))
   next.append(Rect2(Vector2(piece.position.x,cut.end.y),Vector2(piece.size.x,piece.end.y-cut.end.y)))
   next.append(Rect2(Vector2(piece.position.x,cut.position.y),Vector2(cut.position.x-piece.position.x,cut.size.y)))
   next.append(Rect2(Vector2(cut.end.x,cut.position.y),Vector2(piece.end.x-cut.end.x,cut.size.y)))
  pieces=next
 for piece: Rect2 in pieces:_piece(piece,anchor,tint)
func _arm(start: Vector2,finish: Vector2,region: Rect2,tint: Color) -> void:
 var delta: Vector2=finish-start
 draw_set_transform(start,delta.angle())
 draw_texture_rect_region(ART,Rect2(0,-4,delta.length(),8),region,tint)
 draw_set_transform(Vector2.ZERO)
func _draw() -> void:
 var boss: OathGuardian=get_parent() as OathGuardian
 var frame: int=0
 if boss.state in [OathGuardian.State.TELEGRAPH,OathGuardian.State.PHASE_TRANSITION]:frame=1
 elif boss.state==OathGuardian.State.ATTACK:frame=2
 elif boss.state in [OathGuardian.State.PUNISH,OathGuardian.State.HURT,OathGuardian.State.DEFEATED]:frame=3
 var tint: Color=Color(1.35,1.35,1.4)
 if boss.flash>0:tint=Color(2,1.3,1.2)
 if boss.state==OathGuardian.State.DEFEATED:tint=Color(0.55,0.62,0.65,0.85)
 if boss.phase==2 and boss.state!=OathGuardian.State.DEFEATED:tint*=Color(0.94,1.12,1.1)
 var articulation: bool=boss.pattern!=OathGuardian.Pattern.HEAVY and boss.state in [OathGuardian.State.TELEGRAPH,OathGuardian.State.ATTACK]
 if articulation:frame=2
 var rect: Rect2=REGIONS[frame]
 var anchor: Vector2=ROOTS[frame]
 if frame>=2:
  var cuts: Array[Rect2]=[BLADE]
  if articulation:cuts.append(Rect2(385,835,65,105))
  _without(rect,cuts,anchor,tint)
 else:_piece(rect,anchor,tint)
 if frame==2:
  var progress: float=1-boss.remaining/boss.active_seconds()
  var points: Array[Vector2]=ATTACK_SCRIPT.blade_points(boss.pattern,progress)
  var hilt: Vector2=points[0]
  var delta: Vector2=points[1]-hilt
  if articulation and boss.state==OathGuardian.State.TELEGRAPH:
   var load_progress: float=1-boss.remaining/boss.warning_seconds()
   if boss.pattern==OathGuardian.Pattern.CHARGE:
    hilt=Vector2(8,-24).lerp(Vector2(15,-14),load_progress);delta=Vector2(62,0).rotated(lerpf(-0.3,0,load_progress))
   elif boss.pattern==OathGuardian.Pattern.SWEEP:
    hilt=Vector2(8,-14);delta=Vector2(78,0).rotated(lerpf(-1.6,-0.08,load_progress))
   else:
    hilt=Vector2(12,-30);delta=Vector2(32,0).rotated(lerpf(-1.8,-1.2,load_progress))
  if articulation:
   # Reuse the original steel arm fragments; gauntlet stays at the weapon grip.
   var elbow: Vector2=Vector2(8,-30).lerp(hilt,0.4)
   _arm(Vector2(5,-42),elbow,Rect2(355,835,64,62),tint)
   _arm(elbow,hilt,Rect2(390,855,56,58),tint)
   draw_texture_rect_region(ART,Rect2(hilt-Vector2(3,4),Vector2(6,7)),Rect2(415,869,33,42),tint)
  draw_set_transform(hilt,delta.angle())
  draw_texture_rect_region(ART,Rect2(0,-5,delta.length(),10),BLADE,tint)
  draw_set_transform(Vector2.ZERO)
 if boss.state==OathGuardian.State.TELEGRAPH:
  draw_circle(Vector2(0,-70),3,Color("f3ce8e"))
  draw_line(Vector2(-3,-76),Vector2(3,-76),Color("f3ce8e"),1)
 if boss.state==OathGuardian.State.WAKE:
  draw_arc(Vector2(0,-26),34,0,TAU,24,Color("72b9b3"),1)

 if boss.phase==2 and boss.state!=OathGuardian.State.DEFEATED:
  # Oath fissures cling to the approved armor.
  draw_polyline(PackedVector2Array([Vector2(-3,-53),Vector2(0,-49),Vector2(-2,-44),Vector2(2,-39)]),Color("9de6d4"),1)
  draw_polyline(PackedVector2Array([Vector2(-10,-31),Vector2(-6,-28),Vector2(-7,-23)]),Color("77bcb9"),1)
 if boss.state==OathGuardian.State.PHASE_TRANSITION:
  var charge: float=1-boss.remaining/boss.transition_duration
  for i: int in range(7):
   var x: float=-22+i*7
   var height: float=8+fmod(i*11+charge*42,38)
   draw_polyline(PackedVector2Array([Vector2(x,0),Vector2(x-3,-height*0.4),Vector2(x+2,-height*0.7),Vector2(x,-height)]),Color(0.4,0.8,0.75,charge),1)
 if boss.state==OathGuardian.State.TELEGRAPH and boss.pattern!=OathGuardian.Pattern.HEAVY:
  var color: Color=Color("d1b5e1") if boss.pattern==OathGuardian.Pattern.SWEEP else Color("8fd6d1")
  if boss.pattern==OathGuardian.Pattern.CHARGE:
   for i: int in range(3):draw_polyline(PackedVector2Array([Vector2(22+i*8,-5),Vector2(26+i*8,-2),Vector2(22+i*8,1)]),color,1)
  elif boss.pattern==OathGuardian.Pattern.SWEEP:
   draw_arc(Vector2(8,-24),44,-1.4,0.15,12,color,1)
  else:
   draw_polyline(PackedVector2Array([Vector2(20,0),Vector2(24,-5),Vector2(28,0),Vector2(32,-5),Vector2(36,0)]),color,1)
