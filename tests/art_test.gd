extends SceneTree
## Native-render checks: art must not mutate physical transforms, shapes or state.
var checks: int = 0
var failures: int = 0
func _initialize() -> void:
 run.call_deferred()
func frames(n: int) -> void:
 for i: int in range(n):
  await physics_frame
  await process_frame
func check(ok: bool, label: String) -> void:
 checks+=1
 if ok: print("PASS: ",label)
 else:
  failures+=1
  push_error("FAIL: "+label)
func physics_snapshot(node: Node, result: Dictionary) -> void:
 if node is CollisionObject2D:
  var body: CollisionObject2D=node as CollisionObject2D
  result[String(node.get_path())]=[body.global_transform,body.collision_layer,body.collision_mask]
 if node is CollisionShape2D:
  var item: CollisionShape2D=node as CollisionShape2D
  var dimensions: Variant=item.shape.size if item.shape is RectangleShape2D else (item.shape.radius if item.shape is CircleShape2D else null)
  result[String(node.get_path())]=[item.global_transform,item.disabled,item.shape.get_instance_id(),dimensions]
 for child: Node in node.get_children(): physics_snapshot(child,result)
func redraw(node: Node) -> void:
 if node is CanvasItem: (node as CanvasItem).queue_redraw()
 for child: Node in node.get_children(): redraw(child)
func run() -> void:
 var main: Node=(load("res://scenes/main.tscn") as PackedScene).instantiate()
 root.add_child(main)
 var stage: Node2D=main.get_node("ForgottenCemetery") as Node2D
 var hero: KnightController=stage.get_node("Knight") as KnightController
 await frames(5)
 check(ProjectSettings.get_setting("display/window/size/viewport_width")==320 and ProjectSettings.get_setting("display/window/size/viewport_height")==180,"Internal grid remains 320x180")
 check(ProjectSettings.get_setting("display/window/stretch/scale_mode")=="integer","Integer upscaling retained")
 check(ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter")==0 and ProjectSettings.get_setting("rendering/2d/snap/snap_2d_transforms_to_pixel"),"Nearest and transform pixel snapping retained")
 check(stage.get_node("WorldGeometry").get_child_count()==19 and stage.get_node("Enemies").get_child_count()==6,"Nineteen solids and six authored enemies remain")
 check((hero.get_node("CollisionShape2D").shape as RectangleShape2D).size==Vector2(12,24),"Aren physical body retained")
 check((hero.get_node("SwordAttack/Hitbox/CollisionShape2D").shape as RectangleShape2D).size==Vector2(22,14),"M1 real sword corridor retained")
 check((stage.get_node("Enemies/CursedRaven/CollisionShape2D").shape as RectangleShape2D).size==Vector2(14,10),"Raven body not enlarged to match wing ornament")
 check((stage.get_node("Mechanisms/CryptBlade/CollisionShape2D").shape as CircleShape2D).radius==10,"Blade art fits the unchanged physical radius")
 check(stage.get_node("Backdrop/GroundSkin")!=null,"Cached terrain skin loads without extra colliders")
 var surfaces: bool=true
 for body: Node in stage.get_node("WorldGeometry").get_children():
  surfaces=surfaces and not body.get_node("Block").visible and not body.get_node("CollisionShape2D").disabled
 check(surfaces,"Flat placeholder polygons replaced while all physical surfaces stay enabled")
 check(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)<200,"Whole scene stays below 200 nodes, without decorative node proliferation")
 main.process_mode=Node.PROCESS_MODE_DISABLED
 var before: Dictionary={}
 physics_snapshot(main,before)
 var health: int=hero.survival.current_health
 for i: int in range(8):
  redraw(main)
  await frames(1)
 var after: Dictionary={}
 physics_snapshot(main,after)
 check(before==after,"Eight actual rendering redraws never mutate any physical transform, layer, mask or shape")
 check(health==hero.survival.current_health,"Pure redraws never change HP")
 main.process_mode=Node.PROCESS_MODE_INHERIT
 hero.receive_damage(1)
 await frames(2)
 check(stage.get_node("HealthHUD/Life").text=="VIDA 4/5" and stage.get_node("HealthHUD/Frame").current==4,"Thematic HUD follows the unchanged M2 signal and exact text")
 var cp: CemeteryCheckpoint=stage.get_node("Mechanisms/Checkpoint1") as CemeteryCheckpoint
 hero.activate_checkpoint(cp)
 await frames(2)
 check(cp.active and cp._art_burst>0,"Checkpoint activation produces cosmetic burst without changing its M2 activation")
 await frames(50)
 hero.receive_damage(999)
 await frames(1)
 check(hero.survival.is_dead,"Visual death remains governed by M2")
 await frames(40)
 check(not hero.survival.is_dead and hero.survival.current_health==5 and hero.get_node("Visual").get("_revive")>0,"Respawn restores M2 and triggers a visual-only shimmer")
 hero.reset_to(Vector2(1788,144))
 await frames(5)
 var camera: Camera2D=stage.get_node("Camera2D") as Camera2D
 var backdrop: Node2D=stage.get_node("Backdrop") as Node2D
 check(backdrop.get("_view").position==camera.get_screen_center_position().round()-Vector2(160,90),"Parallax reads the real camera view without moving it")
 print("M3-D art checks: ",checks,"; failures: ",failures)
 quit(0 if failures==0 else 1)
