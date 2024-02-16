extends AbilityUpgrade
class_name Ability

@export var ability_controller_scene: PackedScene


func instantiate_controller_scene() -> Node:
	return ability_controller_scene.instantiate()
