extends Node

var available_purchases = [
	Purchase.new("Infantry", 15, "res://Entities/Infantry/Infantry.tscn"),
	Purchase.new("Chopper", 100, "res://Entities/Chopper/Chopper.tscn", Purchase.SpawnType.AIR),
]
