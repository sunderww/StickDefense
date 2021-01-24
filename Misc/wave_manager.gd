extends Node

class_name WaveManager

signal spawn_enemy(enemy)


class Enemy:
	var resource_path: String
	var expected_lifetime: float
	var intensity_score: float
	var minimum_level: int
	var spawn_weight: int
	
	
	func _init(path: String, lifetime: float, intensity: float, weight: int, min_lvl: int = 0) -> void:
		resource_path = path
		expected_lifetime = lifetime
		intensity_score = intensity
		spawn_weight = weight
		minimum_level = min_lvl


class WaveItem:
	var time: float
	var resource_path: String
	
	func _init(_time: float, _resource_path: String):
		time = _time
		resource_path = _resource_path



var elapsed_time: float = 0

# Array of WaveItem sorted by time
var items: Array = []
var next_item: WaveItem = null
var started: bool = false

func start(level: int):
	items = _generate_wave(level)
	
	elapsed_time = 0
	started = true
	next_item = items.pop_front()


func is_over() -> bool:
	return next_item == null


func _process(delta: float) -> void:
	elapsed_time += delta
	
	# We may have multiple entities to spawn at the same time
	while next_item and next_item.time < elapsed_time:
		_spawn_item(next_item)
		next_item = items.pop_front()


func _spawn_item(item: WaveItem) -> void:
	var enemy: BaseEntity = load(item.resource_path).instance()
	emit_signal("spawn_enemy", enemy)

var ENEMIES := [
	# Enemy.new(path: String, lifetime: float, intensity: float, weight: int, min_lvl: int = 0)
	Enemy.new("res://Entities/Swordsman/Swordsman.tscn", 3, 3, 20),
	Enemy.new("res://Entities/Infantry/EnemyInfantry.tscn", 8, 5, 10, 3),
	Enemy.new("res://Entities/Claymore/Claymore.tscn", 3, 5, 5, 5),
	Enemy.new("res://Entities/Chopper/Chopper.tscn", 20, 10, 2, 7),
] 

func _get_available_enemies(level: int) -> Array:
	var available: Array = []
	
	for enemy in ENEMIES:
		if enemy.minimum_level <= level:
			available.append(enemy)
	return available

# return a list of WaveItems and a wait time
func _generate_subwave(available_enemies: Array, time_offset: float, intensity_per_s: float, is_first: bool = false):
	var enemies: Array = []
	
	var total_weight: int = 0
	for enemy in available_enemies:
		total_weight += enemy.spawn_weight

	# Once every ~4 spawns, spawn multiple enemies at once
	# Never put multiple enemies at first spawn
	var spawn_count = 1
	if randi() % 4 == 1 and not is_first:
		# Early levels will spawn less enemies at the same time than high levels
		var max_spawn = max(3, int(floor(intensity_per_s)))
		var min_spawn = 2
		spawn_count = randi() % (max_spawn - min_spawn + 1) + min_spawn
	
	var intensity = 0
	for _i in range(spawn_count):
		var enemy: Enemy = _random_enemy(total_weight, available_enemies)
		var spawn_time = time_offset + rand_range(0, 1) # Spawn randomly during one second

		enemies.append(WaveItem.new(spawn_time, enemy.resource_path))
		intensity += enemy.intensity_score

	var duration: float = float(intensity) / intensity_per_s
	var duration_multiplier: float = rand_range(0.9, 1.1)
	return {
		"enemies": enemies,
		"duration": duration * duration_multiplier
	}

# Must generate a list of items. The higher the level, the more difficult.
# A wave consists of different subwaves at different times. Each subwave
# contains one or more enemies
func _generate_wave(level: int) -> Array:
	var wave_duration: float = 5 * level + 10
	var intensity: float = (3 + int(float(level) / 3.0)) * level * level + 15
	var intensity_per_s: float = intensity / wave_duration
	DebugService.info("Generating wave %d. Intensity %f in %fs (%f/s)" % [level, intensity, wave_duration, intensity_per_s])

	var available_enemies = _get_available_enemies(level)
	var wave: Array = [] # The wave to be returned
	
	var time_offset: float = 0
	var first: bool = true
	while time_offset < wave_duration:
		var subwave = _generate_subwave(available_enemies, time_offset, intensity_per_s, first)
		time_offset += subwave["duration"]
		wave += subwave["enemies"]
		first = false

	return wave


# Returns an enemy from the given list with their probability weighted
func _random_enemy(total_weight: int, available_enemies: Array) -> Enemy:
	var index: int = randi() % total_weight
	
	var weight_offset = 0
	for enemy in available_enemies:
		if index < enemy.spawn_weight + weight_offset:
			return enemy
		weight_offset += enemy.spawn_weight

	# The loop should always return an enemy
	return null
