extends BaseEntity


const Idle = preload("res://Entities/Claymore/States/idle.gd")
const Explosion = preload("res://Entities/Claymore/ClaymoreExplosion.tscn")


func _ready() -> void:
	self.name = "Claymore"
	
	state = Idle.new()
	state.enter(self)

	$StateName.visible = DebugService.level == DebugService.LogLevel.SILLY


func _process(delta: float) -> void:
	._process(delta)
	$StateName.text = state.get_name()


func die() -> void:
	.die()
	
	var explosion = Explosion.instance()
	explosion.global_position = global_position
	explosion.damage = damage
	emit_signal("spawn_object", explosion)
	
