extends KinematicBody2D

class_name BaseEntity

signal spawn_object(node)
signal enemy_died(name, coin_gain, score_gain)

var state: State

export var entity_name: String

var max_life: float
export var life: float = 100
export var damage: float = 35
export(Array, float) var resistances = []

export (int) var RANGE_PX = 30
export (int) var MOVE_SPEED_PX = 4000

var velocity = Vector2()
var direction: int = 1 # -1 for left ; 1 for right
var target: Node2D = null

export (PackedScene) var DyingScene = preload("res://Entities/DyingUnit.tscn")

export (bool) var has_gravity := true
export (bool) var can_shoot_up := false
export (bool) var spawn_in_air := false

export (bool) var is_enemy := false
export (int) var coin_gain := 0
export (int) var score_gain := 0

export var spawn_invincibility_time: float = 1.5 # Can't be damaged during this time
var invincibility_time: float = 0 # Can't be damaged during this time
var lifetime: float = 0
var is_dead: bool = false # to avoid calling die() multiple times

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_enemy:
		# warning-ignore:integer_division
		var multiplier = PlayerVariables.level / 10 
		_upgrade_stats(multiplier)
	
	max_life = life
	invincibility_time = spawn_invincibility_time

	var group_name = "enemies" if is_enemy else "allies"
	add_to_group(group_name)
	add_to_group("unit")
	
	set_direction(is_enemy)

func _process(delta: float) -> void:
	lifetime += delta
	if invincibility_time > 0:
		invincibility_time -= delta
	$ProgressBar.value = life / max_life * 100
	state._process(delta)
	

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	# Apply gravity	
	if has_gravity:
		velocity.y = 100
	
	reload_closest_target()
	state._fixed_process(delta)

	velocity = move_and_slide(velocity)


# Enemy units should get stronger every 10 levels
# to avoid having too much on screen
# Multiplier is 0 untill level 10, then 1, 2 at level 20, ...
func _upgrade_stats(multiplier: int) -> void:
	life += life * 0.8 * multiplier
	damage += damage * 0.2 * multiplier
	MOVE_SPEED_PX += int(float(MOVE_SPEED_PX) * 0.05 * multiplier)
	
	coin_gain += int(round(float(coin_gain) * 0.5 * float(multiplier)))
	score_gain += score_gain * multiplier


func reload_closest_target() -> void:
	target = closest_target()

func closest_target() -> Node2D:
	var group_name = "allies" if is_enemy else "enemies"
	var targets = get_tree().get_nodes_in_group(group_name)
	
	var nearest = null
	for t in targets:
		if t.is_in_group("air") and not can_shoot_up:
			continue
		if not nearest or t.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position):
			nearest = t
	
	if not nearest and is_enemy:
		nearest = get_tree().get_nodes_in_group("tower")[0]
	return nearest
	
func target_in_range() -> bool:
	return target and global_position.distance_to(target.global_position) < RANGE_PX


func attack_target() -> void:
	target.suffer_attack(damage)


func suffer_attack(base_damage: int) -> void:
	if invincibility_time > 0:
		return
	
	var animation = get_node_or_null("AnimationPlayer")
	if animation:
		animation.stop()
		animation.play("hurt")

	DebugService.silly("%s took %d dmgs" % [name, base_damage])
	life -= base_damage
	if life <= 0 and not is_dead:
		die()


func die() -> void:
	is_dead = true

	if DyingScene:
		var dying = DyingScene.instance()
		dying.global_position = global_position
		emit_signal("spawn_object", dying)
		if is_enemy:
			dying.coin_gain = coin_gain

	
	if is_enemy:
		var score = score_gain / (lifetime/10.0 + 1)
		emit_signal("enemy_died", entity_name, coin_gain, score)

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
