extends Area2D


signal destroyed

var max_life
var life = 1000


# Called when the node enters the scene tree for the first time.
func _ready():
	max_life = life


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var life_percentage = float(life) / float(max_life) * 100.0
	$ProgressBar.value = life_percentage
	
func suffer_attack(base_damage: float) -> void:
	life -= base_damage
	if life <= 0:
		emit_signal("destroyed")
