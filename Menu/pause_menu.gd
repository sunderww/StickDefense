extends Node2D

signal exit_pause

const MenuScene = "res://Menu/GameMenu.tscn"
onready var tween = $Tween

func _ready():
	get_tree().paused = true


func _on_ContinueButton_pressed():
	AudioManager.play_effect("select")
	get_tree().paused = false
	emit_signal("exit_pause")


func _on_ContinueButton_mouse_entered():
	AudioManager.play_effect("hover")
	print("hover")


func _on_ExitButton_pressed():
	AudioManager.play_effect("select")
	get_tree().paused = false
	emit_signal("exit_pause")
	assert(get_tree().change_scene(MenuScene) == OK)
