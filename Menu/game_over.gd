extends Node2D


const MainScene = "res://Main.tscn"
const MenuScene = "res://Menu/GameMenu.tscn"


onready var label := $Controls/CenterContainer/VBoxContainer/ScoreLabel
onready var tween := $Tween

var disable_buttons: bool = false

func _ready():
	label.text = "%s %d" % [label.text, PlayerVariables.score]
	DebugService.info(PlayerVariables.killed)
	DebugService.info(PlayerVariables.spawned)


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
		get_tree().change_scene(new_scene_path)
	else:
		get_tree().quit()


func button_pressed() -> void:
	if disable_buttons:
		return

	AudioManager.play_effect("select")
	disable_buttons = true

func _on_RetryButton_pressed():
	button_pressed()
	_animate_scene_end(MainScene)


func _on_ExitButton_pressed():
	button_pressed()
	_animate_scene_end(MenuScene)



func _on_Button_mouse_entered():
	AudioManager.play_effect("hover")
