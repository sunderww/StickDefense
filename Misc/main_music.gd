extends AudioStreamPlayer

export (AudioStream) var intro_stream
export (AudioStream) var loop_stream

var playing_intro: bool = true

func _ready():
	stream = intro_stream
	play()


func _on_finished():
	stream = loop_stream
	play()
