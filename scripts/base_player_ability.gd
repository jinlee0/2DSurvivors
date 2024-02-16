extends PlayerAbility
class_name BasePlayerAbility

var controller_scene: PackedScene


func _init(
	_e: E,
	_name: String,
	_description: String,
	_max_quantity: int,
	_controller_scene: PackedScene
):
	super._init(_e, _name, _description, _max_quantity)
	controller_scene = _controller_scene
