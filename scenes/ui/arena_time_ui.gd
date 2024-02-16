extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %Label

func _process(_delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds(time_elapsed)


func format_seconds(seconds: float):
	var minute = floor(seconds/60)
	var sec = fmod(seconds, 60)
	return "%02d:%02d" % [minute, sec]
