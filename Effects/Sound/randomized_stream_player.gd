extends AudioStreamPlayer

# A Stream Player capable of playing a sound picked in an array
# and randomizing different properties
class_name RandomizedStreamPlayer

export (Array, AudioStream) var sound_list
export var min_pitch: float = 0.9
export var max_pitch: float = 1.1
export var sound_must_finish: bool = false
var sound_index := 0


func _ready() -> void:
	randomize()

func _random_index() -> int:
	return int(rand_range(0, sound_list.size() - 1))

func play_random() -> void:
	stop()

	var index = _random_index()
	pitch_scale = rand_range(min_pitch, max_pitch)

	stream = sound_list[index]
	play()
