extends "res://tests/boss_advanced_test.gd"
func run() -> void:
 out=OS.get_environment("CINZAS_M4B_EVIDENCE")
 if out.is_empty():out=ProjectSettings.globalize_path("res://.godot/m4b-visual")
 DirAccess.make_dir_recursive_absolute(out)
 root.mode=Window.MODE_FULLSCREEN
 main=(load("res://scenes/main.tscn") as PackedScene).instantiate();root.add_child(main)
 await frames(5)
 hero=main.get_node("ForgottenCemetery/Knight") as KnightController
 encounter=main.get_node("GuardianEncounter") as Node2D
 encounter.enter();await frames(2)
 boss=encounter.arena.get_node("Guardian") as OathGuardian
 for kind: int in range(4):
  await fixture(kind,1)
  if kind==3:boss.phase=2
  await frames(30)
  await capture("windup_"+str(kind))
  while boss.state==OathGuardian.State.TELEGRAPH and boss.remaining>(0.3 if kind==0 else (0.2 if kind==2 else 0.1)):await frames(1)
  await jump()
  await wait_state(OathGuardian.State.ATTACK);await frames(4)
  await capture("execution_"+str(kind))
  if kind==3:await frames(8);await capture("oath_wave")
  await wait_state(OathGuardian.State.PUNISH)
  boss.clear_dangers()
 await fixture(0,1)
 boss._start_transition();await frames(24);await capture("transformation")
 check(captures==10,"Final articulated poses and effect captured natively")
 FileAccess.open(out+"/visual.json",FileAccess.WRITE).store_string(JSON.stringify({"checks":checks,"failures":failures,"captures":captures,"image":str(root.get_texture().get_image().get_size())}))
 quit(0 if failures==0 else 1)
