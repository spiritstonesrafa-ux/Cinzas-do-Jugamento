extends "res://tests/art_test.gd"
## DISPLAY01: native rendered sizes; the logical world and physical shapes stay fixed.
func run() -> void:
 var main: Node=(load("res://scenes/main.tscn") as PackedScene).instantiate()
 root.add_child(main)
 await frames(5)
 var stage: Node2D=main.get_node("ForgottenCemetery") as Node2D
 var hero: KnightController=stage.get_node("Knight") as KnightController
 var camera: Camera2D=stage.get_node("Camera2D") as Camera2D
 var back: Node2D=stage.get_node("Backdrop") as Node2D
 check(root.content_scale_mode==Window.CONTENT_SCALE_MODE_CANVAS_ITEMS,"Configured Canvas Items is effective without runtime override")
 check(root.size==Vector2i(960,540),"Initial window stays 960x540")
 check(root.content_scale_size==Vector2i(320,180),"Logical reference stays 320x180")
 check(root.content_scale_aspect==Window.CONTENT_SCALE_ASPECT_KEEP,"Keep aspect effective")
 check(root.content_scale_stretch==Window.CONTENT_SCALE_STRETCH_INTEGER,"Integer scale effective")
 check(root.canvas_item_default_texture_filter==Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST,"Actor/HUD default is Nearest")
 check(back.texture_filter==CanvasItem.TEXTURE_FILTER_LINEAR and back.get_node("GroundSkin").texture_filter==CanvasItem.TEXTURE_FILTER_PARENT_NODE,"Only backdrop and inherited ground use Linear")
 check(not back.is_ancestor_of(hero) and not back.is_ancestor_of(stage.get_node("HealthHUD")),"Backdrop filter cannot propagate to actors or HUD")
 for panel: Dictionary in back.get("PANELS"):
  check((panel["texture"] as Texture2D).get_width()>1000,"Detailed source texture loaded")
 hero.reset_to(Vector2(990,156))
 await frames(5)
 main.process_mode=Node.PROCESS_MODE_DISABLED
 var original: Dictionary={}
 physics_snapshot(main,original)
 var camera_before: Vector2=camera.get_screen_center_position()
 var output: String=OS.get_environment("CINZAS_DISPLAY_EVIDENCE")
 if output.is_empty(): output=ProjectSettings.globalize_path("res://.godot/display01")
 DirAccess.make_dir_recursive_absolute(output)
 var records: Array=[]
 for size: Vector2i in [Vector2i(1280,720),Vector2i(1920,1080),Vector2i(2560,1440),Vector2i(3840,2160)]:
  root.mode=Window.MODE_WINDOWED
  root.size=size
  await frames(3)
  await RenderingServer.frame_post_draw
  var image: Image=root.get_texture().get_image()
  check(image.get_size()==size,"Native image dimensions "+str(size))
  check(root.get_visible_rect().size==Vector2(320,180),"Logical FOV "+str(size))
  check(camera.get_screen_center_position()==camera_before and camera.zoom==Vector2.ONE,"Camera unchanged "+str(size))
  var current: Dictionary={}
  physics_snapshot(main,current)
  check(current==original,"Collision transforms/shapes unchanged "+str(size))
  check(is_equal_approx(root.get_stretch_transform().x.x,root.get_stretch_transform().y.y),"Uniform aspect scaling "+str(size))
  var path: String=output+"/display01_"+str(size.x)+"x"+str(size.y)+"_garden.png"
  check(image.save_png(path)==OK,"Native PNG saved "+str(size))
  records.append({"requested":str(size),"image":str(image.get_size()),"logical":str(root.get_visible_rect()),"camera":str(camera_before),"path":path})
 var file: FileAccess=FileAccess.open(output+"/display_test.json",FileAccess.WRITE)
 file.store_string(JSON.stringify(records,"  "))
 print("DISPLAY01 checks: ",checks,"; failures: ",failures)
 quit(0 if failures==0 else 1)