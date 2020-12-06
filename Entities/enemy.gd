extends BaseEnemy

const Idle = preload("res://Entities/Infantry/States/idle.gd")

func _ready() -> void:
	self.name = "Enemy"
	state = Idle.new()
	state.enter(self)
