extends Node2D

const MainScene = "res://Main.tscn"
const CreditsScene = "res://Menu/Credits.tscn"
const SettingsScene = "res://Menu/Settings.tscn"

onready var selection = $Selection
onready var tween = $Tween

var buttons: Array
var disable_buttons: bool = false

func _ready():
	buttons = [
		$Controls/CenterContainer/VBoxContainer/PlayButton,
		$Controls/CenterContainer/VBoxContainer/OptionsButton,
		$Controls/CenterContainer/VBoxContainer/CreditsButton,
		$Controls/CenterContainer/VBoxContainer/ExitButton,
	]
	animate_scene_start()


func _on_Button_mouse_entered(index: int) -> void:
	var button: Button = buttons[index]
	var pos_y = button.rect_global_position.y + button.rect_size.y / 2
	selection.global_position.y = pos_y
	selection.visible = true
	$HoverSound.play()


func _on_Button_mouse_exited(_index: int) -> void:
	selection.visible = false


func button_selected() -> void:
	if disable_buttons:
		return

	disable_buttons = true
	$SelectSound.play()
	$Selection.visible = false


func animate_scene_start() -> void:
	var controls = $Controls
	tween.interpolate_property(
		controls,
		"position",
		controls.position - Vector2(0, 650),
		controls.position,
		1,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_IN_OUT,
		0
	)
	controls.position -= Vector2(0, 650)
	tween.start()

func animate_scene_end(new_scene_path: String) -> void:
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
	
	

func play() -> void:
	button_selected()
	animate_scene_end(MainScene)
	
func show_options() -> void:
	button_selected()
	animate_scene_end(SettingsScene)

func show_credits() -> void:
	button_selected()
	animate_scene_end(CreditsScene)

func exit():
	button_selected()
	yield($SelectSound, "finished")
	get_tree().quit()
