extends SceneTree
## UI regression for the new adapter: essential information must remain visible and fit.
var checks: int = 0
var failures: int = 0

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
	var main: Node = (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await frames(5)
	var stage: Node2D = main.get_node("ForgottenCemetery") as Node2D
	var hero: KnightController = stage.get_node("Knight") as KnightController
	var adapter: Node2D = stage.get_node("StageHUD/Presentation") as Node2D
	var sector: Label = stage.get_node("StageHUD/Sector") as Label
	var hint: Label = stage.get_node("StageHUD/Hint") as Label
	check(not sector.visible and not hint.visible and adapter.is_visible_in_tree(),"New presentation is visible without duplicate old text")
	var tutorial: String = adapter.display_notice()
	check(tutorial.contains("A/D") and tutorial.contains("Espaço") and tutorial.contains("J"),"All three essential controls remain in the introductory notice")
	var font: Font = sector.get_theme_font("font")
	check(font.get_string_size(tutorial,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x<=300,"Control notice fits within the 320px viewport")
	var places: Array[Vector2] = [Vector2(160,156),Vector2(710,140),Vector2(990,156),Vector2(1348,220),Vector2(1788,144),Vector2(2212,156)]
	var labels_ok: bool = true
	var header_fits: bool = true
	for index: int in range(places.size()):
		hero.reset_to(places[index])
		await frames(3)
		labels_ok = labels_ok and sector.text==stage.SECTOR_NAMES[index]
		var width: float = font.get_string_size(sector.text,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x
		header_fits = header_fits and width<=190
	check(labels_ok,"All six actual stage sectors still feed the presentation adapter")
	check(header_fits,"Every sector title fits to the right of the 109px health frame")
	hero.reset_to(Vector2(1176,180))
	await frames(3)
	check(adapter.display_notice().contains("CP1") and adapter.display_notice().contains("morte"),"CP1 death-return information remains presented")
	hero.reset_to(Vector2(1936,156))
	await frames(3)
	check(adapter.display_notice().contains("CP2") and adapter.display_notice().contains("morte"),"CP2 death-return information remains presented")
	hero.reset_to(Vector2(2288,156))
	await frames(3)
	var finish: String = adapter.display_notice()
	check(finish.contains("Fim provisório") and finish.contains("playtest"),"Provisional finish retains its meaning and does not introduce a next level")
	check(font.get_string_size(finish,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x<=300,"Finish notice fits within the viewport")
	hero.reset_to(Vector2(710,140))
	await frames(3)
	check(adapter.display_notice().is_empty(),"Ordinary traversal clears contextual notices")
	print("M3-D-FIX01 presentation checks: ",checks,"; failures: ",failures)
	quit(0 if failures==0 else 1)
