extends Node2D


const GameOverScene = "res://Menu/GameOver.tscn"

onready var camera := $ShakableCamera
onready var freezer := $FrameFreezer
onready var objects_node := $Objects
onready var allies_node := $Allies
onready var enemies_node := $Enemies
onready var tween := $Tween

var enemy_count: int

func _ready() -> void:
	PlayerVariables.reset()
	yield(animate_start(), "completed")
	start_next_wave()

func _process(delta: float) -> void:
	PlayerVariables.coin += PlayerVariables.coin_per_second * delta


func _interpolate_start_position(node: Node2D, duration: float, delay: float) -> void:
	var offset := Vector2(0, -850)
	tween.interpolate_property(
		node,
		"position",
		node.position + offset,
		node.position,
		duration,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT,
		delay
	)
	node.position += offset

func animate_start() -> void:
	_interpolate_start_position($LevelElements/Ground, 0.7, 0)
	_interpolate_start_position($LevelElements/Background/Layer5, 1.1, 0.2)
	_interpolate_start_position($LevelElements/Background/Layer4, 1.1, 0.4)
	_interpolate_start_position($LevelElements/Background/Layer3, 1.1, 0.6)
	_interpolate_start_position($LevelElements/Tower, 1.2, 0.7)
	_interpolate_start_position($PanelContainer, 1.5, 1)

	tween.start()
	yield(tween, "tween_all_completed")


func start_next_wave() -> void:
	PlayerVariables.level_cleared()
	enemy_count = 0
	$WaveIndicator.level = PlayerVariables.level


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
	get_tree().change_scene(GameOverScene)


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


func _on_WaveIndicator_animation_finished():
	$WaveManager.start(PlayerVariables.level)
