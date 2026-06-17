extends AnimatedSprite2D

@export var animation_name: String = "default"
@export var max_random: float = 10
@export var min_random: float = 1

func _ready() -> void:
	sprite_frames.set_animation_speed(animation_name, randf_range(min_random, max_random))
