extends Node2D


func _ready() -> void:
	# Find the max wait time between particles/animation/sound effect and free after this time
	var timer = $Timer
	var particles_left = $Left
	var particles_right = $Right
	var stream_player = $AudioStreamPlayer
	
	var wait_time = max(particles_left.lifetime, particles_right.lifetime)
	wait_time = max(stream_player.stream.get_length(), wait_time)
	timer.wait_time = wait_time
	timer.start()

	particles_left.emitting = true
	particles_right.emitting = true
	stream_player.play()
	

func _on_Timer_timeout():
	queue_free()
