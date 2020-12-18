extends BaseEntity

const Idle = preload("res://Entities/Bazooka/States/idle.gd")

export var MIN_RANGE_PX: int = 300
export var MAX_RANGE_IN_AIR: int = 800


# return variable +- max_percentage%
func _random_variation(variable, max_percentage: float) -> float:
	var percentage := rand_range(-max_percentage, max_percentage)
	var modifier := 1.0 - (percentage / 100.0)
	return variable * modifier

func _ready():
	self.name = "Bazooka"
	
	RANGE_PX = _random_variation(RANGE_PX, 10)
	MIN_RANGE_PX = int(_random_variation(MIN_RANGE_PX, 10))

	state = Idle.new()
	state.enter(self)

	$StateName.visible = DebugService.level == DebugService.LogLevel.SILLY


func _process(delta: float) -> void:
	._process(delta)
	$StateName.text = state.get_name()


func shoot(missile: Node2D) -> void:
	emit_signal("spawn_object", missile)


func closest_target_in_air() -> Node2D:
	var group_name = "allies" if is_enemy else "enemies"
	var targets = get_tree().get_nodes_in_group(group_name)

	var nearest = null
	for t in targets:
		if not t.is_in_group("air"):
			continue
		var distance = t.global_position.distance_to(global_position)
		if t.global_position.x > global_position.x and (not nearest or distance < nearest.global_position.distance_to(global_position)):
			nearest = t
	
	return nearest


func closest_target() -> Node2D:
	var group_name = "allies" if is_enemy else "enemies"
	var targets = get_tree().get_nodes_in_group(group_name)
	var nearest = null
	
	if can_shoot_up:
		nearest = closest_target_in_air()
		if nearest:
			return nearest

	for t in targets:
		if t.is_in_group("air"):
			continue
		var distance = t.global_position.distance_to(global_position)
		if distance > MIN_RANGE_PX and (not nearest or t.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position)):
			nearest = t
	
	if not nearest and is_enemy:
		nearest = get_tree().get_nodes_in_group("tower")[0]
	return nearest


func target_in_range() -> bool:
	if not target:
		return false
	
	var max_dist = MAX_RANGE_IN_AIR if target.spawn_in_air else RANGE_PX
	return global_position.distance_to(target.global_position) < max_dist
