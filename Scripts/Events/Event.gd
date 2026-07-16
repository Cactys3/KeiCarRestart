extends Node2D
class_name Event

func _draw() -> void:
	if show_size_debug || DebugManager.EventSize:
		if event_size != Vector2.ZERO:
			draw_rect(Rect2(event_center_offset - event_size / 2.0, event_size), Color.RED, false, 2.0)

@export var show_size_debug: bool = false

var event_name: String
var event_description: String = "unset"
var event_center_offset: Vector2
var event_size: Vector2
var event_type: EventData.EventTypes

var data: EventData
var chunk: Vector2 
var time: float 
var level: float
var has_setup: bool = false

func setup(new_time: float, new_level: float, new_chunk: Vector2):
	has_setup = true
	time = new_time
	level = new_level
	chunk = new_chunk
func _init() -> void:
	visible = false
func _ready() -> void:
	add_to_group("event")
	flash()
func flash():
	await get_tree().create_timer(0.1, false).timeout
	visible = true
func die():
	queue_free()
