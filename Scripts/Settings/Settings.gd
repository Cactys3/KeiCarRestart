extends Node

enum WindowModes {fullscreen, borderless, windowed}
enum Resolutions {_360, _720, _1080, _1440, _2160}
var window_mode: WindowModes = WindowModes.borderless
var resolution: Vector2i = Vector2i(1920, 1080)

func get_window_mode() -> WindowModes:
	return window_mode
func get_resolution() -> Vector2i:
	return resolution
func set_window_mode(value: WindowModes) -> void:
	window_mode = value
func set_resolution(value: Resolutions) -> void:
	match value:
		Resolutions._360:
			resolution = Vector2i(640, 360)
		Resolutions._720:
			resolution = Vector2i(1280, 720)
		Resolutions._1080:
			resolution = Vector2i(1920, 1080)
		Resolutions._1440:
			resolution = Vector2i(2560, 1440)
		Resolutions._2160:
			resolution = Vector2i(3840, 2160)
