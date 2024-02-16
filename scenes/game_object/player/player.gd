extends CharacterBody2D
class_name Player

@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_area: Area2D = $CollisionArea
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var velocity_component := $VelocityComponent
@onready var hit_audio := $HitRandomAudioStreamPlayer2D

var number_colliding_bodies = 0


func _ready():
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_bar()


func _process(_delta):
	var movement = get_movement_vector()
	velocity_component.accelerate_in_direction(get_movement_vector())
	velocity_component.move()
	
	if movement.x != 0 or movement.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	if movement.x != 0:
		visuals.scale = Vector2(sign(movement.x), 1)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()


func check_deal_damage():
	if number_colliding_bodies == 0 || not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	hit_audio.play_random()
	damage_interval_timer.start()


func update_health_bar():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(_other_body: Node2D): # EnemyCollision mask
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(_other_body: Node2D):  # EnemyCollision mask
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	update_health_bar()
	GameEvents.emit_player_damaged()


func on_ability_upgrade_added(upgrade: PlayerAbility, current_upgrades: UpgradeDict):
	if upgrade is BasePlayerAbility:
		abilities.add_child(upgrade.controller_scene.instantiate())
	elif upgrade.e == PlayerAbility.E.PlayerSpeed:
		velocity_component.max_speed *= (1 + current_upgrades.get_value(upgrade.e).quantity * 0.1)
