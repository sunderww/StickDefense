extends BaseEntity

signal spawn_object(node)


const Forward = preload("res://Entities/Chopper/States/forward.gd")
const Missile = preload("res://Entities/Chopper/Missile/ChopperMissile.tscn")

var angle: float = 0 # angle in degrees

func _ready() -> void:
	self.name = "Chopper"

	# Make the SHOOT_RANGE_PX vary by +-10% so that not all units shoot from the same position
	var modifier: float = 1.0 - (float(randi() % 20 - 10) / 100.0)
	DebugService.silly("%s range from %d to %d" % [name, RANGE_PX, RANGE_PX*modifier])
	RANGE_PX = int(round(RANGE_PX * modifier))

	state = Forward.new()
	state.enter(self)

func shoot_missile() -> void:
	var missile = Missile.instance()
	
	missile.global_position = $MissilePosition.global_position
	missile.rotation = deg2rad(angle + rand_range(-5, 5))
	missile.damage = damage
	emit_signal("spawn_object", missile)

func _on_ShootTimer_timeout() -> void:
	shoot_missile()


func _on_VisibilityNotifier2D_screen_exited():
	DebugService.debug("%s exited screen - will be destroyed" % name)
	queue_free()
