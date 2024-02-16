extends Node

@onready var timer: Timer = $Timer

@export var axe_ability_scene: PackedScene

var base_damage: float = 8
var damage_increase: float = 0
var final_damage: float:
	get: return base_damage * (1 + damage_increase)


func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	on_timer_timeout()


func on_timer_timeout():
	var player = NodeGroup.get_player(get_tree())
	if player == null:
		return
	
	var axe_ability_instance = axe_ability_scene.instantiate() as AxeAbility
	NodeGroup.get_foreground_layer(get_tree()).add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage = final_damage
	


func on_ability_upgrade_added(upgrade: PlayerAbility, current_upgrades: UpgradeDict):
	match upgrade.e:
		PlayerAbility.E.AxeDamage:
			damage_increase = current_upgrades.get_value(PlayerAbility.E.AxeDamage).quantity * 0.1
		_: return
