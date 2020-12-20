extends BaseEntity

const Idle = preload("res://Entities/Swordsman/States/idle.gd")


func _ready() -> void:
	self.name = "Swordsman"
	
	$ScaleEffect.enabled = !is_enemy

	# Make the SHOOT_RANGE_PX vary by +-10% so that not all units shoot from the same position
	var modifier: float = 1.0 - (float(randi() % 20 - 10) / 100.0)
	DebugService.silly("%s range from %d to %d" % [name, RANGE_PX, RANGE_PX*modifier])
	RANGE_PX = int(round(RANGE_PX * modifier))

	state = Idle.new()
	state.enter(self)

	$StateName.visible = DebugService.level == DebugService.LogLevel.SILLY


func _process(delta: float) -> void:
	._process(delta)
	$StateName.text = state.get_name()



