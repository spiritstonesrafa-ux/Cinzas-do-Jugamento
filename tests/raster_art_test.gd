extends SceneTree
## FIX02 integration checks. These validate imported resources, not artistic quality.
var checks: int = 0
var failures: int = 0

func _initialize() -> void:
	run.call_deferred()

func check(ok: bool,label: String) -> void:
	checks+=1
	if ok: print("PASS: ",label)
	else:
		failures+=1
		push_error("FAIL: "+label)

func run() -> void:
	var textures: Array[Texture2D] = []
	for name: String in ["garden_background","crypt_background","aren_poses","surface_materials"]:
		textures.append(load("res://assets/art/fix02/"+name+".png") as Texture2D)
	var loaded: bool = true
	var no_mips: bool = true
	var texels: int = 0
	for texture: Texture2D in textures:
		loaded = loaded and texture!=null and texture.get_width()>0 and texture.get_height()>0
		if texture!=null:
			no_mips = no_mips and not texture.get_image().has_mipmaps()
			texels += texture.get_width()*texture.get_height()
	check(loaded,"All four original raster assets import and load")
	check(no_mips,"No mipmaps blur the tiny 2D art")
	check(textures[2].get_image().detect_alpha()!=Image.ALPHA_NONE,"Aren sheet retains actual alpha transparency")
	check(texels<8*1024*1024,"Four uncompressed raster dimensions stay below eight million texels")
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await physics_frame
	await process_frame
	var stage: Node = main.get_node("ForgottenCemetery")
	var visual: Node = stage.get_node("Knight/Visual")
	var regions: Array = visual.get_script().get_script_constant_map()["FRAME_RECTS"]
	var bounds: Rect2 = Rect2(Vector2.ZERO,textures[2].get_size())
	var valid_regions: bool = regions.size()==8
	var separate: bool = true
	for i: int in range(regions.size()):
		var region: Rect2 = regions[i]
		valid_regions = valid_regions and region.has_area() and bounds.encloses(region)
		for j: int in range(i): separate = separate and not region.intersects(regions[j])
	check(valid_regions,"Eight complete authored poses stay inside the imported sheet")
	check(separate,"Pose regions do not overlap neighboring cells")
	var constants: Dictionary = stage.get_node("Backdrop").get_script().get_script_constant_map()
	check(constants["GARDEN_ART"]==textures[0] and constants["CRYPT_ART"]==textures[1],"Running level binds the new authored backgrounds rather than the reference JPGs")
	check(visual.get_script().get_script_constant_map()["POSES"]==textures[2],"Aren actually uses the imported pose sheet in the running scene")
	print("M3-D-FIX02 raster checks: ",checks,"; failures: ",failures)
	quit(0 if failures==0 else 1)
