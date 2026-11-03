class_name SwordReceiver
extends Area2D
## M1 receive_hit contract shared by the original dummy and enemy hurtboxes.
signal hit_received

func receive_hit() -> void:
	hit_received.emit()
