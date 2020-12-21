extends State

const IDLE_PATH = "res://Entities/Claymore/States/idle.gd"

func get_name() -> String:
	return "running"


func _fixed_process(delta: float) -> void:
	var target = self.parent.target
	
	if not target or parent.target_in_range():
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
		return
	
	parent.set_direction_towards_target()
	parent.velocity.x = parent.MOVE_SPEED_PX
	parent.velocity.x *= parent.direction
	
	parent.velocity.x *= delta
