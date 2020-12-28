extends Area2D

signal spawn_object(explosion)

const Explosion = preload("res://Entities/Bazooka/Missile/Explosion.tscn")

export var max_speed: int = 600
export var acceleration: int = 280
export var steer_force: int = 280

# Aim a bit after the target on the ground
export (Vector2) var ground_offset = Vector2(20, 62)
export (Vector2) var air_offset = Vector2.ZERO

var target: Node2D
onready var target_position: Vector2 = target.global_position
var target_groups: Array = ["enemies"]
var velocity := Vector2.ZERO
var freed := false

# Must be set by the bazooka
var damage

func _init() -> void:
	name = "Missile"

func _ready() -> void:
	$Indicator.visible = DebugService.level == DebugService.LogLevel.SILLY
	velocity = Vector2(acceleration, 0).rotated(rotation).clamped(max_speed)

func _physics_process(delta: float) -> void:
	$Indicator.global_position = offset_target_pos()

	velocity += Vector2(acceleration, 0).rotated(rotation) * delta
	velocity += seek() * delta
	velocity = velocity.clamped(max_speed)
	rotation = velocity.angle()
	position += velocity * delta


func offset_target_pos() -> Vector2:
	if target:
		var offset = air_offset if target.spawn_in_air else ground_offset
		return target.global_position + offset
	else:
		return target_position

func seek():
	var desired = (offset_target_pos() - global_position).normalized() * acceleration
	return (desired - velocity).normalized() * steer_force


func explode() -> void:
	var explosion = Explosion.instance()
	explosion.global_position = global_position
	explosion.damage = damage
	emit_signal("spawn_object", explosion)

	prepare_free()


# Call this function when you want to free the missile.
# It will reparent the particle object so that they are still visible until
# their lifetime is over.
func prepare_free() -> void:
	if freed:
		return

	var particles = $Particles2D
	particles.global_position = global_position
	particles.emitting = false
	particles.should_be_removed = true

	call_deferred("remove_child", particles)
	get_tree().root.call_deferred("add_child", particles)
	
	# Calling queue_free now will cause particles to not exist anymore
	# before being added to the root scene
	call_deferred("queue_free")
	DebugService.silly("%s freed" % name)
	freed = true


func _on_Missile_body_entered(body: PhysicsBody2D) -> void:
	for target_group in target_groups + ["ground"]:
		if body.is_in_group(target_group):
			explode()


func _on_VisibilityNotifier2D_screen_exited():
	if not freed:
		prepare_free()
