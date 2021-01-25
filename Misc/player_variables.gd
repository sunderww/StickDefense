extends Node


var coin_per_second: float = 1.0
var coin: float

var score: int = 0
var level: int = 0

var killed: Dictionary = Dictionary()
var spawned: Dictionary = Dictionary()


func level_cleared() -> void:
	coin += level * 5
#	coin_per_second += min(1.0, float(level) / 40.0)
	DebugService.info("Level %d cleared ; gained %d coins" % [level, level * 5])
	level += 1


func reset() -> void:
	coin_per_second = 1.0
	coin = 25

	score = 0
	level = 0
	killed = Dictionary()
	spawned = Dictionary()

	if DebugService.level == DebugService.LogLevel.SILLY:
		level = 10
		coin = 20000


func enemy_killed(name: String) -> void:
	if not killed.has(name):
		killed[name] = 0
	killed[name] += 1


func spawn_unit(name: String) -> void:
	if not spawned.has(name):
		spawned[name] = 0
	spawned[name] += 1


func purchase_item(purchase: Purchase) -> void:
	coin -= purchase.price
	spawn_unit(purchase.title)


