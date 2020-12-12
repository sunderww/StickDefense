extends State

const IDLE_PATH = "res://Entities/Infantry/States/idle.gd"
const AIMING_PATH = "res://Entities/Infantry/States/aiming.gd"
const Bullet = preload("res://Entities/Infantry/Bullet.tscn")

var current_target
var sprite: AnimatedSprite
var bullet_spawned: bool = false

func get_name() -> String:
	return "shooting"

func enter(parent) -> void:
	.enter(parent)
	current_target = parent.target
	sprite = parent.get_node("AnimatedSprite") as AnimatedSprite
	sprite.connect("animation_finished", self, "_on_parent_AnimatedSprite_animation_finished")
	
func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_parent_AnimatedSprite_animation_finished")

func _process(_delta: float) -> void:
	if not parent.target or (parent.target != current_target and not parent.target_in_rifle_range()):
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
		return
	
	# Spawn a bullet
	if not bullet_spawned:
		var bullet = Bullet.instance()
		if parent.is_enemy:
			bullet.target_groups = ["allies", "tower"]
			bullet.set_scale(Vector2(-1, 1))

		bullet.global_position = parent.get_node("MuzzlePosition").global_position
		parent.shoot(bullet)
		bullet_spawned = true
		DebugService.debug("%s: Spawn bullet" % parent.name)
	

func _on_parent_AnimatedSprite_animation_finished() -> void:
	DebugService.debug("%s: Shooting animation finished" % parent.name)
	
	var NextState = load(AIMING_PATH) if parent.bullets > 0 else load(IDLE_PATH)
	set_state(NextState.new())
