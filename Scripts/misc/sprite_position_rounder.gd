extends Node2D

@export var Target: Node2D 
@export var Offset: Vector2

func _process(delta: float) -> void:
	if Target:
		global_position = round(Target.global_position + Offset)
	else:
		position = Vector2.ZERO
		global_position = round(global_position)
