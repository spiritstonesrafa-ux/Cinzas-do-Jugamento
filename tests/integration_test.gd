extends "res://tests/mechanisms_test.gd"
## M3-E: chained real-scene journeys after death, live fall and fixture enemy defeat.
## Reuses the established input navigator; partial legs assert their actual sectors.
var captured: Array[int]=[]
var output: String
var intervals: Array[float]=[]
var memory_samples: Array=[]
var last_us: int=0
var started_us: int=0
var collecting: bool=false
var native: bool=false
var scene_load_ms: float=0
func _sample() -> void:
 if not collecting:return
 var now: int=Time.get_ticks_usec()
 if last_us>0:intervals.append((now-last_us)/1000.0)
 last_us=now
 if intervals.size()%60==0:
  memory_samples.append({"seconds":(now-started_us)/1000000.0,"static_bytes":Performance.get_monitor(Performance.MEMORY_STATIC),"texture_bytes":Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED),"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"orphans":Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)})
func _capture_sector(index: int) -> void:
 captured.append(index)
 if not native:return
 collecting=false
 await RenderingServer.frame_post_draw
 var image: Image=root.get_texture().get_image()
 image.save_png(output+"/sector_"+str(index+1)+".png")
 last_us=0
 collecting=true
func _capture(label: String) -> void:
 if not native:return
 collecting=false
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output+"/"+label+".png")
 last_us=0
 collecting=true
func _restored() -> bool:
 for enemy: Node2D in _enemies.get_children():
  if enemy.current_health!=enemy.max_health or enemy.attack_source.active:return false
 return true
func _fixture_defeat_all() -> void:
 # This is reset-state setup, not proof of a sword kill (covered by real combat suites).
 for enemy: Node2D in _enemies.get_children():
  for hit: int in range(enemy.max_health):enemy.receive_hit()
func _run() -> void:
 output=OS.get_environment("CINZAS_M3E_EVIDENCE")
 if output.is_empty():output=ProjectSettings.globalize_path("res://.godot/m3e")
 DirAccess.make_dir_recursive_absolute(output)
 native=OS.get_environment("CINZAS_M3E_NATIVE")=="1"
 if native:
  Engine.max_fps=60
  DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
  root.mode=Window.MODE_FULLSCREEN
 await _frames(3)
 var loading: int=Time.get_ticks_usec()
 var main: Node=(load("res://scenes/main.tscn") as PackedScene).instantiate()
 root.add_child(main)
 scene_load_ms=(Time.get_ticks_usec()-loading)/1000.0
 _stage=main.get_node("ForgottenCemetery") as Node2D
 _knight=_stage.get_node("Knight") as KnightController
 _camera=_stage.get_node("Camera2D") as Camera2D
 _enemies=_stage.get_node("Enemies") as Node2D
 spikes=_stage.get_node("Mechanisms/GardenSpikes") as DamageSource
 blade=_stage.get_node("Mechanisms/CryptBlade") as OscillatingBlade
 timed=_stage.get_node("Mechanisms/CathedralTimed") as TimedSpikes
 cp1=_stage.get_node("Mechanisms/Checkpoint1") as CemeteryCheckpoint
 cp2=_stage.get_node("Mechanisms/Checkpoint2") as CemeteryCheckpoint
 _knight.survival.died.connect(func() -> void:deaths+=1)
 _knight.survival.respawn_requested.connect(func() -> void:respawns+=1)
 await _frames(30)
 _check(root.content_scale_mode==Window.CONTENT_SCALE_MODE_CANVAS_ITEMS and root.get_visible_rect().size==Vector2(320,180),"Approved display and logical FOV retained")
 _check(_knight.speed==100 and _knight.gravity==680 and _knight.jump_impulse==-230,"Homologated motion parameters unchanged")
 _check(_enemies.get_child_count()==6 and _stage.get_node("WorldGeometry").get_child_count()==19,"Authored distribution and solids unchanged")
 started_us=Time.get_ticks_usec();last_us=0;collecting=native
 process_frame.connect(_sample)
 for cp: CemeteryCheckpoint in [cp1,cp2]:
  _clear_checkpoints()
  await _place(cp.position)
  _check(_knight.active_checkpoint==cp,"Checkpoint physically activated for chained reset test")
  for iteration: int in range(5):
   _fixture_defeat_all()
   _knight.receive_damage(999)
   await _frames(50)
   _check(not _knight.survival.is_dead and _knight.survival.current_health==5,"Repeated death restores health")
   _check(_knight.position.distance_to(cp.position)<0.2 and _knight.is_on_floor(),"Repeated death lands at active supported checkpoint")
   _check(_restored(),"Death restores six enemies and inactive attack sources")
   _check(_knight.sword_attack.phase==SwordAttack.Phase.NEUTRAL and _knight.sword_attack.hit_shape.disabled,"Death leaves no stale sword hitbox")
   _check(_stage.get_node("HealthHUD/Life").text=="VIDA 5/5" and _stage.get_node("HealthHUD/Frame").current==5,"Health signal synchronizes label and art after reset")
   await _frames(100)
   _check(_knight.survival.current_health==5,"Checkpoint remains safe between repeated resets")
  await _capture("cp"+str(cp.progression_index)+"_active")
  var sectors: Array[int]=[4,5]
  if cp==cp1:sectors.assign([3,4,5])
  _check(await _integration_route(1,2288,sectors),"Forward traversal directly after checkpoint respawn")
  _check(await _integration_route(-1,48,[5,4,3,2,1,0]),"Return after checkpoint respawn and active enemies")
 _check(deaths==10 and respawns==10,"Ten deaths produce exactly ten respawn events")
 await _place(cp2.position)
 _knight.receive_damage(1)
 _fixture_defeat_all()
 _knight.position=Vector2(1740,300)
 await _frames(1)
 _check(_knight.position.distance_to(Vector2(48,156))<0.2 and _knight.survival.current_health==4,"Alive fall returns to original start without healing")
 _check(_knight.active_checkpoint==cp2 and _restored(),"Alive fall retains CP2 progression and restores all enemies")
 _check(timed.state==TimedSpikes.State.SAFE and blade.position==blade.origin-blade.travel,"Alive fall resets trap cycle consistently")
 _check(await _integration_route(1,2288,[0,1,2,3,4,5]),"Full live traversal after unhealed fall")
 _check(await _integration_route(-1,48,[5,4,3,2,1,0]),"Full live return after unhealed fall")
 await _place(Vector2(48,156))
 _fixture_defeat_all()
 await _frames(1)
 _check(await _integration_route(1,2288,[0,1,2,3,4,5]),"Defeated enemies leave no persistent forward blocker")
 _check(await _integration_route(-1,48,[5,4,3,2,1,0]),"Defeated enemies leave no persistent reverse blocker")
 collecting=false
 var duration: float=(Time.get_ticks_usec()-started_us)/1000000.0
 var sorted: Array[float]=intervals.duplicate();sorted.sort()
 var metrics: Dictionary={"native":native,"wall_s":duration,"scene_load_ms":scene_load_ms,"frame_samples":intervals.size(),"memory_samples":memory_samples,"checks":_checks,"failures":_failures,"window":str(root.size),"logical":str(root.get_visible_rect())}
 if not sorted.is_empty():
  var sum: float=0
  for interval: float in intervals:sum+=interval
  metrics.merge({"observed_fps":1000.0*intervals.size()/sum,"p95_ms":sorted[int((sorted.size()-1)*0.95)],"max_ms":sorted[-1],"sampled_seconds":sum/1000.0})
 var file: FileAccess=FileAccess.open(output+"/integration_metrics.json",FileAccess.WRITE)
 file.store_string(JSON.stringify(metrics,"  "))
 _release()
 print("M3-E checks: ",_checks,"; failures: ",_failures)
 quit(0 if _failures==0 else 1)

func _integration_route(direction: int, destination: float, expected: Array[int]) -> bool:
 var action: String = "move_right" if direction > 0 else "move_left"
 var visited: Array[int] = []
 var camera_valid: bool = true
 var crypt_seen: bool = false
 var previous_x: float = _knight.position.x
 var frames_stuck: int = 0
 var start_health: int = _knight.survival.current_health
 Input.action_press(action)
 for frame: int in range(2400):
  Input.action_release("jump")
  Input.action_release("attack")
  var p: Vector2 = _knight.position
  var index: int = _stage.sector_at(p.x)
  if not captured.has(index): await _capture_sector(index)
  if not visited.has(index):
   visited.append(index)
  crypt_seen = crypt_seen or (index == 3 and p.y > 210.0)
  camera_valid = camera_valid and _camera.position == _camera.position.round()
  camera_valid = camera_valid and _camera.position.x >= 160.0 and _camera.position.x <= 2208.0
  camera_valid = camera_valid and _camera.position.y >= 90.0 and _camera.position.y <= 154.0
  # Ground lookahead detects a lip; low forward ray detects a raised block.
  if _knight.is_on_floor():
   var ahead: Vector2 = p + Vector2(8 * direction, 0)
   if (not _ray(ahead + Vector2(0, -2), ahead + Vector2(0, 6)) and not (expected[0]==3 and direction>0 and p.x>=1152 and p.x<1280)) or _ray(p + Vector2(0, -4), ahead + Vector2(0, -4)):
    Input.action_press("jump")
  # New traps are observed before crossing; enemy processing remains active.
  var spike_distance: float = (824.0-p.x)*direction
  if _knight.is_on_floor() and spike_distance > 0 and spike_distance < 26:
   Input.action_press("jump")
  var timed_distance: float = (2016.0-p.x)*direction
  if _knight.is_on_floor() and timed_distance > 0 and timed_distance < 30:
   Input.action_press("jump")
  # Resolve crypt ground threat first; blade has a separate observation space.
  var crypt: SkeletonPatrol = _enemies.get_node("CryptSkeleton") as SkeletonPatrol
  if _knight.is_on_floor() and absf(p.y-220) < 1 and crypt.current_health > 0 and absf(crypt.position.x-p.x) < 25:
   Input.action_release(action)
   for attempt: int in range(4):
    if crypt.current_health == 0: break
    # A reset may put the moving target behind Aren; face its real position.
    await _face(1 if crypt.position.x>_knight.position.x else -1)
    await _swing()
    await _frames(18)
   await _face(direction)
   Input.action_press(action)
  # Wait outside the blade circle; its top window lasts long enough for walking.
  var blade_distance: float = (1384.0-p.x)*direction
  if _knight.is_on_floor() and absf(p.y-220) < 30 and blade_distance > 17 and blade_distance < 40:
   var phase: float = blade.elapsed / blade.period
   if phase > 0.08 and phase < 0.74:
    Input.action_release(action)
    await _frames(1)
    previous_x = _knight.position.x
    frames_stuck = 0
    continue
   Input.action_press(action)
  # Existing ground-threat anticipation.

  for enemy: Node2D in _enemies.get_children():
   if enemy is SkeletonPatrol and enemy.current_health > 0 and _knight.is_on_floor():
    var ahead_distance: float = (enemy.position.x - p.x) * direction
    if ahead_distance > 12 and ahead_distance < 48 and absf(enemy.position.y - p.y) < 20:
     Input.action_press("jump")
  if frame % 26 == 0 and _knight.is_on_floor():
   Input.action_press("attack")
  await _frames(1)
  if _knight.survival.is_dead or (_knight.position.x - previous_x) * direction < -100.0:
   break
  if absf(_knight.position.x - previous_x) < 0.1:
   frames_stuck += 1
  else:
   frames_stuck = 0
  previous_x = _knight.position.x
  # A fall return or an impassable obstacle must fail, never be hidden by retry.
  if _knight.position.y > 250.0 or frames_stuck > 90:
   print("Traversal blocked at ", _knight.position, " direction ", direction)
   break
  if (_knight.position.x - destination) * direction >= 0.0:
   Input.action_release("attack")
   Input.action_release(action)
   Input.action_release("jump")
   await _frames(30)
   _check(visited == expected, "Requested integration leg sectors traversed in order, direction %d" % direction)
   _check(crypt_seen or not expected.has(3), "Route actually descends underground, direction %d" % direction)
   _check(camera_valid, "Camera stays integer and inside bounds throughout live traversal")
   print("LIVE ROUTE direction=", direction, " HP ", start_health, " -> ", _knight.survival.current_health)
   return true
 print("M3C ROUTE FAILED pos=",_knight.position," HP=",_knight.survival.current_health," dead=",_knight.survival.is_dead," blade=",blade.position," direction=",direction)
 Input.action_release(action)
 Input.action_release("jump")
 return false
