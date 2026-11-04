extends "res://tests/boss_advanced_test.gd"
## M4-C: physical final blows + concurrent-state fixtures; no approved tests removed.
var ending: Node2D
var evidence_sizes: Dictionary={}
var live_result: Dictionary={}
func prepare(kind: int=0,phase_value: int=2) -> void:
 if not encounter.active:encounter.enter();await frames(2)
 release()
 encounter.completed=false
 encounter.arena.get_node("LeftGate/CollisionShape2D").set_deferred("disabled",false)
 boss.reset_encounter()
 hero.survival.restore()
 boss.position=Vector2(236,156)
 hero.reset_to(encounter.arena.global_position+Vector2(206,156))
 hero.facing=1
 await frames(4)
 boss.target=hero;boss.awake=true;boss.phase=phase_value;boss.current_health=1;boss.facing=1
 boss.pattern=kind
 boss._set_state(OathGuardian.State.PUNISH,1.1)
func final_sword() -> void:
 Input.action_press("attack");await frames(1);Input.action_release("attack")
 await frames(7)
func live_battle() -> void:
 release()
 hero.reset_to(encounter.arena.global_position+Vector2(176,156))
 var punished: bool=false
 var hits: int=0
 var hp: int=boss.current_health
 var used: int=0
 for i: int in range(7200):
  if boss.state==OathGuardian.State.DEFEATED or hero.survival.is_dead:break
  used=i
  Input.action_release("attack");Input.action_release("jump")
  var dx: float=boss.global_position.x-hero.global_position.x
  Input.action_release("move_left");Input.action_release("move_right")
  var gap: float=26 if boss.state in [OathGuardian.State.PUNISH,OathGuardian.State.HURT,OathGuardian.State.PHASE_TRANSITION] else 60
  if boss.state!=OathGuardian.State.ATTACK:
   if absf(dx)>gap+2:Input.action_press("move_right" if dx>0 else "move_left")
   elif absf(dx)<gap-2:Input.action_press("move_left" if dx>0 else "move_right")
  if boss.state==OathGuardian.State.TELEGRAPH:
   punished=false
   if boss.remaining<=(0.3 if boss.pattern==0 else (0.2 if boss.pattern==2 else (0.1 if boss.pattern==1 else 0.06))) and hero.is_on_floor():Input.action_press("jump")
  if hero.is_on_floor() and absf(dx)<=38 and boss.state==OathGuardian.State.PUNISH and not punished:Input.action_press("attack");punished=true
  await frames(1)
  if boss.current_health<hp:hits+=hp-boss.current_health;hp=boss.current_health
 release()
 live_result={"won":boss.state==OathGuardian.State.DEFEATED,"hits":hits,"hp":hero.survival.current_health,"seconds":used/60.0}
func run() -> void:
 out=OS.get_environment("CINZAS_M4C_EVIDENCE")
 if out.is_empty():out=ProjectSettings.globalize_path("res://.godot/m4c")
 DirAccess.make_dir_recursive_absolute(out)
 if DisplayServer.get_name()!="headless":root.mode=Window.MODE_FULLSCREEN
 main=(load("res://scenes/main.tscn") as PackedScene).instantiate();root.add_child(main)
 await frames(5)
 hero=main.get_node("ForgottenCemetery/Knight") as KnightController
 encounter=main.get_node("GuardianEncounter") as Node2D
 check(encounter.arena==null,"Cinematic does not eagerly load boss resources/nodes")
 hero.reset_to(Vector2(2298,156));Input.action_press("move_right")
 for i: int in range(50):
  await frames(1)
  if encounter.active:break
 release()
 boss=encounter.arena.get_node("Guardian") as OathGuardian
 ending=boss.get_node("Conclusion")
 check(not ending.played and not ending.running,"Presentation dormant before real victory")
 check(boss.state==OathGuardian.State.INTRO,"Approved intro still runs")
 check(boss.max_health==10 and boss.phase_threshold==0.5,"Approved difficulty retained")
 await capture("combat")
 await live_battle()
 check(live_result.won and live_result.hits==10 and live_result.hp==5,"Ten real M1 hits trigger victory through live original-input duel")
 check(boss.phase==2,"Live victory comes from phase two")
 check(ending.played and ending.running and ending.sequence_count==1,"Physical final hit starts exactly one cinematic")
 check(not boss.attack_source.active and not is_instance_valid(boss.special_wave),"Final hit immediately clears all offensive sources")
 check(not boss.awake and boss.receiver.disabled,"Zero HP disables decisions and sword receiver")
 check(encounter.completed and encounter.arena.get_node("LeftGate/CollisionShape2D").disabled,"Gate opens immediately; cinematic cannot trap player")
 await capture("final_blow")
 var camera: Camera2D=root.get_camera_2d()
 var x: float=hero.position.x
 Input.action_press("move_right");await frames(8);release()
 check(hero.position.x>x+3 and not hero.survival.is_dead,"Aren retains movement during impact")
 check(root.get_camera_2d()==camera and camera.position==Vector2(160,90),"Cinematic keeps approved framing without shake or zoom")
 var times: Array[float]=[0.2,0.4,0.7,1.1,1.5,1.9,2.3,2.8]
 var poses: Array[int]=[]
 for t: float in times:
  while ending.elapsed<t:await frames(1)
  poses.append(ending.pose())
  await capture("sequence_"+str(int(t*10)))
 check(poses.has(0) and poses.has(1) and poses.has(2) and poses.has(3),"Actual advancing physics traverses all four defeat poses")
 check(ending.settled and not ending.running and ending.completion_count==1,"Short cinematic settles exactly once")
 check(ending.pose()==3,"Final armor husk remains visible instead of disappearing")
 var sequences: int=ending.sequence_count
 boss.defeated.emit();boss.receive_hit();await frames(4)
 check(ending.sequence_count==sequences and boss.current_health==0,"Duplicate defeat signals or stale hits cannot replay sequence")
 var hp: int=hero.survival.current_health
 hero.reset_to(boss.global_position);await frames(60)
 check(hero.survival.current_health==hp,"Former boss body/weapon has no post-victory damage")
 check(ending.TITLE=="JURAMENTO ROMPIDO" and ending.NARRATIVE=="Um elo da maldição se rompe.","Brief conclusion uses established oath/curse narrative")
 check(ending.CONTINUATION=="A jornada de Aren continua.","Narrative promises no unimplemented item, skill or region")
 var font: Font=ThemeDB.fallback_font
 for text: String in [ending.TITLE,ending.PHASE_TEXT,ending.NARRATIVE,ending.CONTINUATION]:
  check(font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,8 if text==ending.TITLE else 7).x<=250,"Logical conclusion text fits its panel: "+text)
 check(main.get_node("ForgottenCemetery/HealthHUD").visible,"Base health HUD stays visible")
 await capture("arena_complete")
 # Four native window sizes; these presentation fixtures do not certify human legibility.
 if DisplayServer.get_name()!="headless":
  for size: Vector2i in [Vector2i(1280,720),Vector2i(1920,1080),Vector2i(2560,1440),Vector2i(3840,2160)]:
   root.mode=Window.MODE_WINDOWED if size.x<3840 else Window.MODE_FULLSCREEN
   if size.x<3840:root.size=size
   ending.elapsed=3.0
   await frames(5)
   await capture("display_"+str(size.x))
   var actual: Vector2i=root.get_texture().get_image().get_size()
   evidence_sizes[str(size.x)]=str(actual)
   check(actual==size,"Native resolution matches requested "+str(size))
   check(root.get_visible_rect().size==Vector2(320,180),"Logical HUD reference preserved at "+str(size))
 # Leaving before/after presentation never blocks, reentry never repeats.
 Input.action_press("move_left")
 for i: int in range(200):
  await frames(1)
  if not encounter.active:break
 release()
 check(not encounter.active and hero.position.x<2340,"Real walking returns to cemetery")
 check(ending.settled,"Leaving settles final armor safely")
 check(root.get_camera_2d()==main.get_node("ForgottenCemetery/Camera2D"),"Return restores exploration camera")
 check(main.get_node("ForgottenCemetery/StageHUD").visible and not encounter.arena.get_node("BossHUD").visible,"Return restores original HUD and hides boss presentation")
 await frames(2)
 await create_timer(0).timeout # Observe text after presentation _process, as rendered.
 check("CONCLUÍDO" in main.get_node("ForgottenCemetery/StageHUD/Presentation").display_notice(),"Rendered HUD notice replaces obsolete provisional message")
 await capture("cemetery_return")
 encounter.enter();await frames(5)
 check(ending.sequence_count==sequences and ending.settled and not boss.awake,"Reentry keeps defeated husk without replay or battle")
 check(encounter.arena.get_node("LeftGate/CollisionShape2D").disabled,"Reentry after victory keeps exit unlocked")
 await capture("reentry")
 # A death outside the room retains the approved session victory and final husk.
 encounter.leave(true)
 hero.receive_damage(999);await frames(50)
 check(encounter.completed and ending.played and ending.settled and boss.current_health==0,"Cemetery death preserves completed encounter and final armor")
 encounter.enter();await frames(3)
 check(ending.sequence_count==sequences and not ending.running,"Reentry after cemetery death cannot replay the cinematic")
 # Same physics tick: sword kills before the overlapping low sweep is queried.
 await prepare(2,2)
 hero.receive_damage(4);await frames(50)
 Input.action_press("attack");await frames(1);Input.action_release("attack");await frames(5)
 boss.facing=-1
 boss._set_state(OathGuardian.State.ATTACK,boss.active_seconds())
 await frames(2)
 check(boss.current_health==0 and not hero.survival.is_dead and hero.survival.current_health==1,"Final sword disarms overlapping sweep before same-tick hurtbox damage")
 check(ending.played and not boss.attack_source.active,"Same-tick victory remains safe and cinematic begins once")
 # Lethal external callback on HP-zero: M2 death wins before presentation signal.
 await prepare(0,2)
 var lethal: Callable=func(hp_now: int,_maximum: int) -> void:
  if hp_now==0:hero.receive_damage(999)
 boss.health_changed.connect(lethal)
 await final_sword()
 boss.health_changed.disconnect(lethal)
 check(hero.survival.is_dead and not ending.played,"Concurrent lethal callback suppresses cinematic before defeat signal")
 await frames(50)
 check(not encounter.active and boss.current_health==10 and not encounter.completed,"Concurrent lethal event resets victory without a softlock")
 encounter.enter();await frames(2)
 # Low-HP fixtures isolate final-hit timing, not artificial new gameplay parameters.
 await prepare(0,1)
 await final_sword()
 check(boss.state==OathGuardian.State.DEFEATED and boss.phase==1 and ending.running,"Phase-one fixture victory also concludes correctly")
 await prepare(0,2)
 boss._set_state(OathGuardian.State.ATTACK,boss.attack_duration)
 check(boss.attack_source.active,"Active-heavy fixture has a real offensive source")
 await final_sword()
 check(boss.state==OathGuardian.State.DEFEATED and ending.running and not boss.attack_source.active,"Actual final sword during attack cancels danger")
 await prepare(3,2)
 boss._set_state(OathGuardian.State.ATTACK,boss.active_seconds())
 check(is_instance_valid(boss.special_wave),"Wave fixture creates an actual residual projectile")
 await final_sword()
 check(boss.current_health==0 and not is_instance_valid(boss.special_wave),"Actual final sword during slam removes residual wave")
 await prepare(0,2)
 await final_sword()
 var pos: Vector2=hero.position
 Input.action_press("jump");await frames(1);Input.action_release("jump");await frames(7)
 check(hero.position.y<pos.y-5,"Aren can jump during cinematic")
 # Same-tick lethal callback after boss HP-zero: death/reset takes precedence.
 hero.receive_damage(999)
 check(not ending.played and not ending.running,"M2 death cancels presentation immediately, before respawn")
 await frames(50)
 check(not encounter.active and not ending.played and boss.current_health==10,"Death during cinematic cancels it and uses normal respawn/reset")
 encounter.enter();await frames(2)
 await prepare(0,2)
 hero.receive_damage(999)
 var prior_count: int=ending.sequence_count
 boss.receive_hit()
 check(not ending.played and ending.sequence_count==prior_count,"Dead Aren cannot start a queued defeat presentation")
 await frames(50)
 check(boss.current_health==10 and not encounter.completed and not ending.played,"Queued final hit after death resets without persistent victory")
 encounter.enter();await frames(2)
 await prepare(0,1)
 boss._start_transition()
 hero.receive_damage(999);await frames(50)
 check(not encounter.active and boss.phase==1 and not ending.played,"Death during phase transition resets normally")
 encounter.enter();await frames(2)
 await prepare(0,2);await final_sword()
 check(ending.running,"New legitimate victory starts fresh cinematic")
 hero.position.y=300;await frames(5)
 check(not encounter.active and not encounter.completed and not ending.played,"Alive-fall abandonment resets cinematic and victory")
 encounter.enter();await frames(2)
 await prepare(0,2);await final_sword()
 var before: int=ending.sequence_count
 encounter.leave(true)
 check(ending.settled and ending.elapsed>=9 and ending.sequence_count==before,"Immediate exit settles without waiting or replay")
 encounter.enter();await frames(4)
 check(ending.settled and ending.sequence_count==before,"Immediate-exit reentry remains quiet and unlocked")
 await prepare(0,2)
 boss.position.x=60
 hero.reset_to(encounter.arena.global_position+Vector2(30,156));hero.facing=1
 await frames(4);await final_sword()
 var count_before: int=ending.sequence_count
 Input.action_press("move_left")
 for i: int in range(30):
  await frames(1)
  if not encounter.active:break
 release()
 check(not encounter.active and ending.settled and ending.elapsed>=9,"Real early walk exits during cinematic without waiting")
 encounter.enter();await frames(3)
 check(ending.sequence_count==count_before and ending.settled,"Real early-exit reentry preserves a single final husk")
 var texture: Texture2D=load("res://assets/art/m4c/guardian_defeat.png")
 check(texture.get_size()==Vector2(1265,1244),"New defeat atlas has documented dimensions")
 check(texture.get_image().detect_alpha()!=Image.ALPHA_NONE,"New defeat atlas preserves transparency")
 check((boss.get_node("CollisionShape2D").shape as RectangleShape2D).size==Vector2(28,62),"Approved physical boss body unchanged")
 check(hero.speed==100 and hero.gravity==680 and hero.jump_impulse==-230 and hero.survival.max_health==5,"Aren controls and survival values unchanged")
 check(main.get_node("ForgottenCemetery/WorldGeometry").get_child_count()==19,"Six-sector level geometry unchanged")
 release()
 FileAccess.open(out+"/victory.json",FileAccess.WRITE).store_string(JSON.stringify({"checks":checks,"failures":failures,"captures":captures,"live_duel":live_result,"resolutions":evidence_sizes},"  "))
 print("M4-C checks: ",checks,"; failures: ",failures)
 quit(0 if failures==0 else 1)
