extends CanvasLayer
class_name OptionsMenu

## Project Settings -> Display -> Window -> Mode must not be Fullscreen
## I think it is a bug about Linux or Wayland

const window_modes: Array[DisplayServer.WindowMode] = [
	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
	DisplayServer.WINDOW_MODE_MAXIMIZED,
	DisplayServer.WINDOW_MODE_WINDOWED,
]

signal back_pressed

@onready var sfx_slider := %SfxVolumeSlider
@onready var music_slider := %MusicVolumeSlider
@onready var back_button := %BackButton
@onready var window_button := %WindowButton
@onready var sfx_value_label := %SfxValueLabel
@onready var music_value_label := %MusicValueLabel

var window_mode: DisplayServer.WindowMode:
	set(v):
		DisplayServer.window_set_mode(v)
		window_button.text = get_window_button_text(v)
		window_mode = v


func _ready():
	set_bus_volume_percent("sfx", get_bus_volume_percent("sfx"))
	set_bus_volume_percent("music", get_bus_volume_percent("music"))
	window_mode = DisplayServer.window_get_mode()
	
	sfx_slider.value_changed.connect(on_volume_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_volume_slider_changed.bind("music"))
	back_button.pressed.connect(on_back_button_pressed)
	window_button.pressed.connect(on_window_button_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		back_pressed.emit()


func get_window_button_text(window_mode: DisplayServer.WindowMode) -> String:
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			return "Exclusive Fullscreen"
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			return "Fullscreen"
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			return "Maximized"
		DisplayServer.WINDOW_MODE_MINIMIZED:
			return "Minimized"
		DisplayServer.WINDOW_MODE_WINDOWED:
			return "Windowed"
	return "Unavailable"


func get_bus_volume_percent(bus_name: String) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))


func set_bus_volume_percent(bus_name: String, value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	match bus_name:
		"sfx":
			sfx_slider.value = value
			sfx_value_label.text = "%d" % [value * 100]
		"music":
			music_slider.value = value
			music_value_label.text = "%d" % [value * 100]


func on_volume_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func on_back_button_pressed():
	back_pressed.emit()


func on_window_button_pressed():
	window_mode = window_modes[(window_modes.find(window_mode) + 1) % window_modes.size()]

