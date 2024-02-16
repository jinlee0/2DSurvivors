extends Node

const SPAWN_RADIUS = 250

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer
@onready var base_spawn_time = timer.wait_time

var enemy_table := WeightedTable.new()


func _ready():
	enemy_table.put_row(basic_enemy_scene, 10)
	enemy_table.put_row(wizard_enemy_scene, 1)
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position_away_from(from: Vector2) -> Vector2:
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = from + random_direction * SPAWN_RADIUS
		var ray_result = get_tree().root.world_2d.direct_space_state.intersect_ray(
			PhysicsRayQueryParameters2D.create(from, spawn_position, 1)
		)
		if ray_result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	return spawn_position
	

func on_timer_timeout():
	timer.start()
	var player = NodeGroup.get_player(get_tree())
	if player == null:
		return
	
	var enemy = enemy_table.pick_or_default(basic_enemy_scene).instantiate() as Node2D
	NodeGroup.get_entities_layer(get_tree()).add_child(enemy)
	enemy.global_position = get_spawn_position_away_from(player.global_position)


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.put_row(wizard_enemy_scene, 20)
