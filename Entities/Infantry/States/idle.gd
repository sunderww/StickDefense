extends State

const RUNNING_PATH = "res://Entities/Infantry/States/running.gd"

var wait_time = randf()

func get_name():
	return "idle"

func enter(parent) -> void:
	.enter(parent)

	# Randomize the starting frame so that all units don't have the same
	# animation at the same time when an enemy is dead and they go back
	# to idle	
	var 	sprite: AnimatedSprite = parent.get_node("AnimatedSprite")
	sprite.frame = randi() % sprite.frames.get_frame_count(sprite.animation)

func _process(delta: float) -> void:
	if parent.target:
		wait_time -= delta
		if wait_time < 0:
			var Running = load(RUNNING_PATH)
			set_state(Running.new())
