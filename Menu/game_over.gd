extends Node2D


const MainScene = "res://Main.tscn"
const MenuScene = "res://Menu/GameMenu.tscn"
const ScoreScene = "res://Menu/HighScores.tscn"


onready var score_label := $Controls/CenterContainer/VBoxContainer/ScoreLabel
onready var killed_label := $Controls/CenterContainer/VBoxContainer/KilledLabel
onready var lost_label := $Controls/CenterContainer/VBoxContainer/LostLabel
onready var tween := $Tween

var score_info: Dictionary
var disable_buttons: bool = false

func _ready() -> void:
	AudioManager.play_menu()
	
	score_info = {
		"datetime": OS.get_datetime(),
		"score": PlayerVariables.score,
		"killed": PlayerVariables.killed,
		"spawned": PlayerVariables.spawned,
		"level": PlayerVariables.level,
	}

	_save_score()
	_set_labels()


func _save_score() -> void:
	var scores = ScoreService.load_scores()
	scores.append(score_info)
	scores.sort_custom(ScoreService, "sort_scores")
	
	if len(scores) > ScoreService.MAX_SCORES:
		DebugService.info("Removing last score")
		scores.pop_back()
	else:
		DebugService.info("There is %d < %d scores" % [len(scores), ScoreService.MAX_SCORES])
	
	ScoreService.save_scores(scores)


func _set_labels() -> void:
	score_label.text = "%s %d" % [score_label.text, PlayerVariables.score]
	
	var comma := ""
	var text := "Killed: "
	for unit_name in PlayerVariables.killed.keys():
		var number = PlayerVariables.killed[unit_name]
		text += "%s%d %s" % [comma, number, unit_name]
		comma = ", "
	killed_label.text = text
	
	comma = ""
	text = "Lost: "
	for unit_name in PlayerVariables.spawned.keys():
		var number = PlayerVariables.spawned[unit_name]
		text += "%s%d %s" % [comma, number, unit_name]
		comma = ", "
	lost_label.text = text


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

