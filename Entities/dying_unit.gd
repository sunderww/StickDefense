extends Node2D

const CoinGainScene := preload("res://Effects/Tweening/CoinGain.tscn")

var coin_gain = 0

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

	if coin_gain > 0:
		var coin_gain_node = CoinGainScene.instance()
		coin_gain_node.coins = coin_gain
		coin_gain_node.position = $CoinGainPos.position
		add_child(coin_gain_node)
	

func _on_Timer_timeout():
	queue_free()
