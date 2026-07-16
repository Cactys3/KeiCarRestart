extends Node2D

@export var Target: Node2D 
@export var Offset: Vector2

func _ready() -> void:
	visible = false
	flash()
func flash():
	await get_tree().create_timer(0.1, false).timeout
	visible = true

func _process(delta: float) -> void:
	if Target:
		position = Vector2.ZERO
		global_position = round(Target.global_position + Offset)
	else:
		position = Vector2.ZERO
		global_position = round(global_position)
