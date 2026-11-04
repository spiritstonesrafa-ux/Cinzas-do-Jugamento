extends "res://tests/boss_advanced_test.gd"
func run() -> void:
 out=OS.get_environment("CINZAS_M4B_EVIDENCE")
 if out.is_empty():out=ProjectSettings.globalize_path("res://.godot/m4b-performance")
 DirAccess.make_dir_recursive_absolute(out)
 root.mode=Window.MODE_FULLSCREEN
 main=(load("res://scenes/main.tscn") as PackedScene).instantiate();root.add_child(main)
 await frames(5)
 hero=main.get_node("ForgottenCemetery/Knight") as KnightController
 encounter=main.get_node("GuardianEncounter") as Node2D
 encounter.enter();await frames(2)
 boss=encounter.arena.get_node("Guardian") as OathGuardian
 await frames(120)
 await measure()
 release()
 benchmark["image"]=str(root.get_texture().get_image().get_size())
 FileAccess.open(out+"/performance.json",FileAccess.WRITE).store_string(JSON.stringify(benchmark,"  "))
 print("M4-B graphical performance: ",JSON.stringify(benchmark))
 quit()
