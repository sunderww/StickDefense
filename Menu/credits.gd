extends Node2D


const MenuScene = "res://Menu/GameMenu.tscn"


onready var tween = $Tween

var disable_buttons: bool = false


func _ready():
	_animate_scene_start()


func _animate_scene_start() -> void:
	var controls = $Controls
	tween.interpolate_property(
		controls,
		"position",
		controls.position - Vector2(0, 650),
		controls.position,
		0.7,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT,
		0
	)
	controls.position -= Vector2(0, 650)
	tween.start()


func _animate_scene_end(new_scene_path: String) -> void:
	tween.stop_all()

	var controls = $Controls
	tween.interpolate_property(
		controls,
		"position",
		controls.position,
		controls.position + Vector2(0, 650),
		0.6,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT,
		0.1
	)
	
	tween.start()
	yield(tween, "tween_all_completed")
	
	assert(get_tree().change_scene(new_scene_path) == OK)


func button_pressed() -> void:
	if disable_buttons:
		return

	AudioManager.play_effect("select")
	disable_buttons = true


func _on_BackButton_pressed():
	button_pressed()
	_animate_scene_end(MenuScene)


func _on_Button_mouse_entered():
	AudioManager.play_effect("hover")
