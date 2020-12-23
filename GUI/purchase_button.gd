extends MarginContainerButton

signal item_purchased(purchase)

var purchase: Purchase

onready var name_label = $MarginContainer/VBoxContainer/Name
onready var price_label = $MarginContainer/VBoxContainer/Price

# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = purchase.title
	price_label.text = "%d" % purchase.price


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.disabled = PlayerVariables.coin < purchase.price


func _on_PurchaseButton_pressed():
	emit_signal("item_purchased", purchase)
	$AudioStreamPlayer.play()

