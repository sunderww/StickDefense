extends BaseAlly

const Idle = preload("res://Entities/Infantry/States/idle.gd")

var bullets = 6

func _init() -> void:
	stats.life = 120
	stats.damage = 40
	stats.attack_delay = 0.8

func _ready() -> void:
	self.name = "Infantry"
	state = Idle.new()
	state.enter(self)


func attack_target() -> void:
	can_attack = false
	($AttackTimer as Timer).start()
	
	# In order to match the animation, wait before taking damage
	yield(get_tree().create_timer(0.15), "timeout")
	target.suffer_attack(stats.damage)
