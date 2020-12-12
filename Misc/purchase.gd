class_name Purchase

enum SpawnType { GROUND, AIR, MOUSE }

var price: int
var title: String
var resource: String
var spawn_type: int

func _init(_title: String, _price: int, _resource: String, _spawnType: int = SpawnType.GROUND) -> void:
	price = _price
	title = _title
	resource = _resource
	spawn_type = _spawnType
