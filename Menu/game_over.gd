extends Node2D


const MainScene = "res://Main.tscn"
const MenuScene = "res://Menu/GameMenu.tscn"
const ScoreScene = "res://Menu/HighScores.tscn"


onready var label := $Controls/CenterContainer/VBoxContainer/ScoreLabel
onready var tween := $Tween

var score_info: Dictionary
var disable_buttons: bool = false

func _ready() -> void:
	score_info = {
		"datetime": OS.get_datetime(),
		"score": PlayerVariables.score,
		"killed": PlayerVariables.killed,
		"spawned": PlayerVariables.spawned,
		"level": PlayerVariables.level,
	}

	save_score()
	label.text = "%s %d" % [label.text, PlayerVariables.score]
	DebugService.info(PlayerVariables.killed)
	DebugService.info(PlayerVariables.spawned)


func save_score() -> void:
	var scores = ScoreService.load_scores()
	scores.append(score_info)
	scores.sort_custom(ScoreService, "sort_scores")
	
	if len(scores) > ScoreService.MAX_SCORES:
		DebugService.info("Removing last score")
		scores.pop_back()
	else:
		DebugService.info("There %d < %d scores" % [len(scores), ScoreService.MAX_SCORES])
	
	ScoreService.save_scores(scores)


func _animate_scene_end(new_scene_path) -> void:
	tween.stop_all()

	var controls = $Controls
	tween.interpolate_property(
		controls,
		"position",
		controls.position,
		controls.position + Vector2(0, 650),
		0.8,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT,
		0.1
	)
	
	tween.start()
	yield(tween, "tween_all_completed")
	
	if new_scene_path:
		assert(get_tree().change_scene(new_scene_path) == OK)
	else:
		get_tree().quit()


func button_pressed() -> void:
	if disable_buttons:
		return

	AudioManager.play_effect("select")
	disable_buttons = true


func _on_ScoreButton_pressed():
	button_pressed()
	_animate_scene_end(ScoreScene)


func _on_RetryButton_pressed():
	button_pressed()
	_animate_scene_end(MainScene)


func _on_ExitButton_pressed():
	button_pressed()
	_animate_scene_end(MenuScene)


func _on_Button_mouse_entered():
	AudioManager.play_effect("hover")

