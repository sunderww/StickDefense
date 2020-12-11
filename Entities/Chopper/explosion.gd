extends Area2D


# Must be set by the object creating the explosion
var damage

# get_overlapping_bodies return empty array in _ready, so do it in _process
var damage_happened

func _ready() -> void:
	$AnimatedSprite.playing = true


func _process(_delta: float) -> void:
	if not damage_happened:
		# For some reason bodies is empty the first few frames.
		# It should at least contain the ground
		var bodies = get_overlapping_bodies()
		if len(bodies):
			for body in get_overlapping_bodies():
				explode_on_body(body)
			damage_happened = true


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()


func explode_on_body(body: PhysicsBody2D) -> void:
	if body.has_method("suffer_attack"):
		# Lower damage when the body is far away
		var distance = global_position.distance_to(body.global_position)
		var radius = $CollisionShape2D.shape.radius
		var actual_damage = min(damage * (radius * 1.5 - distance) / radius, damage)
		
		DebugService.debug("%s is at distance %f/%f. Damage is %d" % [body.name, distance, radius, actual_damage])	
		body.suffer_attack(actual_damage)
