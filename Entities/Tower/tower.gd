extends StaticBody2D


signal destroyed

export var life: int = 2000
onready var max_life = life

var destroyed: bool = false

onready var animation := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	max_life = life


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var life_percentage = float(life) / float(max_life) * 100.0
	$ProgressBar.value = life_percentage


func suffer_attack(base_damage: int) -> void:
	if destroyed:
		return
	
	DebugService.silly("Tower suffered %d damage" % base_damage)
	life -= base_damage
	animation.stop()
	
	if life <= 0:
		destroyed = true
		animation.play("destroy")
		emit_signal("destroyed")
	else:
		animation.play("hurt")

