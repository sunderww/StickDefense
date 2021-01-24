extends State

const SHOOTING_PATH = "res://Entities/Bazooka/States/shooting.gd"

# Between 1 and 2s for aiming
var wait_time = randf() * 1.0 + 1

func get_name():
	return "aiming"

func _process(delta: float) -> void:
	wait_time -= delta
	if wait_time < 0:
		var Shooting = load(SHOOTING_PATH)
		set_state(Shooting.new())
