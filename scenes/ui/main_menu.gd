extends CanvasLayer

@onready var top_container := %TopContainer
@onready var play_button := %PlayButton
@onready var options_button := %OptionsButton
@onready var quit_button := %QuitButton

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func on_play_pressed():
	await play_button.audio.finished
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed():
	top_container.visible = false
	var options_instance = options_scene.instantiate() as OptionsMenu
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_menu_closed.bind(options_instance))
	options_instance.layer = layer + 1


func on_options_menu_closed(options_instance: OptionsMenu):
	options_instance.queue_free()
	top_container.visible = true


func on_quit_pressed():
	await quit_button.audio.finished
	get_tree().quit()
