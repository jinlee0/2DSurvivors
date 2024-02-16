extends Node
class_name UpgradeManager

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var upgrade_pool: Array[PlayerAbility]
var current_upgrades: UpgradeDict = UpgradeDict.new()
var start_abilities: Array[PlayerAbility.E] = [PlayerAbility.E.Sword]


func _ready():
	experience_manager.level_up.connect(on_level_up)
	# Apply start abilities
	for start_ability in start_abilities:
		apply_upgrade(PlayerAbility.instance_of(start_ability))
	# Add abilities that have no prerequisites into upgrade_pool except start abilities
	for no_prerequisite_ability in PlayerAbility.get_instances().filter(
		func (ability: PlayerAbility): 
			return ability.prerequisites().is_empty() and not current_upgrades.has(ability.e)
	): 
		upgrade_pool.append(no_prerequisite_ability)
	


func apply_upgrade(upgrade: PlayerAbility):
	if not current_upgrades._dict.has(upgrade.e):
		current_upgrades.put(upgrade.e, UpgradeDict.Value.new(upgrade, 1))
	else:
		current_upgrades.get_value(upgrade.e).quantity += 1
	
	if (upgrade.max_quantity > 0 and 
			current_upgrades.get_value(upgrade.e).quantity >= upgrade.max_quantity): 
		upgrade_pool = upgrade_pool.filter(func (e): return e.e != upgrade.e)
	for unlock in upgrade.unlocks():
		if unlock.prerequisites().all(func(pre): return current_upgrades.has(pre.e))\
				and not upgrade_pool.has(unlock):
			upgrade_pool.append(unlock)

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[PlayerAbility]:
	var chosen_upgrades: Array[PlayerAbility] = []
	var pool = upgrade_pool.duplicate()
	for i in 2:
		if pool.is_empty():
			break
		var chosen = pool.pick_random() as PlayerAbility
		chosen_upgrades.append(chosen)
		pool = pool.filter(func (upgrade: PlayerAbility): return upgrade.e != chosen.e)
	return chosen_upgrades


func on_upgrade_selected(upgrade: PlayerAbility):
	apply_upgrade(upgrade)


func on_level_up(_current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(pick_upgrades())
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
