class_name PixelCanvas
extends Node2D
## Original code-native pixel art. All final drawing coordinates use the logical grid.
const INK: Color = Color("10111f")
const DEEP: Color = Color("191b2d")
const SHADE: Color = Color("282b40")
const STONE: Color = Color("444957")
const EDGE: Color = Color("737d86")
const SILVER: Color = Color("b6c7cb")
const LIGHT: Color = Color("e5e3cc")
const GOLD: Color = Color("ba9865")
const AMBER: Color = Color("f3ce8e")
const WINE: Color = Color("733b51")
const RED: Color = Color("c96c72")
const TEAL: Color = Color("72b9b3")

func r(x: float,y: float,w: float,h: float,color: Color) -> void:
	if w > 0 and h > 0:
		draw_rect(Rect2(roundf(x),roundf(y),maxf(1,roundf(w)),maxf(1,roundf(h))),color)

func l(a: Vector2,b: Vector2,color: Color,width: float = 1) -> void:
	draw_line(a.round(),b.round(),color,width,false)

func p(points: Array[Vector2],color: Color) -> void:
	var snapped: PackedVector2Array = PackedVector2Array()
	for point: Vector2 in points: snapped.append(point.round())
	draw_colored_polygon(snapped,color)

func halo(center: Vector2,radius: int,color: Color) -> void:
	# Nested low-opacity steps, deliberately no blur, shader or light texture.
	for i: int in range(3,0,-1):
		draw_circle(center.round(),radius+i*3,Color(color,0.025),true,-1,false)

func candle(x: float,y: float,time: float) -> void:
	r(x-2,y-2,5,2,INK)
	r(x,y-8,2,6,GOLD)
	r(x,y-10,2,3,AMBER)
	r(x+1,y-12-int(time*7)%2,1,3,LIGHT)

func arch(x: float,y: float,w: float,h: float,frame: Color,inside: Color) -> void:
	p([Vector2(x,y+h),Vector2(x,y+h*0.36),Vector2(x+w*0.04,y+h*0.23),Vector2(x+w*0.16,y+h*0.12),Vector2(x+w*0.5,y),Vector2(x+w*0.84,y+h*0.12),Vector2(x+w*0.96,y+h*0.23),Vector2(x+w,y+h*0.36),Vector2(x+w,y+h)],frame)
	p([Vector2(x+3,y+h),Vector2(x+3,y+h*0.36),Vector2(x+w*0.08,y+h*0.25),Vector2(x+w*0.2,y+h*0.16),Vector2(x+w*0.5,y+5),Vector2(x+w*0.8,y+h*0.16),Vector2(x+w*0.92,y+h*0.25),Vector2(x+w-3,y+h*0.36),Vector2(x+w-3,y+h)],inside)
	r(x+w*0.5-1,y+8,2,h-8,frame)
	r(x+3,y+h*0.5,w-6,2,frame)
