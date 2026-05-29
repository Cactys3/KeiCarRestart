extends Node2D
class_name Event
@export var event_name: String = "unset"
@export var event_description: String = "unset"
@export var show_size_debug: bool = false
@export var event_center_offset: Vector2
@export var event_size: Vector2:
	set(value):
		event_size = value
		queue_redraw()
func _draw() -> void:
	if !show_size_debug:
		return
	if event_size == Vector2.ZERO:
		return
	draw_rect(Rect2(event_center_offset - event_size / 2.0, event_size), Color.RED, false, 2.0)




var chunk: Vector2 
var time: float 
var level: float

func setup(new_time: float, new_level: float, new_chunk: Vector2):
	time = new_time
	level = new_level
	chunk = new_chunk

func _init() -> void:
	visible = false
func _ready() -> void:
	add_to_group("event")
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
