extends Node2D
## Local M3-A/B1 bindings; homologated terrain, camera and respawn rules retained.

const SECTOR_STARTS: Array[float] = [0.0, 384.0, 768.0, 1152.0, 1536.0, 1984.0]
const SECTOR_NAMES: Array[String] = [
	"1/6 Portões do Cemitério", "2/6 Caminho das Lápides",
	"3/6 Jardim dos Mortos", "4/6 Catacumbas",
	"5/6 Ponte das Almas", "6/6 Portão da Catedral"
]
const FALL_LIMIT: float = 288.0
@onready var knight: KnightController = $Knight
@onready var spawn: Marker2D = $Spawn
@onready var camera: Camera2D = $Camera2D
@onready var sector_label: Label = $StageHUD/Sector
@onready var hint_label: Label = $StageHUD/Hint

func _ready() -> void:
	process_physics_priority = 1
	knight.set_default_respawn(spawn.global_position)
	knight.survival.respawn_requested.connect(knight.respawn_at_checkpoint)
	knight.survival.respawn_requested.connect(_restore_enemies)
	for enemy: Node in $Enemies.get_children():
		if enemy is SkeletonPatrol:
			(enemy as SkeletonPatrol).target = knight
		elif enemy is CursedRaven:
			(enemy as CursedRaven).target = knight
	$HealthHUD.bind(knight.survival)
	knight.reset_to(spawn.global_position)
	_update_presentation()

func _physics_process(_delta: float) -> void:
	# Same alive-fall semantics as M0/M2; lower boundary accommodates the crypt.
	if knight.global_position.y > FALL_LIMIT and not knight.survival.is_dead:
		knight.reset_to(spawn.global_position)
		_restore_enemies()
	_update_presentation()

func _restore_enemies() -> void:
	for enemy: Node in $Enemies.get_children():
		if enemy is SkeletonPatrol:
			(enemy as SkeletonPatrol).reset_enemy()
		elif enemy is CursedRaven:
			(enemy as CursedRaven).reset_enemy()
	if has_node("Mechanisms"):
		for mechanism: Node in $Mechanisms.get_children():
			if mechanism is OscillatingBlade:
				(mechanism as OscillatingBlade).reset_hazard()
			elif mechanism is TimedSpikes:
				(mechanism as TimedSpikes).reset_hazard()

func sector_at(x: float) -> int:
	for index: int in range(SECTOR_STARTS.size() - 1, -1, -1):
		if x >= SECTOR_STARTS[index]:
			return index
	return 0

func _update_presentation() -> void:
	# Vertical follow is limited to 64 px for the underground section.
	# Reveal the next descending tread before stepping off either crypt entrance.
	var crypt_weight: float = minf(clampf((knight.position.x - 1056.0) / 32.0, 0.0, 1.0),
		clampf((1600.0 - knight.position.x) / 32.0, 0.0, 1.0))
	var vertical_offset: float = lerpf(66.0, 54.0, crypt_weight)
	camera.position = Vector2(
		clampf(roundf(knight.position.x), 160.0, 2208.0),
		clampf(roundf(knight.position.y - vertical_offset), 90.0, 154.0))
	var sector: int = sector_at(knight.position.x)
	sector_label.text = SECTOR_NAMES[sector]
	hint_label.text = ""
	if sector == 0:
		hint_label.text = "INÍCIO  |  A/D: andar  Espaço: pular  J: espada"
	elif absf(knight.position.x - $FutureCheckpoint1.position.x) < 64.0:
		hint_label.text = "CP1 — retorno após morte"
	elif absf(knight.position.x - $FutureCheckpoint2.position.x) < 48.0:
		hint_label.text = "CP2 — retorno após morte"
	elif knight.position.x >= $Finish.position.x - 32.0:
		hint_label.text = "FIM PROVISÓRIO M3-C — aguarda playtest"
