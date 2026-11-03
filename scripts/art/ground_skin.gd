extends PixelCanvas
## Cached coating of existing solids. Physics transforms/shapes are read, never changed.
var _view: Rect2 = Rect2(0,0,320,180)
var _cell: Vector2i = Vector2i(-999,-999)
const MATERIALS: Texture2D = preload("res://assets/art/fix02/surface_materials.png")

func _process(_delta: float) -> void:
	var view: Rect2 = get_parent().get("_view")
	var cell: Vector2i = Vector2i(floori(view.position.x/32),floori(view.position.y/32))
	if cell != _cell:
		_cell = cell
		_view = view.grow(48)
		queue_redraw()

func _draw() -> void:
	var surfaces: Array[Dictionary] = get_parent().get("_surfaces")
	for surface: Dictionary in surfaces:
		_skin(surface["rect"],surface["name"])

func _skin(rect: Rect2,name: String) -> void:
	if not rect.intersects(_view.grow(24)): return
	var crypt: bool = name.begins_with("Crypt")
	var bridge: bool = name.begins_with("BridgeSpan")
	var dirt: bool = not crypt and not bridge and rect.position.x < 1152
	var garden: bool = dirt and rect.position.x>=848
	if not name.is_empty():
		# FIX03: a shared authored material family now covers every homologated solid.
		_painted_stone(rect,crypt or bridge or rect.position.x>=1888)
		return
	var gate: bool = name=="GateFloor"
	var cathedral: bool = name=="CathedralFloor"
	var base: Color = Color("302f3b") if dirt else Color("303744")
	if garden: base = Color("263935")
	if crypt: base = Color("202f35")
	if bridge: base = Color("272b36")
	if cathedral: base = Color("342f3d")
	draw_rect(rect,base)
	var start_x: int = maxi(int(rect.position.x),int(_view.position.x/16)*16-16)
	var end_x: int = mini(int(rect.end.x),int(_view.end.x)+16)
	var end_y: int = mini(int(rect.end.y),int(_view.end.y)+8)
	var block_w: int = 24 if crypt or gate else (32 if cathedral else 16)
	var block_h: int = 12 if crypt or garden else 10
	for y: int in range(int(rect.position.y)+5,end_y,block_h):
		for x: int in range(start_x-block_w/2*(int(y/block_h)%2),end_x,block_w):
			var seed: int = posmod(x*37+y*71,97)
			var tint: Color = base.lightened(0.045+float(seed%4)*0.013)
			if dirt and not garden and not gate:
				# Packed earth: irregular islands and pebbles instead of another brick wall.
				_patch(Rect2(x+seed%4,y,7+seed%5,2+seed%3),rect,tint)
				_patch(Rect2(x+3,y+6,2+seed%4,2),rect,Color("68605a") if seed%4==0 else Color("51494a"))
			else:
				_patch(Rect2(x+1,y,block_w-2,block_h-2),rect,tint)
				_patch(Rect2(x+3,y,block_w-7-seed%5,1),rect,tint.lightened(0.055))
			if seed%4==0:
				_patch(Rect2(x+8,y+2,1,4),rect,base.darkened(0.4))
				_patch(Rect2(x+9,y+5,3,1),rect,base.darkened(0.4))
			if garden or crypt:
				if seed%3==0:
					_patch(Rect2(x+3,y+block_h-4,6,2),rect,Color("4e6251") if garden else Color("3c5550"))
				if seed%7==0: _patch(Rect2(x+5,y+2,1,3),rect,Color("778072"))
			if cathedral and seed%3==0:
				_patch(Rect2(x+14,y+2,1,4),rect,Color("71626b"))
				_patch(Rect2(x+12,y+3,5,1),rect,Color("71626b"))

	# Actual collision surface is the exact top pixel, uninterrupted and bright.
	r(rect.position.x,rect.position.y,rect.size.x,1,Color("a0aca9"))
	r(rect.position.x,rect.position.y+1,rect.size.x,2,Color("606e70"))
	for x: int in range(start_x,end_x,12):
		_patch(Rect2(x,rect.position.y+3,5,2),rect,Color("535d59") if dirt else Color("4e5967"))
		if dirt and x%3 == 0: _patch(Rect2(x+2,rect.position.y+5,1,3),rect,Color("58675a"))
	# Sector-specific fascia, roots and inlaid blocks sit strictly inside real solids.
	if gate or garden:
		for x: int in range(start_x,end_x,27):
			_patch(Rect2(x+3,rect.position.y+7,9,2),rect,Color("637167") if garden else Color("62616a"))
			if garden:
				_patch(Rect2(x+7,rect.position.y+5,2,7),rect,Color("51624e"))
				_patch(Rect2(x+4,rect.position.y+11,5,1),rect,Color("718062"))
	if dirt and not garden:
		for x: int in range(start_x,end_x,43):
			_patch(Rect2(x+4,rect.position.y+8,1,9),rect,Color("71634e"))
			_patch(Rect2(x+5,rect.position.y+15,5,1),rect,Color("63543f"))
	if bridge:
		for x: int in range(start_x,end_x,8):
			_patch(Rect2(x,rect.position.y+3,1,7),rect,Color("141e2a"))
			_patch(Rect2(x+2,rect.position.y+6,4,1),rect,Color("796b62"))
			_patch(Rect2(x+2,rect.position.y+3,1,1),rect,Color("b1a18a"))
		r(rect.position.x,rect.end.y-2,rect.size.x,2,Color("1b2432"))
		for x: int in range(int(rect.position.x)+8,int(rect.end.x)-4,16):
			r(x,rect.end.y,4,5,Color("4c535f"))
	if name == "CryptRoof":
		r(rect.position.x,rect.end.y-2,rect.size.x,2,Color("576772"))

func _patch(patch: Rect2,solid: Rect2,tint: Color) -> void:
	var clipped: Rect2 = patch.intersection(solid)
	if clipped.has_area(): draw_rect(clipped,tint)

func _painted_stone(rect: Rect2,crypt: bool) -> void:
	# Texture patches are clipped to the existing physical rectangles, without new bodies.
	var visible: Rect2 = rect.intersection(_view.grow(16))
	var half: Vector2 = MATERIALS.get_size()*0.5
	for y: int in range(floori(visible.position.y/32)*32,ceili(visible.end.y),32):
		for x: int in range(floori(visible.position.x/48)*48,ceili(visible.end.x),48):
			var tile: Rect2 = Rect2(x,y,48,32)
			var patch: Rect2 = tile.intersection(rect)
			if not patch.has_area(): continue
			var variant: int = posmod(x/48+y/32,2)
			var origin: Vector2 = Vector2(half.x if crypt else 0,half.y*variant)
			var ratio: Vector2 = half/Vector2(48,32)
			var source: Rect2 = Rect2(origin+(patch.position-tile.position)*ratio,patch.size*ratio)
			draw_texture_rect_region(MATERIALS,patch,source,Color("8d9c9b") if crypt else Color("a3aa96"))
	# Exact top/underside contacts stay visually unambiguous; never extend the solid.
	r(rect.position.x,rect.position.y,rect.size.x,1,Color("9ba9a6"))
	r(rect.position.x,rect.position.y+1,rect.size.x,1,Color("64776c"))
	for x: int in range(maxi(int(rect.position.x),floori(_view.position.x/11)*11),mini(int(rect.end.x),ceili(_view.end.x)),11):
		_patch(Rect2(x,rect.position.y+2,4,1),rect,Color("77846b"))
	if rect.position.y==64:
		r(rect.position.x,rect.end.y-2,rect.size.x,2,Color("687c7b"))
