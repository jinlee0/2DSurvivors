extends CanvasLayer

@onready var top_container := %TopContainer
@onready var resume_button := %ResumeButton
@onready var restart_button := %RestartButton
@onready var options_button := %OptionsButton
@onready var quit_button := %QuitButton

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	get_tree().paused = true
	resume_button.pressed.connect(on_resume_pressed)
	restart_button.pressed.connect(on_restart_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		close()


func close():
	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	await resume_button.audio.finished
	close()


func on_restart_pressed():
	await restart_button.audio.finished
	get_tree().paused = false
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
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
