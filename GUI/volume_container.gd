extends VBoxContainer

onready var music_slider := $MusicSlider
onready var effects_slider := $EffectsSlider

func _ready():
	music_slider.value = AudioManager.music_volume * 100.0
	effects_slider.value = AudioManager.effects_volume * 100.0


func _on_MusicSlider_value_changed(value):
	AudioManager.music_volume = value/100.0


func _on_EffectsSlider_value_changed(value):
	AudioManager.effects_volume = value/100.0
