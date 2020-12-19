extends MarginContainer

class_name MarginContainerButton

signal pressed()

onready var _button = find_node("Button")
#all the button content should go in the margin container
onready var _margin_container = find_node("MarginContainer")
#label is optional
onready var _label = find_node("Label")


var disabled setget set_disabled, get_disabled
var pressed setget set_pressed, get_pressed
var text setget set_text, get_text


func _ready():
	_button.connect("pressed", self, "_pressed")
	for node in _get_all_children(_margin_container):
		node.mouse_filter = MOUSE_FILTER_IGNORE

func _get_all_children(node):
	var ret = []
	for child in node.get_children():
		ret.push_back(child)
		for childs_child in _get_all_children(child):
			ret.push_back(childs_child)
	return ret

func get_disabled():
	return _button.disabled

func set_disabled(val):
	_button.disabled = val
	_margin_container.modulate.a = 0.5 if val else 1

func _pressed():
	emit_signal("pressed")

func set_text(text):
	if _label != null:
		_label.text = text
	
func get_text():
	return _label.text if _label != null else ""

func set_pressed(val):
	_button.pressed = val
	
func get_pressed():
	return _button.pressed

func set_text_colour(colour):
	_margin_container.modulate = colour



