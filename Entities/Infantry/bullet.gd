extends Area2D

class_name Bullet

export var speed: int = 750
var damage: int = 10
var target_group: String = "enemies"

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group(target_group):
		if body.has_method("suffer_attack"):
			body.suffer_attack(damage)
		else:
			DebugService.warning("Bullet encountered entity in group %s with no method suffer_attack: %s" % [target_group, body])
		queue_free()
