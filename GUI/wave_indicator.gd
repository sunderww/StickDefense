extends Node2D

class_name WaveIndicator


signal animation_finished


export var level: int = 0 setget set_level

onready var label := $Label
onready var animation_player := $AnimationPlayer

func _ready():
	pass


func set_level(value: int) -> void:
	level = value
	label.text = "Wave %d" % level
	label.visible = true
	
	$Label2.visible = level % 10 == 0
	
	animation_player.play("ScaleUp")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ScaleUp":
		animation_player.play("ScaleDown")
	elif anim_name == "ScaleDown":
		label.visible = false
		emit_signal("animation_finished")
		
