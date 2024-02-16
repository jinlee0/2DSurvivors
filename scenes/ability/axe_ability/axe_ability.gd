extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@onready var hitbox_component: HitboxComponent = $HitBoxComponent

var base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))


func _ready():
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)

	var player = NodeGroup.get_player(get_tree())
	if player == null:
		return
	global_position = player.global_position + (current_direction * current_radius)
