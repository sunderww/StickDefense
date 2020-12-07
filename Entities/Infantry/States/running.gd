extends State

const IDLE_PATH = "res://Entities/Infantry/States/idle.gd"
const ATTACK_PATH = "res://Entities/Infantry/States/attacking.gd"
const AIMING_PATH = "res://Entities/Infantry/States/aiming.gd"

func get_name() -> String:
	return "running"


func _fixed_process(delta: float) -> void:
	var target = self.parent.target
	
	if not target:
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
		return
	
	# If the parent has the shooting ability and bullets and the target in range start to aim
	if parent.has_method("can_shoot_target") and parent.can_shoot_target():
		var Aiming = load(AIMING_PATH)
		set_state(Aiming.new())
		return
	
	if parent.target_in_range():
		var Attacking = load(ATTACK_PATH)
		set_state(Attacking.new())
		return
	
	parent.set_direction_towards_target()
	parent.velocity.x = parent.MOVE_SPEED_PX
	parent.velocity.x *= parent.direction
	
	parent.velocity.x *= delta
	parent.velocity = parent.move_and_slide(parent.velocity)
