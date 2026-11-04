extends Node2D
const BACK: Texture2D=preload("res://assets/art/fix03/cathedral_background.png")
const STONE: Texture2D=preload("res://assets/art/fix02/surface_materials.png")
func _ready() -> void:
 texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 get_parent().get_node("Guardian").state_changed.connect(func(_value: int) -> void:queue_redraw())
func _draw() -> void:
 var guardian: OathGuardian=get_parent().get_node("Guardian") as OathGuardian
 var calm: float=0
 if guardian.state==OathGuardian.State.DEFEATED and guardian.get_node("Conclusion").played:
  calm=clampf(guardian.get_node("Conclusion").elapsed/2.6,0,1)
 draw_texture_rect(BACK,Rect2(0,0,320,180),false,Color(0.74,0.78,0.9).lerp(Color(0.84,0.87,0.95),calm))
 draw_rect(Rect2(0,0,320,180),Color(0.025,0.045,0.065,0.15))
 var half: Vector2=STONE.get_size()*0.5
 for x: int in [0,304]:
  for y: int in range(20,156,32):
   var height: float=minf(32,156-y)
   draw_texture_rect_region(STONE,Rect2(x,y,16,height),Rect2(Vector2(half.x,0),Vector2(half.x*0.5,half.y*height/32)),Color("849398"))
 for x: int in range(0,320,48):
  var width: float=minf(48,320-x)
  draw_texture_rect_region(STONE,Rect2(x,156,width,24),Rect2(Vector2(half.x,0),Vector2(half.x*width/48,half.y*24/32)),Color("8d9c9b"))
 draw_rect(Rect2(0,156,320,2),Color("9ba9a6"))
 for x: int in range(16,320,32):
  draw_rect(Rect2(x,158,3,1),Color("ba9865"))
 if guardian.state==OathGuardian.State.DEFEATED:
  draw_rect(Rect2(0,92,24,64),Color("14222f"))
  draw_arc(Vector2(14,120),10,0,TAU,24,Color("72b9b3"),1)
  draw_line(Vector2(7,120),Vector2(21,120),Color("ba9865"),1)
  draw_line(Vector2(14,113),Vector2(14,127),Color("ba9865"),1)
  draw_line(Vector2(0,155),Vector2(28,155),Color("72b9b3"),1)