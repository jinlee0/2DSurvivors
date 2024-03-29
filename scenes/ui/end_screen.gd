extends CanvasLayer
class_name EndScreen

@export var victory_audio: AudioStream
@export var defeat_audio: AudioStream

@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var mention_label: Label = %MentionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var screen_open_audio_player := %ScreenOpenAudioStreamPlayer


func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(func():
		restart_button.pressed.connect(on_restart_button_pressed)
		quit_button.pressed.connect(on_quit_button_pressed)
	)
	screen_open_audio_player.stream = victory_audio


func set_as_defeat():
	title_label.text = "Defeat"
	mention_label.text = "You died.."
	screen_open_audio_player.stream = defeat_audio


func play_end_audio():
	screen_open_audio_player.play()


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	await quit_button.audio.finished
	get_tree().quit()
