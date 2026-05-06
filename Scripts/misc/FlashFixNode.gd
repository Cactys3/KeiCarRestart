extends Node2D
## Wait for 0.1 seconds before becoming visible on ready
class_name FlashFixNode
func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
