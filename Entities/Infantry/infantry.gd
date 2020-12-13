extends BaseEntity

class_name Infantry

signal spawn_object(node)

const Dying = preload("res://Entities/Infantry/DyingInfantry.tscn")
const Idle = preload("res://Entities/Infantry/States/idle.gd")
const Attacking = preload("res://Entities/Infantry/States/attacking.gd")

onready var shell_particles = $Particles2D
onready var shell_particles2 = $Particles2D2

export var bullet_damage: int = 10
export var bullets: int = 6
export var SHOOT_RANGE_PX: int = 450

func _ready() -> void:
	self.name = "Infantry"

	# Make the SHOOT_RANGE_PX vary by +-10% so that not all units shoot from the same position
	var modifier: float = 1.0 - (float(randi() % 20 - 10) / 100.0)
	DebugService.silly("%s shoot range from %d to %d" % [name, SHOOT_RANGE_PX, SHOOT_RANGE_PX*modifier])
	SHOOT_RANGE_PX = int(round(SHOOT_RANGE_PX * modifier))

	state = Idle.new()
	state.enter(self)

	$StateName.visible = DebugService.level == DebugService.LogLevel.SILLY


func _process(delta: float) -> void:
	._process(delta)
	$StateName.text = state.get_name()


func _physics_process(delta: float) -> void:
	._physics_process(delta)
	
	if target and target.global_position.distance_to(global_position) <= RANGE_PX:
		var attacking = Attacking.new()
		if state.get_name() != attacking.get_name():
			state.set_state(attacking)


func suffer_attack(damage: int) -> void:
	.suffer_attack(damage)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")

func attack_target() -> void:
	target.suffer_attack(damage)

func die() -> void:
	.die()
	
	var dying = Dying.instance()
	dying.global_position = global_position
	emit_signal("spawn_object", dying)

func target_in_rifle_range() -> bool:
	return target and global_position.distance_to(target.global_position) < SHOOT_RANGE_PX

func can_shoot_target() -> bool:
	return bullets > 0 and target_in_rifle_range()

func set_direction(left: bool) -> void:
	.set_direction(left)
	$MuzzlePosition.position.x = abs($MuzzlePosition.position.x) * (-1 if left else 1)

func shoot(bullet: Bullet) -> void:
	bullets -= 1
	bullet.damage = bullet_damage

	$RandomizedStreamPlayer.play_random()

	# Alternate between 2 particles in case one is not finished
	if shell_particles.emitting:
		shell_particles2.emitting = true
	else:
		shell_particles.emitting = true

	emit_signal("spawn_object", bullet)
