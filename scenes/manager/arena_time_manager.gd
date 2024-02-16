extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen: PackedScene

@onready var timer: Timer = $Timer

var arena_difficulty = 0


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	var target_time = timer.wait_time - (arena_difficulty) * DIFFICULTY_INTERVAL
	if timer.time_left <= target_time:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.play_end_audio()
