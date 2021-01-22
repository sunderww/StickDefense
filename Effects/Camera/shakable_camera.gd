extends Camera2D

onready var timer: Timer = $Timer

export var amplitude: float = 6
export var duration: float = 0.8 setget _set_duration
export var shake: bool = false setget _set_shake
export(float, EASE) var damp_easing := 1.0

export var enabled: bool = true

var old_duration: float = -1


func _ready() -> void:
	randomize()
	set_process(false)
	_set_duration(duration) # Force call the method to set the timer duration


func _process(_delta: float) -> void:
	var damping := ease(timer.time_left / timer.wait_time, damp_easing)
	offset = Vector2(
		rand_range(-amplitude, amplitude) * damping,
		rand_range(-amplitude, amplitude) * damping
	)


func shake_for(time: float) -> void:
	old_duration = duration
	_set_duration(time)
	_set_shake(true)
	


func _set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration


func _set_shake(value: bool) -> void:
	shake = value
	offset = Vector2()
	
	# No need to call _process when we're not shaking
	set_process(value)
	
	if shake:
		timer.start()


func _on_shake_requested() -> void:
	if not enabled:
		return
	self.shake = true


func _on_Timer_timeout() -> void:
	self.shake = false
	
	if old_duration > 0:
		duration = old_duration
		old_duration = -1
