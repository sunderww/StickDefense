extends Node2D

signal exit_pause

func _ready():
	get_tree().paused = true


func _on_ContinueButton_pressed():
	AudioManager.play_effect("select")
	get_tree().paused = false
	emit_signal("exit_pause")


func _on_ContinueButton_focus_entered():
	AudioManager.play_effect("hover")
