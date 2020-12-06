extends CanvasLayer

signal item_purchased(purchase)

var PurchaseButton = load("res://GUI/PurchaseButton.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for purchase in PurchaseManager.available_purchases:
		var button = PurchaseButton.instance()
		button.purchase = purchase
		button.connect("item_purchased", self, "_on_item_purchased")
		$MarginContainer/HBoxContainer/PurchaseContainer.add_child(button)


func _on_item_purchased(purchase: Purchase):
	emit_signal("item_purchased", purchase)
