extends State


func get_name():
	return "forward"

func enter(parent) -> void:
	.enter(parent)
	parent.angle = 35

	# Randomize the starting frame so that all units don't have the same
	# animation at the same time when an enemy is dead and they go back
	# to idle	
	var 	sprite: AnimatedSprite = parent.get_node("AnimatedSprite")
	sprite.frame = randi() % sprite.frames.get_frame_count(sprite.animation)

func _fixed_process(delta: float) -> void:
	parent.velocity.x = parent.MOVE_SPEED_PX * delta
	
