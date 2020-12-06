extends BaseEntity

class_name BaseEnemy


signal enemy_died(coin_gain)

var coin_gain: int = 10

func _init() -> void:
	is_enemy = true
	
func die() -> void:
	.die()
	emit_signal("enemy_died", coin_gain)

