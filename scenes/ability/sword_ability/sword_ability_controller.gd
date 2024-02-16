extends Node2D

const MAX_RANGE = 150

@export var sword_ability: PackedScene

@onready var timer: Timer = $Timer
@onready var base_wait_time = timer.wait_time

var is_ready: bool = true
var base_damage: float = 5
var damage_increase: float = 0
var final_damage: float:
	get: return base_damage * (1 + damage_increase)


func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)



func _process(_delta):
	if not is_ready: return
	var enemies = get_enemies()
	if enemies.is_empty(): return
	activate_ability_to(enemies)
	is_ready = false
	timer.start()


func get_enemies() -> Array[Node2D]:
	var player = NodeGroup.get_player(get_tree())
	if player == null: return []
	var enemies: Array[Node2D] = []
		
	enemies.append_array(NodeGroup.get_enemies(get_tree()).filter(func(e: Node2D):
		return e.global_position.distance_squared_to(player.global_position) <= pow(MAX_RANGE, 2)
	))
	enemies.sort_custom(func(e1: Node2D, e2: Node2D):
		var d1 = e1.global_position.distance_squared_to(player.global_position) 
		var d2 = e2.global_position.distance_squared_to(player.global_position)
		return d1<d2
	)
	return enemies


func activate_ability_to(enemies: Array[Node2D]):
	var sword_instance = sword_ability.instantiate() as SwordAbility
	NodeGroup.get_foreground_layer(get_tree()).add_child(sword_instance)
	sword_instance.hitbox_component.damage = final_damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_timer_timeout():
	is_ready = true
	timer.stop()
	

func on_ability_upgrade_added(upgrade: PlayerAbility, current_upgrades: UpgradeDict):
	match upgrade.e:
		PlayerAbility.E.SwordRate:
			var percent_reduction = current_upgrades.get_value(PlayerAbility.E.SwordRate).quantity * 0.1
			timer.wait_time = base_wait_time * (1 - percent_reduction)
		PlayerAbility.E.SwordDamage:
			damage_increase = current_upgrades.get_value(PlayerAbility.E.SwordDamage).quantity * 0.1
		_: return

