extends Button

@onready var audio := $RandomAudioStreamPlayerComponent


func _ready():
	pressed.connect(on_pressed)


func on_pressed():
	audio.play_random()
