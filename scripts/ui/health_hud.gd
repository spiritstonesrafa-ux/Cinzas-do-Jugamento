extends CanvasLayer
## Provisional health readout bound by the stage, not a global player lookup.

@onready var label: Label = $Life

func bind(survival: KnightSurvival) -> void:
	survival.health_changed.connect(_on_health_changed)
	_on_health_changed(survival.current_health, survival.max_health)

func _on_health_changed(current: int, maximum: int) -> void:
	label.text = "VIDA %d/%d" % [current, maximum]
