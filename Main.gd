extends Node2D

onready var camera := $ShakableCamera
onready var freezer := $FrameFreezer
onready var objects_node := $Objects
onready var allies_node := $Allies
onready var enemies_node := $Enemies

var enemy_count: int

func _ready() -> void:
	PlayerVariables.coin = PlayerVariables.base_coin
	start_next_wave()

func _process(delta: float) -> void:
	PlayerVariables.coin += PlayerVariables.coin_per_second * delta


func start_next_wave() -> void:
	PlayerVariables.level_cleared()
	enemy_count = 0
	
	# Put something on screen
	$WaveManager.start(PlayerVariables.level)


func spawn_object(node: Node2D, parent_node=objects_node) -> void:
	if node.has_signal("spawn_object"):
		node.connect("spawn_object", self, "spawn_object")
	if node.has_signal("request_shake"):
		node.connect("request_shake", camera, "_on_shake_requested")
	if node.has_signal("request_freeze"):
		node.connect("request_freeze", freezer, "_on_freeze_requested")
	parent_node.call_deferred("add_child", node)


func _on_Enemy_tree_exited() -> void:
	enemy_count -= 1
	if enemy_count == 0 and $WaveManager.is_over():
		start_next_wave()


func _on_Enemy_died(coin_gain: int, score_gain: int) -> void:
	DebugService.debug("gained %d coin and %d score" % [coin_gain, score_gain])
	PlayerVariables.coin += coin_gain
	PlayerVariables.score += score_gain


func _on_Tower_destroyed() -> void:
	# Should show game over
	DebugService.info("Game Over")
	get_tree().quit()


func _on_WaveManager_spawn_enemy(enemy: BaseEntity) -> void:
	enemy_count += 1
	enemy.is_enemy = true
	if enemy.spawn_in_air:
		enemy.position = $Spawn/EnemyAir.position
	else:
		enemy.position = $Spawn/EnemyGround.position
	enemy.connect("enemy_died", self, "_on_Enemy_died")
	enemy.connect("tree_exited", self, "_on_Enemy_tree_exited")
	spawn_object(enemy, enemies_node)


func _on_Panel_item_purchased(purchase):
	var scene = load(purchase.resource)
	PlayerVariables.coin -= purchase.price

	DebugService.info("spawn %s" % purchase.title)
	var node: Node2D = scene.instance()
	if node.spawn_in_air:
		node.position = $Spawn/AllyAir.position
	else:
		node.position = $Spawn/AllyGround.position
#	node.max_pos_x = $Allies/MaxPos.global_position.x	
	spawn_object(node, allies_node)
