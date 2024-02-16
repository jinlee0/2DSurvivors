extends Node2D

signal player_touched

@onready var vial_audio := $RandomAudioStreamPlayer2D

var is_collecting: bool = false


func _ready():
	$Area2D.area_entered.connect(on_area_entered, CONNECT_ONE_SHOT)
	player_touched.connect(on_player_touched, CONNECT_ONE_SHOT)


func _process(_delta):
	if is_collecting:
		rotate_toward_player()


func tween_position(percent: float, start_position: Vector2):
	var player = NodeGroup.get_player(get_tree())
	if player == null:
		return
	global_position = start_position.lerp(player.global_position, percent)
	if player.global_position.distance_to(global_position) < 10:
		player_touched.emit()


func rotate_toward_player():
	var player = NodeGroup.get_player(get_tree())
	if player == null:
		return
	rotation_degrees = lerp(
		rotation_degrees, 
		rad_to_deg((player.global_position - global_position).angle()) + 90, 
		0.1)


func on_player_touched():
	hide()
	GameEvents.emit_experience_vial_collected(1)
	await vial_audio.play_random()
	queue_free()


func on_area_entered(_other_area: Area2D):
	if is_collecting:
		return
	var tween = create_tween()
	tween.tween_method(tween_position.bind(global_position), 0.0, 1.0, 0.8) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)
	is_collecting = true
