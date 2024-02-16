extends AudioStreamPlayer
class_name RandomAudioStreamPlayerComponent

@export var stream_array: Array[AudioStream]
@export var min_pitch = .9
@export var max_pitch = 1.1
@export var randomize_pitch = true


func play_random(from_position: float = 0.0) -> Signal:
	if stream_array == null || stream_array.is_empty(): return Signal()
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	stream = stream_array.pick_random()
	play(from_position)
	return finished
