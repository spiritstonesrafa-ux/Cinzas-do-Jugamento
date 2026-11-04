extends "res://tests/boss_victory_test.gd"
func run() -> void:
 out=OS.get_environment("CINZAS_M4C_EVIDENCE")
 if out.is_empty():out=ProjectSettings.globalize_path("res://.godot/m4c-performance")
 DirAccess.make_dir_recursive_absolute(out)
 root.mode=Window.MODE_FULLSCREEN
 main=(load("res://scenes/main.tscn") as PackedScene).instantiate();root.add_child(main)
 await frames(5)
 hero=main.get_node("ForgottenCemetery/Knight") as KnightController
 encounter=main.get_node("GuardianEncounter") as Node2D
 encounter.enter();await frames(2)
 boss=encounter.arena.get_node("Guardian") as OathGuardian
 ending=boss.get_node("Conclusion")
 await frames(120)
 await prepare()
 var samples: Array[float]=[]
 var start: int=Time.get_ticks_usec()
 var previous: int=start
 var node_min: int=100000
 var node_max: int=0
 var count: int=0
 while Time.get_ticks_usec()-start<45000000:
  Input.action_release("attack")
  if ending.settled and ending.elapsed>=3.5:
   encounter.completed=false
   encounter.arena.get_node("LeftGate/CollisionShape2D").set_deferred("disabled",false)
   boss.reset_encounter()
   hero.reset_to(encounter.arena.global_position+Vector2(206,156));hero.facing=1
   boss.target=hero;boss.awake=true;boss.phase=2;boss.current_health=1
   boss._set_state(OathGuardian.State.PUNISH,1.1)
  if boss.state==OathGuardian.State.PUNISH and hero.sword_attack.phase==SwordAttack.Phase.NEUTRAL:Input.action_press("attack")
  await process_frame
  var now: int=Time.get_ticks_usec()
  samples.append((now-previous)/1000.0);previous=now;count+=1
  var nodes: int=int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
  node_min=mini(node_min,nodes);node_max=maxi(node_max,nodes)
 release()
 samples.sort()
 var data: Dictionary={"seconds":(previous-start)/1000000.0,"frames":count,"fps":count/((previous-start)/1000000.0),"p95_ms":samples[int(samples.size()*0.95)],"max_ms":samples[-1],"node_min":node_min,"node_max":node_max,"sequences":ending.sequence_count,"image":str(root.get_texture().get_image().get_size()),"fixed_fps":false,"scope":"repeated physical final blows and complete cinematic; fixtures reset between cycles"}
 FileAccess.open(out+"/performance.json",FileAccess.WRITE).store_string(JSON.stringify(data,"  "))
 print("M4-C graphical performance: ",JSON.stringify(data))
 quit()
