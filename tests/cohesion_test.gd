extends SceneTree
## FIX03 assets and panel coverage. Geometry checks do not certify artistic continuity.
var checks: int=0
var failures: int=0

func _initialize() -> void:
	run.call_deferred()

func frames(n: int) -> void:
	for i: int in range(n):
		await physics_frame
		await process_frame

func check(ok: bool,label: String) -> void:
	checks+=1
	if ok: print("PASS: ",label)
	else:
		failures+=1
		push_error("FAIL: "+label)

func run() -> void:
	var main: Node=(load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await frames(4)
	var stage: Node=main.get_node("ForgottenCemetery")
	var hero: KnightController=stage.get_node("Knight") as KnightController
	var back: Node2D=stage.get_node("Backdrop") as Node2D
	var panels: Array=back.get_script().get_script_constant_map()["PANELS"]
	check(panels.size()==6,"Six authored sector panels are bound to the actual level")
	var load_ok: bool=true
	var uids: bool=true
	var no_mips: bool=true
	var texels: int=0
	for panel: Dictionary in panels:
		var texture: Texture2D=panel["texture"]
		load_ok=load_ok and texture!=null and texture.get_width()>0
		uids=uids and ResourceLoader.get_resource_uid(texture.resource_path)!=-1
		no_mips=no_mips and not texture.get_image().has_mipmaps()
		texels+=texture.get_width()*texture.get_height()
	check(load_ok,"Every sector background loads from a project resource")
	check(uids,"Every imported background has a Godot resource UID")
	check(no_mips,"All six backgrounds keep pixel-art mipmap policy")
	var coverage: bool=true
	for x: int in range(0,2369,4):
		var remaining: float=1
		for panel: Dictionary in panels:
			var region: Rect2=panel["region"]
			if x>=region.position.x and x<region.end.x:
				var alpha: float=minf(clampf((x-region.position.x)/48,0,1),clampf((region.end.x-x)/32,0,1))
				remaining*=1-alpha
		coverage=coverage and remaining<0.25
	check(coverage,"Geometric opacity coverage has no uncovered band along all five transitions")
	var texture: Texture2D=ArenAttackArt.TEXTURE
	texels+=texture.get_width()*texture.get_height()
	var valid: bool=true
	var separate: bool=true
	var bounds: Rect2=Rect2(Vector2.ZERO,texture.get_size())
	for i: int in range(ArenAttackArt.FRAMES.size()):
		valid=valid and bounds.encloses(ArenAttackArt.FRAMES[i]) and ArenAttackArt.FRAMES[i].encloses(ArenAttackArt.BLADES[i])
		for j: int in range(i): separate=separate and not ArenAttackArt.FRAMES[i].intersects(ArenAttackArt.FRAMES[j])
	check(valid and ArenAttackArt.FRAMES.size()==8,"Eight attack frames and blade source patches fit inside the original PNG")
	check(separate,"Attack regions are isolated without neighboring-cell bleed")
	check(texture.get_image().detect_alpha()!=Image.ALPHA_NONE,"New attack sheet has genuine transparency")
	texture=CemeterySpriteArt.TEXTURE
	texels+=texture.get_width()*texture.get_height()
	bounds=Rect2(Vector2.ZERO,texture.get_size())
	valid=true
	for region: Rect2 in CemeterySpriteArt.FRAMES: valid=valid and bounds.encloses(region)
	check(valid and CemeterySpriteArt.FRAMES.size()==12,"Shared enemy and prop atlas has twelve valid isolated regions")
	check(texture.get_image().detect_alpha()!=Image.ALPHA_NONE,"Enemy/prop atlas keeps real alpha")
	check(texels<24*1024*1024,"Six backgrounds and two new atlases stay below 24 million texels")
	var camera: Camera2D=stage.get_node("Camera2D") as Camera2D
	var points: Array[Vector2]=[Vector2(368,156),Vector2(400,156),Vector2(744,140),Vector2(792,140),Vector2(1136,156),Vector2(1176,180),Vector2(1480,172),Vector2(1552,156),Vector2(1968,156),Vector2(2000,156)]
	var camera_ok: bool=true
	for index: int in range(points.size()):
		hero.reset_to(points[index])
		await frames(3)
		var view: Rect2=back.get("_view")
		camera_ok=camera_ok and view.position==camera.get_screen_center_position().round()-Vector2(160,90)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://.godot/fix03-transition-"+str(index)+".png")
	check(camera_ok,"Real camera/read-only parallax stay aligned at both sides of all five transitions")
	check(stage.get_node("WorldGeometry").get_child_count()==19 and stage.get_node("Enemies").get_child_count()==6,"Nineteen solids and six authored enemies unchanged")
	check(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)<200,"No decorative node proliferation")
	print("FIX03 monitors: nodes=",Performance.get_monitor(Performance.OBJECT_NODE_COUNT)," draw_calls=",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)," texture_bytes=",Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))
	print("M3-D-FIX03 cohesion checks: ",checks,"; failures: ",failures)
	quit(0 if failures==0 else 1)
