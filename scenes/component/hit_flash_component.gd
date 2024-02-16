extends Node

@export var sprite: Sprite2D
@export var health_component: HealthComponent
@export var hit_flash_material: ShaderMaterial

var tween: Tween


func _ready():
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material


func on_health_changed():
	if tween != null and tween.is_running():
		tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.2)
	
	
