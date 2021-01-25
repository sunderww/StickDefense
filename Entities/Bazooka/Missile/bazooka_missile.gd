extends Path2D

signal spawn_object(explosion)

const Explosion = preload("res://Entities/Bazooka/Missile/Explosion.tscn")

onready var path_follow = $PathFollow2D
onready var missile = $PathFollow2D/Missile

export var speed: int = 200
export var randomness: Vector2 = Vector2(50, 20)
export var ground_offset_y: int = 20

var target: Node2D
onready var target_position: Vector2 = target.global_position
var target_groups: Array = ["enemies"]
var freed := false

# Must be set by the bazooka
var damage

# Only used for debug purposes
var origin: Vector2
var control: Vector2
var dest: Vector2
var after_dest: Vector2

func _init() -> void:
	name = "Missile"

func _ready() -> void:
	origin = Vector2.ZERO
	dest = _get_dest()
	var direction := Vector2(speed, 0).rotated(deg2rad(-20)).normalized()
	control = direction * origin.distance_to(dest) / 2.0
	$Crosshair.position = dest
	
	curve = Curve2D.new()
	curve.add_point(origin, Vector2.ZERO, control)
	curve.add_point(dest)
	
	# In case the missile doesn't hit, we still want it to continue
	# so we calculate the tangeant at the last point and continue on
	# that line
	var penultimate: Vector2 = curve.interpolate(0, 0.99)
	direction = dest - penultimate
	after_dest = direction.normalized() * 1000
	curve.add_point(dest + after_dest)


# The target is moving, so we want to calculate how much time the
# missile will take to reach the destination and where the target
# will be at that time.
# We don't want this feature for ground units (because enemies are
# almost always stopped by our own units - which we don't wanna kill
func _get_dest(steps: int = 3) -> Vector2:
	#warning-ignore:integer_division
	var x = randi() % int(randomness.x) - randomness.x / 2
	var y = randi() % int(randomness.y) - randomness.y / 2
	var offset = Vector2(x, y)
	if not target.spawn_in_air:
		offset.y += ground_offset_y
		return target_position + offset - global_position
	
	var future_target_pos = target_position
	for _i in range(steps):
		var dist = global_position.distance_to(future_target_pos)
		var time = dist / speed
		future_target_pos = target_position + target.velocity * time
	
	return future_target_pos + offset - global_position


func _physics_process(delta: float) -> void:
	path_follow.offset += speed * delta


func explode() -> void:
	var explosion = Explosion.instance()
	explosion.global_position = missile.global_position
	explosion.damage = damage
	emit_signal("spawn_object", explosion)

	prepare_free()


# Call this function when you want to free the missile.
# It will reparent the particle object so that they are still visible until
# their lifetime is over.
func prepare_free() -> void:
	if freed:
		return

	var particles = $PathFollow2D/Missile/Particles2D
	particles.global_position = global_position
	particles.emitting = false
	particles.should_be_removed = true

	missile.call_deferred("remove_child", particles)
	get_tree().root.call_deferred("add_child", particles)
	
	# Calling queue_free now will cause particles to not exist anymore
	# before being added to the root scene
	call_deferred("queue_free")
	DebugService.silly("%s freed" % name)
	freed = true


func _draw() -> void:
	if DebugService.level == DebugService.LogLevel.SILLY:
		draw_polyline(curve.get_baked_points(), Color.blue, 2.0)
		draw_circle(origin, 5.0, Color.red)
		draw_circle(control, 5.0, Color.violet)
		draw_circle(dest, 5.0, Color.red)
		draw_circle(after_dest, 5.0, Color.pink)


func _on_Missile_body_entered(body: PhysicsBody2D) -> void:
	for target_group in target_groups + ["ground"]:
		if body.is_in_group(target_group):
			explode()


func _on_VisibilityNotifier2D_screen_exited():
	if not freed:
		DebugService.debug("%s disappeared from screen." % name)
		prepare_free()
