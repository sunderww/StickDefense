extends Node


var coin_per_second: float = 1.0
var coin: float
var base_coin: float = 20

var score: int = 0
var level: int = 0

func level_cleared() -> void:
#	coin_per_second += min(1.0, float(level) / 40.0)
	DebugService.info("Level %d cleared ; cps is %f" % [level, coin_per_second])
	level += 1
