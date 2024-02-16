extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var death_audio_stream_player_2d: RandomAudioStreamPlayer2D = $HitRandomAudioStreamPlayer2D


func _ready():
	particles.texture = sprite.texture
	health_component.died.connect(on_died)
	particles.emitting = false
	particles.finished.connect(on_particles_finishied)


func on_died():
	if owner == null or not owner is Node2D:
		return
	var death_position = owner.global_position
	
	var entities = NodeGroup.get_entities_layer(get_tree())
	get_parent().remove_child(self)
	entities.add_child(self)
	particles.emitting = true
	global_position = death_position
	
	death_audio_stream_player_2d.play_random()


func on_particles_finishied():
	queue_free()
