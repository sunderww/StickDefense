# Superclass (faux interface) common to all finite state machine / pushdown automata.
extends Node
class_name State

var parent = null

# Return the unique string name of the state. Must be overridden.
func get_name() -> String:
	assert(false)
	return ""

# Handle any transitions into this state. Subclasses should first chain to this method.
func enter(_parent) -> void:
	parent = _parent
	_animate()

# Transition to a new animation; by default, one matching the name of the State (if it exists).
# Can be overridden without chaining.
func _animate() -> void:
	var sprite: AnimatedSprite = parent.get_node("AnimatedSprite")
	if sprite == null:
		return
	sprite.animation = get_name()
#	var animation_player = parent.get_node("AnimationPlayer")
#	if animation_player == null:
#		return
#	var name = get_name()
#	if animation_player.has_animation(name):
#		animation_player.play(name)

# Update physics processing.
func _fixed_process(_delta: float):
	pass

# Update regular processing.
func _process(_delta: float):
	pass

# Handle exit events.
func exit() -> void:
	pass

# Exit the current state, enter the new state.
func set_state(state) -> void:
	parent.state.exit()
	parent.state = state
	state.enter(parent)
