class_name DamageSource
extends Area2D
## M2 contact contract; the default static hazard delivers one health point.

func contact_damage(_receiver_id: int) -> int:
	return 1

func _draw() -> void:
	CemeterySpriteArt.draw(self,8,Rect2(-10,-12,20,12),Color(1.2,1.2,1.15,1))
