extends Node
class_name VelocityComponent

@export var max_speed: int = 40
@export var acceration: float = 5

@onready var owner_node: CharacterBody2D = owner

var velocity = Vector2.ZERO


func accelerate_to_player():
	var player_node = NodeGroup.get_player(get_tree())
	if player_node == null:
		return
	
	var direction = (player_node.global_position - owner_node.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceration * get_process_delta_time()))


func deccelerate():
	accelerate_in_direction(Vector2.ZERO)


func move():
	owner_node.velocity = velocity
	owner_node.move_and_slide()
	velocity = owner_node.velocity
