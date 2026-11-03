class_name ArenAttackArt
extends RefCounted
## Pure presentation: all timings and collision queries remain owned by M1.
const TEXTURE: Texture2D = preload("res://assets/art/fix03/aren_attack.png")
const FRAMES: Array[Rect2] = [
	Rect2(59,21,270,386),Rect2(486,35,295,372),
	Rect2(919,35,335,372),Rect2(1342,40,425,367),
	Rect2(20,488,424,365),Rect2(444,487,374,366),
	Rect2(925,481,302,372),Rect2(1375,473,286,380)
]
const BLADES: Array[Rect2] = [
	Rect2(201,213,102,24),Rect2(580,198,105,23),
	Rect2(1154,206,100,24),Rect2(1668,194,99,24),
	Rect2(364,638,80,26),Rect2(702,651,116,25),
	Rect2(1123,664,104,29),Rect2(1555,660,106,26)
]
const HAND_X: Array[float] = [-5,-11,6,6,9,5,1,0]
const LENGTH: Array[float] = [10,11,22,22,18,15,12,10]

static func pose(attack: SwordAttack) -> int:
	var progress: float = phase_progress(attack)
	match attack.phase:
		SwordAttack.Phase.WINDUP: return mini(1,int(progress*2))
		SwordAttack.Phase.ACTIVE: return 2+mini(1,int(progress*2))
		SwordAttack.Phase.RECOVERY: return 4+mini(3,int(progress*4))
	return -1

static func phase_progress(attack: SwordAttack) -> float:
	var duration: float = attack.windup_duration
	if attack.phase==SwordAttack.Phase.ACTIVE: duration=attack.active_duration
	elif attack.phase==SwordAttack.Phase.RECOVERY: duration=attack.recovery_duration
	return clampf(1.0-attack._remaining/maxf(duration,0.01),0,0.9999)

static func registration(index: int) -> Dictionary:
	var full: Rect2 = FRAMES[index]
	var blade: Rect2 = BLADES[index]
	var scale: Vector2 = Vector2(1.2,1)*36.0/full.size.y
	var root: Vector2 = Vector2(blade.position.x-HAND_X[index]/scale.x,full.end.y)
	var dest: Rect2 = Rect2(Vector2(HAND_X[index],roundf((blade.position.y-root.y)*scale.y)),Vector2(LENGTH[index],maxf(2,roundf(blade.size.y*scale.y))))
	return {"root":root,"scale":scale,"blade":dest}

static func draw_pose(canvas: CanvasItem,index: int) -> void:
	var full: Rect2 = FRAMES[index]
	var blade: Rect2 = BLADES[index]
	var data: Dictionary = registration(index)
	var root: Vector2 = data["root"]
	var scale: Vector2 = data["scale"]
	# Four source pieces omit only the old blade pixels, preserving arm/hand/cape.
	# The very same raster blade joins the hilt and is length-registered to M1.
	var pieces: Array[Rect2] = [
		Rect2(full.position,Vector2(full.size.x,blade.position.y-full.position.y)),
		Rect2(Vector2(full.position.x,blade.end.y),Vector2(full.size.x,full.end.y-blade.end.y)),
		Rect2(Vector2(full.position.x,blade.position.y),Vector2(blade.position.x-full.position.x,blade.size.y)),
		Rect2(Vector2(blade.end.x,blade.position.y),Vector2(full.end.x-blade.end.x,blade.size.y))
	]
	for piece: Rect2 in pieces:
		if piece.has_area():
			var target: Rect2 = Rect2(((piece.position-root)*scale).round(),(piece.size*scale).round())
			canvas.draw_texture_rect_region(TEXTURE,target,piece,Color(1.4,1.43,1.38,1))
	canvas.draw_texture_rect_region(TEXTURE,data["blade"],blade,Color(1.4,1.43,1.38,1))
