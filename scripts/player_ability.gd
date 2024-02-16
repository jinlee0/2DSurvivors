class_name PlayerAbility

enum E {
	Sword,
	SwordRate,
	SwordDamage,
	Axe,
	AxeDamage,
	PlayerSpeed,
}

static var _prerequisites := {} # Key: E, Value: Array[E]
static var _unlocks := {} # Key: E, value: Array[E]
static var _instances := {} # Key: E, value: PlayerAbility

var e: E
var name: String
var description: String
var max_quantity: int


static func _static_init():
	for v in E.values():
		_prerequisites[v] = []
		_unlocks[v] = []
	for v in E.values():
		_instances[v] = init_instance_of(v)


func _init(
	_e: E,
	_name: String,
	_description: String,
	_max_quantity: int,
):
	e = _e
	name = _name
	description = _description
	max_quantity = _max_quantity


static func init_instance_of(_e: E) -> PlayerAbility:
	match _e:
		E.Sword:
			return add_base_ability_with(
				_e,
				"Sword",
				"Periodically spawn a swingging sword",
				1,
				preload("res://scenes/ability/sword_ability/sword_ability_controller.tscn"),
				[]
			)
		E.SwordRate:
			return add_ability_with(
				_e,
				"Sword Quickness",
				"Increases sword attack rate by 10%.",
				5,
				[E.Sword],
			)
		E.SwordDamage:
			return add_ability_with(
				_e,
				"Sword Damage",
				"Increases sword attack damage by 10%.",
				5,
				[E.Sword],
			)
		E.Axe:
			return add_base_ability_with(
				_e,
				"Axe",
				"Periodically sends out a spinning axe.",
				1,
				preload("res://scenes/ability/axe_ability/axe_ability_controller.tscn"),
				[],
			)
		E.AxeDamage:
			return add_ability_with(
				_e,
				"Axe Damage",
				"Increases axe attack damage by 10%.",
				5,
				[E.Axe],
			)
		E.PlayerSpeed:
			return add_ability_with(
				_e,
				"Speed Up",
				"Increases player movement sppend by 10%",
				2,
				[],
			)
	return null


static func add_ability_with(
	_e: E,
	_name: String, 
	_description: String, 
	_max_quantity: int,
	pre: Array[E]
) -> PlayerAbility:
	return register_instance(PlayerAbility.new(_e, _name, _description, _max_quantity), pre)


static func add_base_ability_with(
	_e: E,
	_name: String, 
	_description: String, 
	_max_quantity: int,
	_controller_scene: PackedScene,
	pre: Array[E]
) -> BasePlayerAbility:
	return register_instance(BasePlayerAbility.new(_e, _name, _description, _max_quantity, _controller_scene), pre)


static func register_instance(instance: PlayerAbility, pre: Array[E]) -> PlayerAbility:
	_prerequisites[instance.e] = pre
	for p in pre: # append unlocks for prerequisites
		_unlocks[p].append(instance.e)
	return instance


static func instance_of(_e: E) -> PlayerAbility:
	return _instances[_e]


static func get_instances() -> Array[PlayerAbility]:
	var arr: Array[PlayerAbility] = []
	for i in _instances.values():
		arr.append(i)
	return arr


func prerequisites() -> Array[PlayerAbility]:
	var result: Array[PlayerAbility] = []
	for pre_e in _prerequisites[e]:
		result.append(_instances[pre_e])
	return result


func unlocks() -> Array[PlayerAbility]:
	var result: Array[PlayerAbility] = []
	for unlock_e in _unlocks[e]:
		result.append(_instances[unlock_e])
	return result


func _to_string():
	return PlayerAbility.E.find_key(e)
