extends State

const IDLE_PATH = "res://Entities/Swordsman/States/idle.gd"

var current_target
var sprite: AnimatedSprite
var can_attack: bool = true

func get_name() -> String:
	return "attacking"

func enter(parent) -> void:
	.enter(parent)
	current_target = parent.target
	sprite = parent.get_node("AnimatedSprite") as AnimatedSprite
	sprite.connect("animation_finished", self, "_on_parent_AnimatedSprite_animation_finished")
	
func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_parent_AnimatedSprite_animation_finished")

func _process(_delta: float) -> void:
	if not parent.target or (parent.target != current_target and not parent.target_in_range()):
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
		return
		
	if can_attack:
		parent.attack_target()
		can_attack = false

func _on_parent_AnimatedSprite_animation_finished() -> void:
	can_attack = true
