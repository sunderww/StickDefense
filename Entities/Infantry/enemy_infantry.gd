extends BaseEnemy

const Idle = preload("res://Entities/Infantry/States/idle.gd")

func _ready() -> void:
	self.name = "EInfantry"
	state = Idle.new()
	state.enter(self)
