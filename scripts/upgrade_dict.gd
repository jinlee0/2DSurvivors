class_name UpgradeDict

var _dict = {}


func put(key: PlayerAbility.E, value: Value):
	_dict[key] = value


func get_value(key: PlayerAbility.E) -> Value:
	return _dict[key]


func has(key: PlayerAbility.E) -> bool:
	return _dict.has(key)


class Value:
	var resource: PlayerAbility
	var quantity: int
	
	
	func _init(_resource: PlayerAbility, _quantity: int):
		resource = _resource
		quantity = _quantity
