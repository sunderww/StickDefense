extends Particles2D

var should_be_removed: bool = false
var time = 0

# Wait for all particles to be dead before calling free()
func _process(delta: float) -> void:
	if should_be_removed and not emitting:
		if time > lifetime:
			queue_free()
		time += delta
