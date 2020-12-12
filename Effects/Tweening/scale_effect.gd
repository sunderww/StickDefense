extends Tween

# Add a tweening scale effect on the parent object at creation
class_name ScaleEffect

export var min_time: float = 0.4
export var max_time: float = 0.9

export var enabled: bool = true

func _ready() -> void:
	if not enabled:
		return
	
	randomize()
	
	var parent := get_parent()
	DebugService.debug("interpolate scale on %s" % parent.name)
	interpolate_property(
		parent,
		"scale",
		Vector2.ZERO,
		Vector2.ONE,
		rand_range(min_time, max_time),
		TRANS_CUBIC,
		EASE_OUT
	)
	start()
