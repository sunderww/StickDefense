extends Button

signal item_purchased(purchase)

var purchase: Purchase

# Called when the node enters the scene tree for the first time.
func _ready():
	text = purchase.title
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	disabled = PlayerVariables.coin < purchase.price


func _on_PurchaseButton_pressed():
	PlayerVariables.coin -= purchase.price
	emit_signal("item_purchased", purchase)
