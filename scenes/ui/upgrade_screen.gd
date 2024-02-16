extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: PlayerAbility)

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = $MarginContainer/CardContainer
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[PlayerAbility]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in()
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))


func on_upgrade_selected(upgrade: PlayerAbility):
	upgrade_selected.emit(upgrade)
	animation.play("out")
	await animation.animation_finished
	get_tree().paused = false
	queue_free()
