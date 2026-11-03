extends PixelCanvas
## FIX02 original raster poses. Only observes homologated state; no physics writes.
const POSES: Texture2D = preload("res://assets/art/fix02/aren_poses.png")
# Authored sheet regions measured from alpha >= 96; fixed metadata avoids GPU readback.
const FRAME_RECTS: Array[Rect2] = [
 Rect2(86,18,230,386), Rect2(472,39,333,364),
 Rect2(935,38,283,366), Rect2(1387,38,343,362),
 Rect2(27,464,309,282), Rect2(472,460,305,387),
 Rect2(903,496,337,353), Rect2(1355,464,304,385)
]
var _time: float = 0.0
var _was_dead: bool = false
var _revive: float = 0.0

func _process(delta: float) -> void:
 _time += delta
 var hero: KnightController = get_parent() as KnightController
 if _was_dead and not hero.survival.is_dead: _revive = 0.55
 _was_dead = hero.survival.is_dead
 _revive = maxf(0,_revive-delta)
 queue_redraw()

func _draw() -> void:
 var hero: KnightController = get_parent() as KnightController
 if hero.sword_attack.phase != SwordAttack.Phase.NEUTRAL and not hero.survival.is_dead:
  _draw_attack(hero)
  return
 var frame: int = 0 if int(_time*3)%2==0 else 7
 match hero.state:
  KnightController.MovementState.RUN: frame = [1,2,3,2][int(_time*11)%4]
  KnightController.MovementState.JUMP: frame = 4
  KnightController.MovementState.FALL: frame = 5
 if hero.survival.invulnerability_remaining>0.63: frame = 6
 if hero.survival.is_dead: frame = 0
 var region: Rect2 = FRAME_RECTS[frame]
 var dimensions: Vector2 = (region.size*Vector2(1.2,1)*36.0/386.0).round()
 var destination: Rect2 = Rect2(Vector2(-roundf(dimensions.x*0.76),-36),dimensions)
 draw_texture_rect_region(POSES,destination,region,Color(1.4,1.43,1.38,1))
 if _revive>0:
  l(Vector2(-10,-1),Vector2(10,-1),Color(TEAL,_revive))
  r(-8,-16-int((0.55-_revive)*20),1,3,TEAL)
 if hero.survival.invulnerability_remaining>0.63:
  l(Vector2(-12,-23),Vector2(-16,-27),AMBER)
  l(Vector2(9,-14),Vector2(13,-17),LIGHT)

func _draw_attack(hero: KnightController) -> void:
 var attack: SwordAttack = hero.sword_attack
 var frame: int = ArenAttackArt.pose(attack)
 ArenAttackArt.draw_pose(self,frame)
 if attack.phase==SwordAttack.Phase.ACTIVE:
  # Horizontal, short and inside the original x=6..28/y=-21..-7 corridor.
  l(Vector2(10,-20),Vector2(27,-20),Color("c8d6d1",0.4))
  l(Vector2(12,-13),Vector2(25,-13),Color("f6ce94",0.32))
  if not attack._hit_targets.is_empty():
   r(24,-19,2,2,LIGHT)
   l(Vector2(24,-16),Vector2(27,-13),AMBER)
 if hero.survival.invulnerability_remaining>0.63:
  l(Vector2(-12,-23),Vector2(-16,-27),AMBER)
