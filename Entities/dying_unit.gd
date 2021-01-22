extends Node2D


func _ready() -> void:
	# Find the max wait time between particles/animation/sound effect and free after this time
	var timer = $Timer
	var particles_left = $Left
	var particles_right = $Right
	
	timer.wait_time = max(particles_left.lifetime, particles_right.lifetime)
	timer.start()

	particles_left.emitting = true
	particles_right.emitting = true
	AudioManager.play_effect("unit_dying")
	

func _on_Timer_timeout():
	queue_free()
