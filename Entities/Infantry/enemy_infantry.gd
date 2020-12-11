extends Infantry

class_name EnemyInfantry

signal enemy_died(coin_gain)

export var coin_gain: int = 10

func _init() -> void:
	is_enemy = true
	
func die() -> void:
	.die()
	emit_signal("enemy_died", coin_gain)

func _ready() -> void:
	name = "EInfantry"
	set_direction(true)

