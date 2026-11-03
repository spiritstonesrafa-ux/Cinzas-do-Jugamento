extends PixelCanvas
## M3-D: original layered cemetery composition; never writes physics/camera properties.
@export var show_future_checkpoint_marks: bool = true
var _time: float = 0.0
var _surfaces: Array[Dictionary] = []
var _view: Rect2 = Rect2(0,0,320,180)
var _art_frame: int = -1
const GARDEN_ART: Texture2D = preload("res://assets/art/fix02/garden_background.png")
const CRYPT_ART: Texture2D = preload("res://assets/art/fix02/crypt_background.png")
const GATE_ART: Texture2D = preload("res://assets/art/fix03/gate_background.png")
const GRAVES_ART: Texture2D = preload("res://assets/art/fix03/graves_background.png")
const BRIDGE_ART: Texture2D = preload("res://assets/art/fix03/bridge_background.png")
const CATHEDRAL_ART: Texture2D = preload("res://assets/art/fix03/cathedral_background.png")
const PANELS: Array[Dictionary] = [
	{"texture":GATE_ART,"region":Rect2(-64,0,480,288),"canvas":Rect2(-64,-8,480,256),"parallax":0.08},
	{"texture":GRAVES_ART,"region":Rect2(352,0,448,288),"canvas":Rect2(320,-8,512,256),"parallax":0.08},
	{"texture":GARDEN_ART,"region":Rect2(736,0,448,288),"canvas":Rect2(720,-8,480,240),"parallax":0.08},
	{"texture":CRYPT_ART,"region":Rect2(1120,0,416,288),"canvas":Rect2(1104,24,448,248),"parallax":0.035},
	{"texture":BRIDGE_ART,"region":Rect2(1472,0,544,288),"canvas":Rect2(1472,-8,544,272),"parallax":0.06},
	{"texture":CATHEDRAL_ART,"region":Rect2(1952,0,480,288),"canvas":Rect2(1952,-8,480,256),"parallax":0.05}
]

func _ready() -> void:
	# DISPLAY01: detailed backgrounds/ground only; actors and HUD retain Nearest.
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var world: Node = get_parent().get_node("WorldGeometry")
	for body: Node2D in world.get_children():
		var shape: CollisionShape2D = body.get_node("CollisionShape2D") as CollisionShape2D
		var rectangle: RectangleShape2D = shape.shape as RectangleShape2D
		_surfaces.append({"name":String(body.name),"rect":Rect2(shape.global_position-rectangle.size*0.5,rectangle.size)})
		# Replace only the two old flat Polygon2D skins, not their parent/collider.
		for visual_name: String in ["Block","Rim"]:
			var visual: CanvasItem = body.get_node_or_null(visual_name) as CanvasItem
			if visual != null: visual.visible = false
	var roof_hint: CanvasItem = world.get_node_or_null("CryptRoof/RoofHint") as CanvasItem
	if roof_hint != null: roof_hint.visible = false
	# Ground commands are cached separately; only rebuild when the view crosses a cell.
	var ground: Node2D = (load("res://scripts/art/ground_skin.gd") as GDScript).new() as Node2D
	ground.name = "GroundSkin"
	add_child(ground)
	var interface: Node2D = (load("res://scripts/ui/cemetery_interface.gd") as GDScript).new() as Node2D
	interface.name = "Presentation"
	get_parent().get_node("StageHUD").add_child(interface)


func _process(delta: float) -> void:
	_time += delta
	var previous_view: Rect2 = _view
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera != null:
		_view = Rect2(camera.get_screen_center_position().round()-Vector2(160,90),Vector2(320,180))
	# Ambient animation is intentionally stepped; retain cached commands while idle.
	# Camera motion still redraws on every changed logical pixel, without lag.
	var art_frame: int = int(_time*7)
	if _view != previous_view or art_frame != _art_frame:
		_art_frame = art_frame
		queue_redraw()

func _moon(center: Vector2) -> void:
	halo(center,19,TEAL)
	for y: int in range(-18,19):
		var width: int = int(sqrt(maxf(0,18*18-y*y)))
		r(center.x-width,center.y+y,width*2,1,Color("9caaa8") if y < 4 else Color("80949a"))
	for dot: Vector2 in [Vector2(-6,-5),Vector2(6,8),Vector2(8,-8),Vector2(-9,5)]:
		r(center.x+dot.x,center.y+dot.y,3,2,Color("71838c"))

func _tree(x: float,y: float,height: float,tint: Color) -> void:
	p([Vector2(x-5,y),Vector2(x-2,y-height),Vector2(x+1,y-height-3),Vector2(x+3,y)],tint)
	for side: int in [-1,1]:
		l(Vector2(x,y-height*0.52),Vector2(x+side*16,y-height*0.72),tint,3)
		l(Vector2(x+side*16,y-height*0.72),Vector2(x+side*25,y-height*0.89),tint,2)
		l(Vector2(x+side*16,y-height*0.72),Vector2(x+side*29,y-height*0.69),tint,1)
		l(Vector2(x,y-height*0.78),Vector2(x+side*10,y-height*0.96),tint,2)
	l(Vector2(x-8,y),Vector2(x+9,y),tint,2)

func _grave(x: float,y: float,variant: int) -> void:
	var tint: Color = Color("4c5261")
	r(x-9,y-3,19,3,Color("333c4b"))
	if variant % 3 == 0:
		r(x-2,y-26,5,24,tint)
		r(x-8,y-20,17,4,tint)
		r(x-1,y-25,1,22,Color("6d747b"))
	else:
		p([Vector2(x-7,y-3),Vector2(x-8,y-20),Vector2(x-4,y-25),Vector2(x+4,y-25),Vector2(x+7,y-19),Vector2(x+6,y-3)],tint)
		l(Vector2(x-6,y-19),Vector2(x-4,y-23),Color("788188"))
		r(x-4,y-16,8,1,Color("303b4b"))
		r(x-3,y-13,5,1,Color("303b4b"))
		r(x-1,y-8,3,4,Color("384b50"))
	if int(x)%5 < 2:
		l(Vector2(x-5,y-3),Vector2(x-3,y-12),Color("627269"))
		r(x-7,y-5,4,1,Color("677364"))
	if int(x)%7 < 3:
		l(Vector2(x+3,y-19),Vector2(x,y-13),Color("272d3b"))
		l(Vector2(x,y-13),Vector2(x+2,y-9),Color("272d3b"))

func _iron_fence(start: int,end: int,y: int) -> void:
	l(Vector2(start,y-12),Vector2(end,y-12),Color("424b59"))
	l(Vector2(start,y-23),Vector2(end,y-23),Color("424b59"))
	for x: int in range(start,end,10):
		if x < _view.position.x-20 or x > _view.end.x+20: continue
		r(x,y-31,2,31,Color("3f4857"))
		p([Vector2(x-2,y-30),Vector2(x+1,y-35),Vector2(x+4,y-30)],Color("65707b"))

func _mausoleum(x: int,y: int) -> void:
	r(x,y-55,64,55,Color("30394b"))
	p([Vector2(x-5,y-55),Vector2(x+32,y-74),Vector2(x+69,y-55)],Color("465164"))
	l(Vector2(x-5,y-55),Vector2(x+32,y-74),Color("6c747d"))
	r(x-3,y-54,70,4,Color("515a69"))
	arch(x+22,y-44,22,44,Color("5d6573"),Color("171f31"))
	for px: int in [x+5,x+53]:
		r(px,y-48,6,48,Color("515966"))
		r(px,y-48,2,48,Color("727a80"))
		r(px-2,y-48,10,3,Color("7d8284"))
	r(x-4,y-4,72,4,Color("53616b"))
	for row: int in range(4):
		l(Vector2(x+12,y-46+row*10),Vector2(x+19,y-46+row*10),Color("4c5360"))
		l(Vector2(x+46,y-40+row*9),Vector2(x+51,y-40+row*9),Color("4c5360"))
	for leaf: int in range(8):
		var px: int = x+59+leaf%3
		var py: int = y-45+leaf*5
		r(px,py,1,6,Color("3e5555"))
		r(px-2,py,3,2,Color("596b60"))
		r(px+1,py+3,3,2,Color("465b54"))


func _cathedral() -> void:
	# Distinctive split spires, amber broken lancets, reliquary seal and great doors.
	var x: int = 2200
	r(x,0,168,156,Color("252a3a"))
	for tower: int in [x-34,x+112]:
		r(tower,12,28,144,Color("3b4050"))
		p([Vector2(tower-4,14),Vector2(tower+13,-22),Vector2(tower+32,14)],Color("535564"))
		l(Vector2(tower+13,-22),Vector2(tower+32,14),Color("85818a"))
		for row: int in range(4):
			r(tower+3,28+row*29,22,2,Color("555968"))
		arch(tower+8,22,11,30,Color("6b6873"),Color("393547"))
	for window: int in [2210,2302]:
		arch(window,13,30,66,Color("69616a"),Color("211d33"))
		for row: int in range(4):
			r(window+5,35+row*9,7,6,Color("9b6c67") if row%2 else Color("b39770"))
			r(window+17,28+row*11,7,7,Color("687c89"))
		l(Vector2(window+14,24),Vector2(window+14,76),Color("4e4658"),2)
	arch(2250,48,46,108,Color("74707b"),Color("181c2b"))
	arch(2255,55,36,101,Color("484757"),Color("252638"))
	for door: int in range(2259,2290,5):
		r(door,88,3,67,Color("353344"))
		r(door,91,1,62,Color("5c5360"))
	for row: int in [100,132]:
		r(2256,row,35,3,Color("82705f"))
		for stud: int in range(2260,2290,8): r(stud,row,1,1,AMBER)
	r(2271,83,2,72,Color("a58a68"))
	# Rose seal, rendered in stepped stone and stained glass.
	for row: int in range(-10,11):
		var width: int = int(sqrt(maxf(0,100-row*row)))
		r(2273-width,25+row,width*2,1,Color("6e6571"))
	p([Vector2(2273,16),Vector2(2280,25),Vector2(2273,34),Vector2(2266,25)],Color("ba9174"))
	l(Vector2(2264,25),Vector2(2282,25),Color("303043"),2)
	l(Vector2(2273,15),Vector2(2273,35),Color("303043"),2)
	r(2242,152,62,4,Color("7e7c81"))
	for stair: int in range(3):
		r(2228+stair*4,148-stair*3,16-stair*4,2,Color("565b69"))
	candle(2245,156,_time)
	candle(2302,156,_time+0.2)

func _crypt() -> void:
	r(1152,0,352,288,Color("171f2b"))
	for row: int in range(0,29):
		for col: int in range(6):
			var x: int = 1140+col*64+(row%2)*32
			var y: int = row*10
			if x+64 < _view.position.x or x > _view.end.x: continue
			r(x+1,y+1,62,8,Color("202b36") if (col+row)%3 else Color("25313b"))
	for x: int in [1172,1240,1320,1400,1472]:
		arch(x-24,128,48,92,Color("34404b"),Color("101a27"))
		r(x-27,142,6,78,Color("42505a"))
		r(x-27,142,2,78,Color("59666c"))
		r(x-29,140,10,4,Color("59616a"))
		# Ossuary recesses with subdued skull/pelvis pixels, clearly background.
		for y: int in [170,192]:
			r(x-14,y,10,8,Color("1a2932"))
			r(x-11,y+2,4,3,Color("4c5a5e"))
			r(x-10,y+3,1,1,Color("17212d"))
			r(x+6,y+1,6,2,Color("3c4d54"))
	for x: int in [1220,1442]:
		halo(Vector2(x,157),8,GOLD)
		r(x-3,164,6,2,STONE)
		candle(x,164,_time)
	# Thin damp seams never brighten the walkable floor.
	for x: int in range(1170,1504,37):
		r(x,121,1,7,Color("436260"))
		r(x,131+int(_time*7+x)%18,1,2,Color("537574"))
	# Receding chambers: darkness is local to the interior, never a screen overlay.
	for chamber: int in [1240,1360]:
		_vault(chamber-30,124,60,96,Color("334249"),Color("0b151f"))
		_vault(chamber-22,140,44,80,Color("26373d"),Color("08121b"))
		_vault(chamber-14,156,28,64,Color("1c2e35"),Color("060e18"))
		for step: int in range(4):
			r(chamber-12-step*5,202+step*4,24+step*10,1,Color("263c43"))
	# Heavy radial vault ribs above the gameplay corridor, with stone voussoirs.
	for x: int in [1160,1276,1392,1504]:
		if absf(x-_view.get_center().x)>215: continue
		for rib: int in range(2):
			var yy: int = 90+rib*5
			l(Vector2(x-58,154),Vector2(x-40,yy+30),Color("465353") if rib==0 else Color("27383e"),3)
			l(Vector2(x-40,yy+30),Vector2(x,yy),Color("465353") if rib==0 else Color("27383e"),3)
			l(Vector2(x,yy),Vector2(x+40,yy+30),Color("465353") if rib==0 else Color("27383e"),3)
			l(Vector2(x+40,yy+30),Vector2(x+58,154),Color("465353") if rib==0 else Color("27383e"),3)
		for side: int in [-1,1]:
			for mark: int in range(5):
				r(x+side*(7+mark*8),98+mark*6,2,3,Color("1c2b32"))
		r(x-3,91,6,7,Color("627168"))
		r(x-2,91,4,2,Color("839080"))
	for x: int in [1197,1309,1421]:
		r(x,145,8,75,Color("152630"))
		r(x,146,2,74,Color("4a5c5c"))
		r(x-3,145,14,4,Color("55635e"))
		for band: int in range(3): r(x,166+band*20,8,2,Color("3a4a4c"))
		for bone: int in range(3):
			r(x+14+bone*5,190+(bone%2)*6,3,2,Color("5b665a"))
			l(Vector2(x+14+bone*5,198),Vector2(x+20+bone*5,201),Color("465a54"))
	for lamp: int in [1220,1442]:
		halo(Vector2(lamp,154),16,AMBER)
		l(Vector2(lamp-3,162),Vector2(lamp-6,172),Color("8b7960"),2)
		candle(lamp,164,_time)
	# Mineral deposits and roots descending from the ceiling, outside the actor plane.
	for x: int in range(1163,1504,19):
		var length: int = 4+posmod(x*13,15)
		l(Vector2(x,118),Vector2(x-3,118+length),Color("3a514b"))
		if x%3==0: r(x-3,122+length,1,2,Color("72918a",0.45))

func _vault(x: float,y: float,w: float,h: float,stone: Color,dark: Color) -> void:
	# Unbarred pointed opening; unlike windows, its interior has no cross mullion.
	var inset: float = minf(3,w/8)
	var shoulder: float = h*0.32
	p([Vector2(x,y+h),Vector2(x,y+shoulder),Vector2(x+w*0.14,y+h*0.14),Vector2(x+w/2,y),Vector2(x+w*0.86,y+h*0.14),Vector2(x+w,y+shoulder),Vector2(x+w,y+h)],stone)
	p([Vector2(x+inset,y+h),Vector2(x+inset,y+shoulder+inset),Vector2(x+w*0.20,y+h*0.18+inset),Vector2(x+w/2,y+inset*1.5),Vector2(x+w*0.80,y+h*0.18+inset),Vector2(x+w-inset,y+shoulder+inset),Vector2(x+w-inset,y+h)],dark)

func _cypress(x: float,y: float,height: int,tint: Color) -> void:
	r(x-1,y-height+9,3,height-9,Color("293c3b"))
	p([Vector2(x,y-height),Vector2(x-5,y-height+18),Vector2(x-4,y-height+20),Vector2(x-11,y-15),Vector2(x-8,y-14),Vector2(x-14,y-3),Vector2(x+12,y-3),Vector2(x+8,y-14),Vector2(x+10,y-15),Vector2(x+4,y-height+18)],tint)
	l(Vector2(x,y-height+7),Vector2(x-2,y-15),Color("48615a"))
	for i: int in range(4): r(x-4-i%2,y-20-i*9,4+i,1,Color("3b554f"))

func _middle_distance() -> void:
	# Sector-specific, camera-relative middle ground; muted values preserve silhouettes.
	var origin: Vector2 = _view.position
	var sector: int = clampi(int(_view.get_center().x/384),0,5)
	if sector==3: return
	for index: int in range(-1,6):
		var x: float = origin.x+index*94-posmod(int(origin.x*0.60),94)
		if sector==2:
			_cypress(x,origin.y+151,77+posmod(index,3)*9,Color("253e3e"))
			_vault(x+22,origin.y+91,46,62,Color("30474a"),Color("21333a"))
			l(Vector2(x+16,origin.y+99),Vector2(x+74,origin.y+99),Color("435858"))
		elif sector==1:
			_grave(x+18,origin.y+156,index+6)
			_tree(x+54,origin.y+160,78,Color("333739"))
		elif sector==4:
			r(x+15,origin.y+126,16,88,Color("293d50"))
			p([Vector2(x+10,origin.y+126),Vector2(x+28,origin.y+111),Vector2(x+35,origin.y+126)],Color("34495c"))
		elif sector==5:
			_vault(x,origin.y+67,56,108,Color("343342"),Color("252839"))
		else:
			_tree(x+20,origin.y+157,86,Color("2c3442"))

func _garden_details() -> void:
	# Two small ancestral chapels frame the brighter main mausoleum.
	for x: int in [916,1016]:
		r(x,86,42,61,Color("2a4143"))
		p([Vector2(x-4,86),Vector2(x+21,68),Vector2(x+46,86)],Color("435853"))
		l(Vector2(x-4,86),Vector2(x+21,68),Color("67756b"))
		_vault(x+10,94,22,53,Color("5a6e64"),Color("182c32"))
		r(x-3,86,48,3,Color("6a7d6b"))
		for side: int in [0,36]:
			r(x+side,90,4,56,Color("465d55"))
			r(x+side,90,1,52,Color("7a8974"))
		for mark: int in range(5): r(x+4+mark*7,83,4,1,Color("78856b"))
	# Rusted ornamental garden screen: slender, never resembling a solid landing.
	for x: int in range(929,1060,12):
		l(Vector2(x,155),Vector2(x,126),Color("4b6156"))
		p([Vector2(x,123),Vector2(x-3,129),Vector2(x,135),Vector2(x+3,129)],Color("536a5c"))
	for y: int in [137,150]: l(Vector2(932,y),Vector2(1060,y),Color("3e564e"))
	# Clusters of dead roses / pale bellflowers, held below the actors' attack height.
	for x: int in [922,942,978,1014,1036,1108,1130]:
		var y: int = 140 if x<976 else 156
		for stem: int in range(3):
			var xx: int = x+stem*4
			var yy: int = y-5-stem%2*5
			l(Vector2(xx,y),Vector2(xx-2,yy),Color("576850"))
			r(xx-4,yy+3,3,1,Color("6e7b5b"))
			r(xx-3,yy-1,3,2,Color("9c777c") if stem%2 else Color("adb19a"))
	for x: int in [901,1080,1144]:
		_cypress(x,156 if x>976 else 140,90,Color("344e48"))
	_mausoleum(1076,156)
	# Votive paths: small bowls and a non-colliding stone wreath.
	for x: int in [989,1065]:
		r(x-3,153,7,3,Color("586557"))
		candle(x,153,_time)
	for side: int in [-1,1]:
		for leaf: int in range(4): r(1096+side*(8-leaf),88+leaf*3,3,2,Color("6c8069"))

func _regional_horizon() -> void:
	var origin: Vector2 = _view.position
	var center: float = _view.get_center().x
	if center>=384 and center<768:
		# Cemetery terraces recede into the haze, not another row of castle roofs.
		for ridge: int in range(3):
			var yy: float = origin.y+105+ridge*16
			for index: int in range(-1,8):
				var x: float = origin.x+index*53-posmod(int(origin.x*(0.11+ridge*0.06)),53)
				p([Vector2(x,yy+28),Vector2(x,yy+5),Vector2(x+24,yy),Vector2(x+53,yy+8),Vector2(x+53,yy+28)],Color("25313d").lightened(ridge*0.018))
				r(x+20,yy-14,4,16,Color("3e4850"))
				r(x+16,yy-10,12,3,Color("3e4850"))
	elif center>=768 and center<1152:
		for index: int in range(-1,9):
			var x: float = origin.x+index*43-posmod(int(origin.x*0.19),43)
			_cypress(x,origin.y+143,48+posmod(index,4)*11,Color("243b3a"))
		for band: int in range(4):
			r(origin.x,origin.y+114+band*10,320,2,Color("829c85",0.045))
	elif center>=1504 and center<1984:
		for index: int in range(-1,5):
			var x: float = origin.x+index*113-posmod(int(origin.x*0.14),113)
			p([Vector2(x,origin.y+185),Vector2(x+9,origin.y+128),Vector2(x+25,origin.y+91),Vector2(x+40,origin.y+101),Vector2(x+52,origin.y+82),Vector2(x+66,origin.y+119),Vector2(x+96,origin.y+137),Vector2(x+113,origin.y+185)],Color("26394b"))
			l(Vector2(x+25,origin.y+91),Vector2(x+40,origin.y+101),Color("405366"))
			l(Vector2(x+40,origin.y+101),Vector2(x+52,origin.y+82),Color("405366"))
		# Slanting moonlit cloud banks high above the exposed bridge.
		for band: int in range(6):
			var xx: float = origin.x+posmod(band*69-int(origin.x*0.10),390)-40
			r(xx,origin.y+45+band*4,77-band*4,1,Color("9baec3",0.13))

func _draw() -> void:
	if _painted_world(): return
	if Rect2(784,0,336,288).encloses(_view):
		_painted_sample()
		return
	var origin: Vector2 = _view.position
	for row: int in range(0,180,4):
		var tint: Color = Color("17182b").lerp(Color("354453"),float(row)/220.0)
		var garden_weight: float = clampf(1.0-absf(_view.get_center().x-976)/260.0,0,1)
		var cathedral_weight: float = clampf((_view.get_center().x-1984)/280.0,0,1)
		tint = tint.lerp(Color("162b32").lerp(Color("42564d"),float(row)/220.0),garden_weight*0.72)
		tint = tint.lerp(Color("241e32").lerp(Color("534353"),float(row)/220.0),cathedral_weight*0.65)
		r(origin.x,origin.y+row,320,4,tint)
	_moon(origin+Vector2(228-int(origin.x*0.08)%370,48))
	for star: int in range(17):
		var sx: float = origin.x+posmod(star*67-int(origin.x*0.05),320)
		var sy: float = origin.y+17+posmod(star*31,68)
		r(sx,sy,1,1,Color("8c98aa",0.34))
	for cloud: int in range(4):
		var cx: float = origin.x+posmod(cloud*101-int(origin.x*0.11)-int(_time),370)-30
		r(cx,origin.y+37+cloud*13,52+cloud*9,2,Color("5b667d",0.12))
		r(cx+11,origin.y+35+cloud*13,31,2,Color("5b667d",0.10))
	# Two camera-relative parallax planes, snapped to whole pixels.
	for index: int in range(-1,6):
		if _view.get_center().x>=384 and _view.get_center().x<1984: continue
		var x: float = origin.x+index*92-posmod(int(origin.x*0.18),92)
		var tower_top: int = 75+posmod(index*7,23)
		r(x,origin.y+tower_top,24,90,Color("283247"))
		p([Vector2(x-4,origin.y+tower_top),Vector2(x+12,origin.y+tower_top-27),Vector2(x+28,origin.y+tower_top)],Color("283247"))
		l(Vector2(x-4,origin.y+tower_top),Vector2(x+12,origin.y+tower_top-27),Color("333e52"))
		r(x+10,origin.y+tower_top+7,3,9,Color("4b5363"))
		r(x+25,origin.y+tower_top+32,37,60,Color("273247"))
		p([Vector2(x+24,origin.y+tower_top+32),Vector2(x+40,origin.y+tower_top+19),Vector2(x+64,origin.y+tower_top+32)],Color("2b354b"))
		for window: int in [32,47]: r(x+window,origin.y+tower_top+39,2,5,Color("424b5e"))
	_regional_horizon()
	for index: int in range(-1,9):
		if _view.get_center().x>=768 and _view.get_center().x<1984: continue
		var x: float = origin.x+index*52-posmod(int(origin.x*0.42),52)
		_tree(x,origin.y+148,57+posmod(index,3)*9,Color("202c3c"))
	for index: int in range(7):
		var fx: float = origin.x+posmod(index*73-int(origin.x*0.25)+int(_time*2),360)-20
		r(fx,origin.y+135+index*5,65+index*7,2,Color("738994",0.06))
	_middle_distance()
	# Authored landmarks and decoration in world space.
	if _view.position.x < 410:
		_iron_fence(0,384,156)
		for x: int in [18,122]:
			r(x,53,14,103,Color("4b4c5d"))
			r(x-3,52,20,5,Color("77757d"))
			r(x+2,59,3,90,Color("77757d"))
			p([Vector2(x-1,52),Vector2(x+7,39),Vector2(x+15,52)],Color("696375"))
		arch(34,55,88,101,Color("656172"),Color("1a2535"))
		_iron_fence(40,118,156)
		# Crown, oath medallion, buttresses and weathering distinguish the entrance.
		for x: int in [18,122]:
			r(x-5,147,24,9,Color("65616a"))
			for yy: int in range(66,144,13):
				r(x+3,yy,10,1,Color("353847"))
				r(x+10,yy-6,1,7,Color("696573"))
			p([Vector2(x-4,52),Vector2(x+7,28),Vector2(x+18,52)],Color("494858"))
			l(Vector2(x+7,30),Vector2(x+18,52),Color("92908e"))
			candle(x+7,52,_time)
		for index: int in range(5):
			var xx: int = 46+index*15
			var yy: int = 47-absi(2-index)*-4
			p([Vector2(xx,yy+7),Vector2(xx+3,yy),Vector2(xx+6,yy+7)],Color("82798a"))
		p([Vector2(78,51),Vector2(86,58),Vector2(78,68),Vector2(70,58)],GOLD)
		r(77,54,2,10,Color("343545"))
		r(74,57,8,2,Color("343545"))
		for x: int in [44,110]:
			r(x,120,2,36,Color("76717b"))
			r(x,125,4,1,GOLD)
		l(Vector2(46,99),Vector2(76,130),Color("555164"))
		l(Vector2(108,99),Vector2(80,130),Color("555164"))
		_tree(306,156,100,Color("373d4a"))
		candle(139,156,_time)
	for entry: Vector2 in [Vector2(402,156),Vector2(506,144),Vector2(607,156),Vector2(702,140),Vector2(793,140),Vector2(936,140)]:
		if absf(entry.x-_view.get_center().x)<190: _grave(entry.x,entry.y,int(entry.x)%3)
	if _view.intersects(Rect2(768,0,384,180)):
		_garden_details()
		# Weeping watcher: a broken, original winged funerary statue.
		r(858,105,20,10,Color("4e5968"))
		r(864,76,8,29,Color("65707b"))
		r(863,69,10,9,Color("839096"))
		p([Vector2(864,79),Vector2(849,61),Vector2(851,88),Vector2(864,97)],Color("4d5d6d"))
		p([Vector2(872,79),Vector2(885,66),Vector2(883,91),Vector2(872,97)],Color("62707b"))
		l(Vector2(868,78),Vector2(866,104),Color("919b9e"))
		for feather: int in range(4):
			l(Vector2(851+feather*2,66+feather*3),Vector2(853+feather*2,88+feather),Color("7b8790"))
			l(Vector2(882-feather*2,71+feather*2),Vector2(880-feather*2,90+feather),Color("859099"))
		r(864,73,3,3,Color("414c5c"))
		r(870,73,3,2,Color("414c5c"))
		r(867,75,2,4,Color("a0a6a7"))
		for fold: int in range(3): l(Vector2(865+fold*2,88),Vector2(862+fold*5,104),Color("7c8991"))
		r(856,104,24,2,Color("8d9699"))

		candle(1000,156,_time)
	if _view.intersects(Rect2(1152,0,352,288)): _crypt()
	if _view.intersects(Rect2(1504,0,480,244)):
		# A drowned aqueduct and broken pylons give this sector its own silhouette.
		for row: int in range(126,244,4):
			r(1504,row,480,4,Color("1d3043").lerp(Color("43566b"),float(row-126)/180.0))
		for x: int in [1574,1734,1894]:
			arch(x,78,112,178,Color("314557"),Color("1b2d42"))
			arch(x+8,91,96,160,Color("293c51"),Color("1b2d42"))
			r(x-6,104,10,151,Color("3c5261"))
			r(x-6,104,2,148,Color("50616f"))
			r(x-9,102,16,4,Color("4c5c69"))
			for crack: int in range(5):
				r(x-3,116+crack*21,6,1,Color("273b4e"))
				r(x+105,121+crack*21,5,1,Color("273b4e"))
		for x: int in [1660,1820]:
			for link: int in range(8):
				var yy: int = 83+int(sin(float(link)/7*PI)*10)
				r(x+link*8,yy,5,2,Color("657080"))
		for index: int in range(9):
			var fog_x: float = 1504+posmod(index*71+int(_time*3),520)-30
			r(fog_x,158+index*6,80+index*4,2,Color("a3b3bf",0.07))
			l(Vector2(fog_x+8,160+index*6),Vector2(fog_x+47,160+index*6),Color("90aaa9",0.08))
		for x: int in [1680,1820,1940]:
			r(x,172+int(sin(_time+x)*3),2,4,Color("7d9d9e",0.4))
		# Broken piers drop into mist; decorative spans remain well below the route.
		for x: int in [1607,1743,1878]:
			p([Vector2(x,189),Vector2(x+4,173),Vector2(x+12,183),Vector2(x+18,177),Vector2(x+26,190),Vector2(x+26,268),Vector2(x,268)],Color("344d60"))
			r(x+3,192,3,61,Color("597080"))
			for yy: int in range(200,260,13): r(x+5,yy,19,1,Color("233d52"))
		for strand: int in range(3):
			var yy: int = 187+strand*18
			l(Vector2(1504,yy),Vector2(1984,yy+8),Color("b0c4c4",0.07))
			for x: int in range(1510,1984,38):
				r(x+int(_time*2)%38,yy+2,22,1,Color("a1b9c0",0.09))
		for ripple: int in range(12):
			var xx: float = 1504+posmod(ripple*47+int(_time*3),480)
			r(xx,219+posmod(ripple*13,28),12+ripple%4*7,1,Color("8fa7b6",0.22))
	if _view.end.x > 1984: _cathedral()
	if _view.end.x > 2110:
		# Layered tracery, stone joints, flying buttresses and funeral standards.
		for x: int in [2172,2326]:
			l(Vector2(x,73),Vector2(x-29,150),Color("4e485a"),8)
			l(Vector2(x+1,75),Vector2(x-27,147),Color("7b6d79"),2)
		for x: int in [2210,2302]:
			for y: int in [47,66]:
				p([Vector2(x+14,y-6),Vector2(x+10,y),Vector2(x+14,y+5),Vector2(x+18,y)],Color("b5a093"))
			l(Vector2(x+3,80),Vector2(x+27,80),Color("8b7c83"))
		for y: int in range(86,144,11):
			for x: int in [2202,2234,2303,2330]: r(x,y,13,1,Color("3b3547"))
		for x: int in [2228,2309]:
			p([Vector2(x,89),Vector2(x+10,89),Vector2(x+10,123),Vector2(x+5,119),Vector2(x,126)],Color("583849"))
			r(x+4,95,2,14,Color("a47b69"))
			r(x+1,100,8,2,Color("a47b69"))
		for x: int in [2246,2298]:
			r(x,101,3,44,Color("797180"))
			r(x-2,99,7,3,Color("aa9995"))
		for i: int in range(5):
			r(2209+i*27,11,5,3,Color("655663"))
		# Narrow stained-glass light touches the facade, behind the combatants.
		for x: int in [2221,2315]:
			p([Vector2(x,76),Vector2(x+8,76),Vector2(x+24,154),Vector2(x+6,154)],Color("cea88c",0.065))
		for x: int in [2058,2150]:
			r(x,120,4,36,Color("5a5261"))
			r(x-3,120,10,2,Color("94817f"))
			r(x-2,108,8,11,Color("433c50"))
			_vault(x-2,104,8,15,Color("7b696f"),Color("231f33"))
			candle(x+1,119,_time)

	# Sparse foreground accents stay below the bright floor edge.
	for entry: Vector2 in [Vector2(204,156),Vector2(330,156),Vector2(718,140),Vector2(986,156),Vector2(1124,156),Vector2(1968,156),Vector2(2084,156)]:
		if absf(entry.x-_view.get_center().x)>180: continue
		for blade: int in range(4):
			l(entry+Vector2(blade*3,0),entry+Vector2(blade*4-4,-5-blade%2*3),Color("596559"))
	# Very sparse drifting ash, behind actors and never on the HUD.
	for index: int in range(9):
		var ax: float = origin.x+posmod(index*47+int(_time*(2+index%2))-int(origin.x*0.7),320)
		var ay: float = origin.y+55+posmod(index*23+int(_time*2),105)
		r(ax,ay,1,1,Color("a4a8a2",0.30))
	_painted_sample()

func _painted_sample() -> void:
	# Only the two art-direction sample sectors replace the procedural backdrop.
	# Raster art remains behind every actor/prop and reads, never alters, the camera.
	_paint_region(GARDEN_ART,Rect2(736,0,448,288),Rect2(720,-8,480,240),0.08)
	_paint_region(CRYPT_ART,Rect2(1120,0,416,288),Rect2(1104,24,448,248),0.035)
	for index: int in range(7):
		var x: float = 768+posmod(index*67+int(_time*(2+index%2)),384)
		var y: float = 68+posmod(index*37+int(_time*3),85)
		if _view.has_point(Vector2(x,y)):
			r(x,y,1,1,Color("c7a17b",0.42))

func _painted_world() -> bool:
	r(_view.position.x,_view.position.y,320,180,Color("111d2a"))
	for panel: Dictionary in PANELS:
		_paint_region(panel["texture"],panel["region"],panel["canvas"],panel["parallax"])
	# Sparse airborne accents remain behind the actors, not a curtain over gameplay.
	for index: int in range(9):
		var x: float = _view.position.x+posmod(index*47+int(_time*2),320)
		var y: float = _view.position.y+50+posmod(index*29+int(_time),100)
		r(x,y,1,1,Color("a7b5b2",0.18))
	return true

func _paint_region(texture: Texture2D,region: Rect2,canvas: Rect2,parallax: float) -> void:
	var portion: Rect2 = _view.intersection(region)
	if not portion.has_area(): return
	var offset: float = roundf((_view.get_center().x-region.get_center().x)*parallax)
	canvas.position.x += offset
	var ratio: Vector2 = texture.get_size()/canvas.size
	# Small world-space opacity bands soften the sample boundaries and crypt descent.
	# This is a background blend only; no actor, collider or input is touched.
	for x: int in range(int(portion.position.x),ceili(portion.end.x),8):
		var strip: Rect2 = Rect2(x,portion.position.y,minf(8,portion.end.x-x),portion.size.y)
		var alpha: float = minf(clampf((strip.get_center().x-region.position.x)/48,0,1),clampf((region.end.x-strip.get_center().x)/32,0,1))
		var source: Rect2 = Rect2((strip.position-canvas.position)*ratio,strip.size*ratio)
		draw_texture_rect_region(texture,strip,source,Color(Color("d4d9da"),alpha))
