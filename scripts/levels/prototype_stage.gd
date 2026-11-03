extends Node2D

@export var fall_limit: float = 224.0
@onready var knight: KnightController = $Knight
@onready var spawn: Marker2D = $Spawn
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	# Run after the player's physics step so respawn ends with zero velocity.
	process_physics_priority = 1
	knight.set_default_respawn(spawn.global_position)
	knight.survival.respawn_requested.connect(knight.respawn_at_checkpoint)
	$HealthHUD.bind(knight.survival)
	knight.reset_to(spawn.global_position)
	_update_camera()

func _physics_process(_delta: float) -> void:
	# Alive falls preserve M0's return to the original start; death uses checkpoints.
	if knight.global_position.y > fall_limit and not knight.survival.is_dead:
		knight.reset_to(spawn.global_position)
	_update_camera()

func _update_camera() -> void:
	# Fixed vertical framing; physics-tick tracking, integer positions, no smoothing.
	camera.position = Vector2(clampf(roundf(knight.position.x), 160.0, 800.0), 90.0)
