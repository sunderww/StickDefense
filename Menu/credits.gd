extends Node2D


const MenuScene = "res://Menu/GameMenu.tscn"


onready var tween = $Tween

var disable_buttons: bool = false


func _ready():
	pass


func _animate_scene_end(new_scene_path: String) -> void:
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
	
	get_tree().change_scene(new_scene_path)


func button_pressed() -> void:
	if disable_buttons:
		return

	$SelectSound.play()
	disable_buttons = true


func _on_BackButton_pressed():
	button_pressed()
	_animate_scene_end(MenuScene)


func _on_Button_mouse_entered():
	$HoverSound.play()
