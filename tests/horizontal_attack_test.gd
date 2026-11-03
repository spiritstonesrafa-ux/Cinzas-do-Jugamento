extends SceneTree
## Real input/physics FIX03 regression. No M1 timing or damage mutation.
var checks: int = 0
var failures: int = 0
var main: Node
var stage: Node2D
var hero: KnightController
var attack: SwordAttack
var target: TrainingTarget

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

func release() -> void:
	for action: String in ["attack","jump","move_left","move_right"]: Input.action_release(action)

func place(offset: float=24,side: int=1) -> void:
	release()
	hero.reset_to(Vector2(450,156))
	hero.survival.restore()
	hero.facing=side
	target.position=Vector2(450+offset,156)
	target.hit_count=0
	await frames(4)

func press() -> void:
	Input.action_press("attack")
	await frames(1)
	Input.action_release("attack")

func shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://.godot/fix03-impact-"+label+".png")

func cycle(side: int) -> void:
	await place(24*side,side)
	await press()
	check(attack.phase==SwordAttack.Phase.WINDUP and ArenAttackArt.pose(attack)==0,"Real input starts integrated anticipation, side "+str(side))
	var seen: Dictionary={}
	var gates: bool=true
	var registered: bool=true
	var mirrored: bool=true
	var phases: bool=true
	for tick: int in range(26):
		gates=gates and (attack.hit_shape.disabled==(attack.phase!=SwordAttack.Phase.ACTIVE))
		var pose: int=ArenAttackArt.pose(attack)
		if pose>=0:
			seen[pose]=true
			mirrored=mirrored and hero.visual.scale.x==side and attack.direction==side
			phases=phases and ((pose<=1 and attack.phase==SwordAttack.Phase.WINDUP) or (pose in [2,3] and attack.phase==SwordAttack.Phase.ACTIVE) or (pose>=4 and attack.phase==SwordAttack.Phase.RECOVERY))
			if attack.phase==SwordAttack.Phase.ACTIVE:
				var rect: Rect2=ArenAttackArt.registration(pose)["blade"]
				registered=registered and Rect2(6,-21,22,14).encloses(rect)
				var point: Vector2=hero.visual.to_global(rect.get_center())
				var local: Vector2=attack.hit_shape.to_local(point)
				registered=registered and absf(local.x)<=11 and absf(local.y)<=7
		await frames(1)
	check(seen.size()==8,"All eight authored attack poses occur in real physics ticks, side "+str(side))
	check(phases,"Pose ranges follow actual M1 phases, side "+str(side))
	check(gates,"No offensive shape outside actual active ticks, side "+str(side))
	check(registered,"Rendered blade bounds and global blade center stay inside real hitbox, side "+str(side))
	check(mirrored,"Attack body/hand/blade and hitbox retain the same locked side, side "+str(side))
	check(target.hit_count==1,"Physical target receives exactly one damage event per swing, side "+str(side))
	check(attack.phase==SwordAttack.Phase.NEUTRAL and ArenAttackArt.pose(attack)==-1,"Clean return to approved non-attack animation, side "+str(side))

func raven_counter(side: int) -> void:
	release()
	hero.reset_to(Vector2(1050+side*24,156))
	hero.survival.restore()
	stage._restore_enemies()
	var raven: CursedRaven=stage.get_node("Enemies/CursedRaven") as CursedRaven
	raven.target=null
	await frames(4)
	raven.target=hero
	await frames(1)
	var away: String="move_right" if side>0 else "move_left"
	Input.action_press(away)
	await frames(12)
	Input.action_release(away)
	await frames(4)
	for tick: int in range(160):
		if raven.state==CursedRaven.State.RECOVER: break
		await frames(1)
	check(raven.state==CursedRaven.State.RECOVER,"Real locked raven dive reaches counter window, side "+str(side))
	check(absf(raven.position.y-(hero.position.y-14))<0.2,"Raven is physically at the unchanged sword height, side "+str(side))
	Input.action_press("move_left" if side>0 else "move_right")
	await frames(1)
	release()
	await frames(3)
	await press()
	await frames(7)
	check(raven.current_health==1 and raven.state==CursedRaven.State.HURT,"Integrated horizontal attack really hits recovering raven once, side "+str(side))
	check(attack.phase==SwordAttack.Phase.ACTIVE and ArenAttackArt.pose(attack) in [2,3],"Raven impact uses new active body/hand/blade pose, side "+str(side))
	await shot("raven-"+str(side))
	await frames(24)
	check(raven.current_health==1,"Raven receives no duplicate event from same attack, side "+str(side))

func run() -> void:
	main=(load("res://tests/fixtures/baseline_main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	stage=main.get_node("PrototypeStage") as Node2D
	hero=stage.get_node("Knight") as KnightController
	attack=hero.sword_attack
	target=stage.get_node("TrainingTarget") as TrainingTarget
	await frames(4)
	check(attack.windup_duration==0.10 and attack.active_duration==0.10 and attack.recovery_duration==0.20,"Homologated 0.10/0.10/0.20 cycle retained")
	check((attack.hit_shape.shape as RectangleShape2D).size==Vector2(22,14),"Original sword shape remains 22x14")
	await cycle(1)
	await cycle(-1)
	await place(-24,1)
	await press()
	await frames(28)
	check(target.hit_count==0,"No hit behind Aren")
	await place(50,1)
	await press()
	await frames(28)
	check(target.hit_count==0,"No arbitrary reach extension")
	await place()
	Input.action_press("attack")
	await frames(60)
	check(target.hit_count==1 and attack.phase==SwordAttack.Phase.NEUTRAL,"Holding attack does not repeat or bypass the cycle")
	release()
	await frames(2)
	await place()
	await press()
	await frames(14)
	await press()
	await frames(35)
	check(target.hit_count==1 and attack.phase==SwordAttack.Phase.NEUTRAL,"Recovery press remains discarded; no combo or queued attack")
	await place(70)
	var start: float=hero.position.x
	Input.action_press("move_right")
	await press()
	await frames(6)
	check(hero.position.x>start and hero.velocity.x<=100,"Movement remains available at original speed during attack")
	Input.action_press("move_left")
	Input.action_release("move_right")
	await frames(1)
	check(attack.direction==1 and hero.visual.scale.x==1,"Changing movement does not flip an ongoing body/hand/blade attack")
	await place()
	Input.action_press("jump")
	await frames(3)
	Input.action_release("jump")
	await press()
	check(not hero.is_on_floor() and attack.phase==SwordAttack.Phase.NEUTRAL,"Airborne input cannot start a new attack, as in M1")
	for tick: int in range(90):
		if hero.is_on_floor(): break
		await frames(1)
	await press()
	check(attack.phase==SwordAttack.Phase.WINDUP,"Attack works normally after landing")
	await place()
	await press()
	Input.action_press("jump")
	await frames(3)
	Input.action_release("jump")
	check(not hero.is_on_floor() and ArenAttackArt.pose(attack)>=0,"Ground-started attack remains presented after jumping, per original M1")
	hero.reset_to(Vector2(450,156))
	check(attack.phase==SwordAttack.Phase.NEUTRAL and attack.hit_shape.disabled and ArenAttackArt.pose(attack)==-1,"Reset/cancel leaves no ghost shape or attack sprite")
	await place()
	hero.receive_damage(1)
	await press()
	await frames(7)
	check(hero.survival.current_health==4 and target.hit_count==1,"Post-damage attack preserves health contract and deals one hit")
	await frames(50)
	await press()
	hero.receive_damage(999)
	check(hero.survival.is_dead and attack.phase==SwordAttack.Phase.NEUTRAL and attack.hit_shape.disabled,"Death cancels combat and attack presentation immediately")
	release()
	main.queue_free()
	await frames(4)
	main=(load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	stage=main.get_node("ForgottenCemetery") as Node2D
	hero=stage.get_node("Knight") as KnightController
	attack=hero.sword_attack
	await frames(4)
	var skeleton: SkeletonPatrol=stage.get_node("Enemies/SkeletonPatrol") as SkeletonPatrol
	for side: int in [1,-1]:
		release()
		hero.reset_to(Vector2(744-side*24,140))
		hero.survival.restore()
		hero.facing=side
		stage._restore_enemies()
		await frames(4)
		await press()
		await frames(7)
		check(skeleton.current_health==2,"New horizontal pose hits actual skeleton with original one-point damage, side "+str(side))
		check(ArenAttackArt.pose(attack) in [2,3],"Skeleton impact uses integrated active pose, side "+str(side))
		await shot("skeleton-"+str(side))
		await frames(20)
		check(skeleton.current_health==2,"Skeleton receives one event only from the swing, side "+str(side))
	await raven_counter(1)
	await raven_counter(-1)
	print("M3-D-FIX03 horizontal checks: ",checks,"; failures: ",failures)
	quit(0 if failures==0 else 1)
