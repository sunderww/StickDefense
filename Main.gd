extends Node2D

signal enemy_died

onready var camera := $ShakableCamera
onready var freezer := $FrameFreezer
onready var objects_node := $Objects
onready var allies_node := $Allies
onready var enemies_node := $Enemies

var enemy_scene = load("res://Entities/Infantry/EnemyInfantry.tscn")

func _ready() -> void:
	PlayerVariables.coin = PlayerVariables.base_coin


func _process(delta: float) -> void:
	PlayerVariables.coin += PlayerVariables.coin_per_second * delta


func spawn_enemy() -> void:
	var enemy: BaseEntity = enemy_scene.instance()
	enemy.is_enemy = true
	enemy.position = $Spawn/Enemy.position
	enemy.connect("enemy_died", self, "_on_Enemy_died")
	spawn_object(enemy, enemies_node)

func spawn_item(purchase: Purchase) -> void:
	var scene = load(purchase.resource)
	DebugService.info("spawn %s" % purchase.title)

	var node: Node2D = scene.instance()
	if purchase.spawn_type == Purchase.SpawnType.GROUND:
		node.position = $Spawn/AllyGround.position
	elif purchase.spawn_type == Purchase.SpawnType.AIR:
		node.position = $Spawn/AllyAir.position
	else:
		DebugService.warning("Spawn item with mouse not implemented yet")
#	node.max_pos_x = $Allies/MaxPos.global_position.x	
	spawn_object(node, allies_node)


func _on_Enemy_died(coin_gain: int) -> void:
	PlayerVariables.coin += coin_gain
	DebugService.debug("Gained %d coins" % coin_gain)
	emit_signal("enemy_died")

func _on_Tower_destroyed() -> void:
	return
	# Should show game over
	DebugService.info("Game Over")
	get_tree().quit()

func spawn_object(node: Node2D, parent_node=objects_node) -> void:
	if node.has_signal("spawn_object"):
		node.connect("spawn_object", self, "spawn_object")
	if node.has_signal("request_shake"):
		node.connect("request_shake", camera, "_on_shake_requested")
	if node.has_signal("request_freeze"):
		node.connect("request_freeze", freezer, "_on_freeze_requested")
	parent_node.call_deferred("add_child", node)
