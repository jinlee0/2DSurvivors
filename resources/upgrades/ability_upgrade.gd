extends Resource
class_name AbilityUpgrade

@export var id: String
@export var name: String
@export_multiline var description: String
@export var max_quantity: int


func _to_string():
	return "AbilityUpgrade{id=%s,name=%s,description=%s,max_quantity=%d}" % [id, name, description, max_quantity]
