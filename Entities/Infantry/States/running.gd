extends State

const IDLE_PATH = "res://Entities/Infantry/States/idle.gd"

func get_name() -> String:
	return "running"


func _fixed_process(delta: float) -> void:
	var target = self.parent.target
	
	if not target:
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
	
	if parent.target_in_range():
		return
#		return Attacking.new()
	
	parent.velocity = Vector2.ZERO
	parent.velocity.y = 100 # Apply gravity
	
	parent.set_direction_towards_target()
	parent.velocity.x = parent.MOVE_SPEED_PX * parent.stats.speed
	parent.velocity.x *= parent.direction
	
	parent.velocity.x *= delta
	parent.velocity = parent.move_and_slide(parent.velocity)
