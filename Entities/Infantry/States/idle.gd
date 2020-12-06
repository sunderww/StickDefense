extends State

const RUNNING_PATH = "res://Entities/Infantry/States/running.gd"

var wait_time = randf()

func get_name():
	return "idle"

func _process(delta: float) -> void:
	if parent.target:
		wait_time -= delta
		if wait_time < 0:
			var Running = load(RUNNING_PATH)
			set_state(Running.new())
