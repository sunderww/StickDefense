extends Node2D

signal enemy_died

# Declare member variables here.
var enemy_scene = load("res://Entities/Infantry/EnemyInfantry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.coin = PlayerVariables.base_coin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	PlayerVariables.coin += PlayerVariables.coin_per_second * delta


func spawn_enemy() -> void:
	var enemy: BaseEntity = enemy_scene.instance()
	enemy.is_enemy = true
	enemy.position = $Spawn/Enemy.position
	enemy.connect("enemy_died", self, "_on_Enemy_died")
	$Enemies.add_child(enemy)

func spawn_item(purchase: Purchase) -> void:
	var scene = load(purchase.resource)
	print("spawn %s" % purchase.title)

	var node = scene.instance()
	node.position = $Spawn/Ally.position
	node.max_pos_x = $Allies/MaxPos.global_position.x
	connect("enemy_died", node, "reload_closest_target")
	$Allies.add_child(node)


func _on_Enemy_died(coin_gain: int) -> void:
	PlayerVariables.coin += coin_gain
	emit_signal("enemy_died")

func _on_Tower_destroyed():
	get_tree().quit()
