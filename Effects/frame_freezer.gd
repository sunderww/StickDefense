extends Node2D

export var delay_ms := 30
export var enabled: bool = true

# Time between two requests
export var wait_time_s: float = 0.25
var elapsed_time: float = 0

func freeze(duration_ms: int) -> void:
	elapsed_time = 0
	OS.delay_msec(duration_ms)

func _on_freeze_requested() -> void:
	if enabled and elapsed_time > wait_time_s:
		DebugService.debug("Freeze frame after %f s" % elapsed_time)
		freeze(delay_ms)

func _process(delta: float) -> void:
	elapsed_time += delta
