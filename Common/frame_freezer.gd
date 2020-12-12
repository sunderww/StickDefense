extends Node2D

export var delay_ms := 30
export var enabled: bool = true

func _on_freeze_requested() -> void:
	if enabled:
		OS.delay_msec(delay_ms)
