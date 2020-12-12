extends BaseEntity

class_name Infantry

signal spawn_object(node)

const Idle = preload("res://Entities/Infantry/States/idle.gd")

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

func suffer_attack(damage: int) -> void:
	.suffer_attack(damage)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hurt")

func attack_target() -> void:
	target.suffer_attack(damage)

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
	emit_signal("spawn_object", bullet)
