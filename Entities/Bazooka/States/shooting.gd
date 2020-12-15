extends State

const IDLE_PATH = "res://Entities/Bazooka/States/idle.gd"
const AIMING_PATH = "res://Entities/Bazooka/States/aiming.gd"
const Missile = preload("res://Entities/Bazooka/Missile/BazookaMissile.tscn")

# Aim a bit after the target and on the ground
const MISSILE_OFFSET = Vector2(20, 32)

var current_target
var sprite: AnimatedSprite
var missile_spawned: bool = false

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
	if not parent.target or (parent.target != current_target and not parent.target_in_range()):
		var Idle = load(IDLE_PATH)
		set_state(Idle.new())
		return
	
	# Spawn a missile
	if not missile_spawned:
		var missile = Missile.instance()	
		if parent.is_enemy:
			missile.target_groups = ["allies", "tower"]
			missile.set_scale(Vector2(-1, 1))

		missile.rotate(deg2rad(-20))
		missile.target_position = parent.target.global_position + MISSILE_OFFSET
		missile.damage = parent.damage
		missile.global_position = parent.get_node("MuzzlePosition").global_position
		parent.shoot(missile)
		missile_spawned = true
		DebugService.debug("%s: Spawn missile" % parent.name)
	

func _on_parent_AnimatedSprite_animation_finished() -> void:
	var NextState = load(AIMING_PATH) if parent.target else load(IDLE_PATH)
	set_state(NextState.new())
