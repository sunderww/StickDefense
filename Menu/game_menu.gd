extends BaseScene

const MainScene = "res://Main.tscn"
const ScoreScene = "res://Menu/HighScores.tscn"
const CreditsScene = "res://Menu/Credits.tscn"
const SettingsScene = "res://Menu/Settings.tscn"

func _on_PlayButton_pressed():
	if button_pressed():
		_animate_scene_end(MainScene)


func _on_ScoreButton_pressed():
	if button_pressed():
		_animate_scene_end(ScoreScene)


func _on_OptionsButton_pressed():
	if button_pressed():
		_animate_scene_end(SettingsScene)


func _on_CreditsButton_pressed():
	if button_pressed():
		_animate_scene_end(CreditsScene)


func _on_ExitButton_pressed():
	if button_pressed():
		yield(AudioManager, "effect_finished")
		get_tree().quit()

