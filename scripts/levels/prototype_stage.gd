extends Node2D

@export var fall_limit: float = 224.0
@onready var knight: KnightController = $Knight
@onready var spawn: Marker2D = $Spawn
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	# Run after the player's physics step so respawn ends with zero velocity.
	process_physics_priority = 1
	knight.reset_to(spawn.global_position)
	_update_camera()

func _physics_process(_delta: float) -> void:
	if knight.global_position.y > fall_limit:
		knight.reset_to(spawn.global_position)
	_update_camera()

func _update_camera() -> void:
	# Fixed vertical framing; physics-tick tracking, integer positions, no smoothing.
	camera.position = Vector2(clampf(roundf(knight.position.x), 160.0, 800.0), 90.0)
