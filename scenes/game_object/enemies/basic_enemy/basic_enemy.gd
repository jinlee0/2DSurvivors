extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hit_audio: RandomAudioStreamPlayer2D = $HitRandomAudioStreamPlayer2D


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(_delta):
	velocity_component.accelerate_to_player()
	
	velocity_component.move()
	if velocity.x != 0:
		visuals.scale = Vector2(-sign(velocity.x), 1)


func on_hit():
	hit_audio.play_random()
