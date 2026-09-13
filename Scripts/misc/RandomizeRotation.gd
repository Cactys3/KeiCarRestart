extends AnimatedSprite2D

func _ready() -> void:
	rotation += randf_range(0, 2 * PI)
