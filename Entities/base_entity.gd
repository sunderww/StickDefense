extends KinematicBody2D

class_name BaseEntity


var state: State

export var life: float = 100
export var damage: float = 35
export(Array, float) var resistances = []

export (int) var RANGE_PX = 30
export (int) var MOVE_SPEED_PX = 4000

var velocity = Vector2()
var direction: int = 1 # -1 for left ; 1 for right
var target: Node2D = null

export (bool) var is_enemy = false
var is_dead: bool = false # to avoid calling die() multiple times

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var group_name = "enemies" if is_enemy else "allies"
	add_to_group(group_name)

func _process(delta: float) -> void:
	$ProgressBar.value = life
	state._process(delta)
	

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	velocity.y = 100 # Apply gravity
	
	reload_closest_target()
	state._fixed_process(delta)


#func next_ally() -> Node2D:
#	var group_name = "enemies" if is_enemy else "allies"
#	var allies = get_tree().get_nodes_in_group(group_name)
#
#	var nearest = null
#	for ally in allies:
#		var is_next = ally.global_position.x < global_position if is_enemy else ally.global_position.x > global_position
#		if not nearest or (is_next and \
#		 ally.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position)):
#			nearest = ally
#
#	return nearest

func reload_closest_target() -> void:
	target = closest_target()

func closest_target() -> Node2D:
	var group_name = "allies" if is_enemy else "enemies"
	var targets = get_tree().get_nodes_in_group(group_name)

	if len(targets) == 0:
		return null

	var nearest = targets[0]
	for t in targets:
		if t.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position):
			nearest = t
	
	return nearest
	
func target_in_range() -> bool:
	return target and global_position.distance_to(target.global_position) < RANGE_PX

# Must be overridden
func attack_target() -> void:
	assert(false)


func suffer_attack(base_damage: float) -> void:
	DebugService.silly("%s took %f dmgs" % [name, base_damage])
	life -= base_damage
	if life <= 0 and not is_dead:
		die()

func die() -> void:
	is_dead = true
	queue_free()


func set_direction(left: bool) -> void:
	($AnimatedSprite as AnimatedSprite).flip_h = left
	direction = -1 if left else 1

func set_direction_towards_target() -> void:
	if not target:
		set_direction(is_enemy) # Default to left if enemy else right
		direction = 0
		return
	
	set_direction(target.global_position.x < global_position.x)
