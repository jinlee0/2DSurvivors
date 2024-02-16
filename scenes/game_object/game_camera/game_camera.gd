extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()
	global_position = NodeGroup.get_player(get_tree()).global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = NodeGroup.get_player(get_tree())
	global_position = global_position.lerp(player.global_position, 1.0 - exp(-delta * 20))
