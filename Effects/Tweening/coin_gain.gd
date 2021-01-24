extends Node2D

onready var tween = $Tween

export var lifetime: float = 2.0
export var randomness_x: int = 40.0
export var velocity_y: int = -150
export var initial_scale: Vector2 = Vector2(0.7, 0.7)
export var max_scale: Vector2 = Vector2.ONE
export var min_scale: Vector2 = Vector2(0.1, 0.1)

var velocity = Vector2.ZERO
var coins: int

func _ready() -> void:
	var side_movement = randi() % randomness_x - randomness_x / 2
	velocity = Vector2(side_movement, velocity_y)
	scale = initial_scale
	$Label.text = str(coins)
	
	tween.interpolate_property(
		self, 
		"scale", 
		scale, 
		max_scale,
		lifetime * 0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		self, 
		"scale", 
		max_scale,
		min_scale,
		lifetime * 0.75,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tween.start()


func _process(delta: float) -> void:
	position += velocity * delta


func _on_Tween_tween_completed(_object, _key):
	queue_free()
