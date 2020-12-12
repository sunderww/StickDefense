extends Area2D

signal spawn_object(explosion)

const Explosion = preload("res://Entities/Chopper/Explosion.tscn")

export var max_speed: int = 500
export var acceleration: int = 350

var velocity = Vector2.ZERO
var freed = false

# Must be set by the chopper
var damage

func _init() -> void:
	name = "Missile"
	
func _ready() -> void:
	# The following code does not work but we should find a way to avoid memory leaks
#	if not $VisibilityNotifier2D.is_on_screen():
#		prepare_free()
	pass

func _physics_process(delta: float) -> void:
	velocity += Vector2(acceleration, 1).rotated(rotation) * delta
	velocity = velocity.clamped(max_speed)
	position += velocity * delta

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
	var particles = $Particles2D
	call_deferred("remove_child", particles)
	get_tree().root.call_deferred("add_child", particles)
	particles.global_position = global_position
	particles.emitting = false
	particles.should_be_removed = true

	DebugService.debug("%s freed" % name)
	freed = true
	queue_free()
	

func _on_Missile_body_entered(body: PhysicsBody2D) -> void:
	if not (body.is_in_group("allies") and body.is_in_group("air")):
		explode()


func _on_VisibilityNotifier2D_screen_exited():
	if not freed:
		prepare_free()
