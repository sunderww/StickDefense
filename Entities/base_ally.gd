extends BaseEntity

class_name BaseAlly

var max_pos_x: int = -1

func execute_movement() -> void:
	velocity = Vector2.ZERO

	# Apply gravity
	velocity.y = 100
	
	# Idle if : no target, can't go further, or too close to ally
	if not target or \
	  (max_pos_x >= 0 and global_position.x > max_pos_x):
#		enter_state("idle")
		return

	if target and not target_in_range():
		set_direction_towards_target()
#		enter_state("walking")
		velocity.x = MOVE_SPEED_PX * stats.speed
		velocity.x *= direction


