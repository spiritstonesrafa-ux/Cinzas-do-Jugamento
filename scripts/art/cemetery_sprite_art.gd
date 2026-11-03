class_name CemeterySpriteArt
extends RefCounted
## Shared authored atlas, presentation only; no nodes, signals or collision shapes.
const TEXTURE: Texture2D = preload("res://assets/art/fix03/actors_props.png")
const FRAMES: Array[Rect2] = [
	Rect2(52,35,220,298),Rect2(455,34,161,304),Rect2(760,27,238,309),Rect2(1097,65,342,271),
	Rect2(46,385,248,285),Rect2(392,454,275,197),Rect2(751,504,291,187),Rect2(1126,483,281,141),
	Rect2(42,829,281,163),Rect2(413,779,260,258),Rect2(790,739,228,315),Rect2(1110,796,316,219)
]
const SKELETON_ROOTS: Array[Vector2] = [Vector2(220,333),Vector2(560,338),Vector2(930,336),Vector2(1288,336)]
const RAVEN_ROOTS: Array[Vector2] = [Vector2(185,580),Vector2(550,575),Vector2(913,580),Vector2(1273,565)]

static func draw(canvas: CanvasItem,index: int,destination: Rect2,tint: Color = Color.WHITE) -> void:
	canvas.draw_texture_rect_region(TEXTURE,destination,FRAMES[index],tint)

static func skeleton(canvas: CanvasItem,index: int,tint: Color) -> void:
	var source: Rect2 = FRAMES[index]
	canvas.draw_texture_rect_region(TEXTURE,Rect2(((source.position-SKELETON_ROOTS[index])*0.105).round(),(source.size*0.105).round()),source,tint)

static func raven(canvas: CanvasItem,index: int,tint: Color) -> void:
	var source: Rect2 = FRAMES[4+index]
	canvas.draw_texture_rect_region(TEXTURE,Rect2(((source.position-RAVEN_ROOTS[index])*0.096).round(),(source.size*0.096).round()),source,tint)
