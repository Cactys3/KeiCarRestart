extends Node
class_name WindowManager
@onready var GameWindow: Window = $"../Window640"
@onready var UiWindow: Window = $"../Window1920"
@onready var Game_Offset: Node2D = $"../Window640/Offset"
@onready var UI_Offset: Control = $"../Window1920/Offset"
var curr_size: Vector2
var player:
	get():
		return GameManager.instance.player
static var session_start_time = null
static var instance: WindowManager
## Game has to start in 4k or sm high resolution or else it doesn't work (can't set to resolutions higher than starting resolution)
## Automatically matches Windows' sizes to program's starting screensize. 
## Windows themselves automatically scale up according to their settings
static var CurrentMonitorSize 
signal ProgramSizedChanged
func _ready() -> void:
	if instance:
		printerr("ERROR, MULTIPLE WINDOW MANAGERS")
	instance = self
	if session_start_time == null:
		session_start_time = Time.get_datetime_string_from_system()
	get_tree().root.size_changed.connect(_center_subwindows)
	var testing = true
	if testing: 
		## Start Windowed 1080p for Testing
		set_program_size(Vector2(1920, 1080), false)
	else:
		## Get Monitor Resolution and start in that
		var main_monitor = DisplayServer.screen_get_usable_rect(0).size
		var current_monitor = DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen()).size
		CurrentMonitorSize = current_monitor
		set_program_size(round_to_integer_scaling(current_monitor, true), false)
	for i in 11:
		await get_tree().process_frame
	if testing:
		GameWindow.position = Vector2i.ZERO
		UiWindow.position = Vector2i.ZERO
		Game_Offset.position = Vector2(58, 274)
		UI_Offset.position = Vector2(58, 274)
		
const BASE_SIZE := Vector2i(640, 360)
func round_to_integer_scaling(size: Vector2i, nearest: bool) -> Vector2i:
	var scale_factor: float = minf(float(size.x) / BASE_SIZE.x, float(size.y) / BASE_SIZE.y)
	var integer_scale: int = roundi(scale_factor) if nearest else floori(scale_factor)
	integer_scale = maxi(integer_scale, 1)
	return BASE_SIZE * integer_scale
## Changes the Game's screensize to parameters and updates scene subwindows aswell
func set_program_size(size: Vector2i, fullscreen: bool):
	## Set Fullscreen/Windowed first, else it bugs out
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		## Don't use given size as we are going fullscreen (use monitor size)
		size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(size)
	## Wait a frame so the root viewport size updates
	## Wait until the root viewport size matches the real window size
	var waited := 0
	while get_tree().root.size != DisplayServer.window_get_size() and waited < 10:
		await get_tree().process_frame
		waited += 1
	## Set Size of Windows
	GameWindow.size = size
	UiWindow.size = size
	## Center after changing size
	var window_position: Vector2i = DisplayServer.screen_get_position(DisplayServer.window_get_current_screen())
	if !fullscreen:
		## Account for Decorations? This is like the titlebar?
		#var decor := DisplayServer.window_get_size_with_decorations() - DisplayServer.window_get_size()
		## Centers Window (gipity)
		var r := DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen())
		var centered = (r.size - size) * 0.5
		window_position = r.position + Vector2i(centered.x, centered.y)
		DisplayServer.window_set_position(window_position)
	
	## Center subwindows inside the main window
	var root_size := Vector2i(get_tree().root.size)
	GameWindow.position = (root_size - GameWindow.size) / 2.0
	UiWindow.position = (root_size - UiWindow.size) / 2.0
	
	## Keep track of curr size
	curr_size = size
	## Let everyone know
	ProgramSizedChanged.emit()
	var testing = false
	if testing:
		print("Size: ", size, " Fullscreen: ", fullscreen, " Root: ", root_size, " GameWindow pos: ", GameWindow.position, " UiWindow pos: ", UiWindow.position)
		print("size param: ", size)
		print("root size: ", get_tree().root.size, " DS window size: ", DisplayServer.window_get_size())
		print("GameWindow size: ", GameWindow.size, " content_scale: ", GameWindow.content_scale_size)
		print("UiWindow size: ", UiWindow.size, " content_scale: ", UiWindow.content_scale_size)
		print("GameWindow embedded: ", GameWindow.is_embedded(), " UiWindow embedded: ", UiWindow.is_embedded())
		print("Game_Offset pos: ", Game_Offset.position, " UI_Offset pos: ", UI_Offset.position)
		print("GameWindow borderless: ", GameWindow.borderless, " UiWindow borderless: ", UiWindow.borderless)
		print("GameWindow pos w/ decor: ", GameWindow.get_position_with_decorations(), " size w/ decor: ", GameWindow.get_size_with_decorations())
		print("UiWindow pos w/ decor: ", UiWindow.get_position_with_decorations(), " size w/ decor: ", UiWindow.get_size_with_decorations())
	#UI_Offset.position = Vector2(size.x / 2, 0) # If Node2D, if Control = not needed
var curr: int = 2
func _process(delta: float) -> void:
	if !instance:
		instance = self
	if Input.is_action_just_pressed("Test1"):
		_on_pressed()
	if Input.is_action_just_pressed("left"):
		GameWindow.position += Vector2i(10, 0)
	if Input.is_action_just_pressed("right"):
		GameWindow.position += Vector2i(-10, 0)
	if Input.is_action_just_pressed("up"):
		GameWindow.position += Vector2i(0, 10)
	if Input.is_action_just_pressed("down"):
		GameWindow.position += Vector2i(0, -10)
	print(GameWindow.position, " And ", UiWindow.position, "+ ", Game_Offset.global_position, " and ", UI_Offset.global_position)
func _center_subwindows() -> void:
	var root_size := Vector2i(get_tree().root.size)
	GameWindow.position = (root_size - GameWindow.size) / 2.0
	UiWindow.position = (root_size - UiWindow.size) / 2.0
	print("recenter root: ", root_size, " pos: ", GameWindow.position)
func _on_pressed() -> void:
	#print("Changed Resolution from: " + str(curr))
	match curr:
		1:
			set_program_size(Vector2(1920, 1080), false)
			curr = 2
		2:
			set_program_size(Vector2(2560, 1440), true)
			curr = 3
		3:
			set_program_size(Vector2(1280, 720), false)
			curr = 1
	
	#print("To: " + str(get_tree().root.size.y))
func convert_small_position(position: Vector2) -> Vector2:
	# Get the content scale size of each window
	var small_size = Vector2(GameWindow.content_scale_size)  # 640x360
	var large_size = Vector2(UiWindow.content_scale_size)
	# Get the vector from player to the position
	var offset_from_player = Vector2(position) - player.global_position
	# Convert to normalized coordinates
	var normalized_offset = offset_from_player / small_size
	# Scale to large window coordinates
	var scaled_offset = normalized_offset * large_size
	# Get the center of the large window
	var large_center = large_size / 2.0
	# Spawn at the scaled offset from the center of the large window
	var pos_in_large = large_center + scaled_offset
	#print("Small->Large: position: " + str(position) + ", player_position: " + str(player.global_position) + ", small_size: " + str(small_size) + ", large_size: " + str(large_size) + ", offset_from_player: " + str(offset_from_player) + ", normalized_offset: " + str(normalized_offset) + ", scaled_offset: " + str(scaled_offset) + ", large_center: " + str(large_center) + ", pos_in_large: " + str(pos_in_large))
	return pos_in_large
func convert_large_position(position: Vector2) -> Vector2:
	# Get the content scale size of each window
	var large_size = Vector2(UiWindow.content_scale_size)
	var small_size = Vector2(GameWindow.content_scale_size)  # 640x360
	# Get the center of the large window
	var large_center = large_size / 2.0
	# Get the offset from the center of the large window
	var offset_from_center = Vector2(position) - large_center
	# Convert to normalized coordinates
	var normalized_offset = offset_from_center / large_size
	# Scale to small window coordinates
	var scaled_offset = normalized_offset * small_size
	# Apply the scaled offset from the player position
	var pos_in_small = player.global_position + scaled_offset
	#print("Large->Small: position: " + str(position) + ", player_position: " + str(player.global_position) + ", large_size: " + str(large_size) + ", small_size: " + str(small_size) + ", large_center: " + str(large_center) + ", offset_from_center: " + str(offset_from_center) + ", normalized_offset: " + str(normalized_offset) + ", scaled_offset: " + str(scaled_offset) + ", pos_in_small: " + str(pos_in_small))
	return pos_in_small

## Also handles saving on close game because this node always exists
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		## Update Playtime
		var time_since_playtime_start_seconds: float = roundi((Time.get_ticks_msec() - TitleManager.start_playtime) / 1000)
		Save.update_runtime_data(TitleManager.file_slot, Save.Playtime, Save.get_runtime_data(TitleManager.file_slot, Save.Playtime) + time_since_playtime_start_seconds)
		## Update Gametime
		if TitleManager.start_gametime > 1000:
			var time_since_gametime_start_seconds: float = roundi((Time.get_ticks_msec() - TitleManager.start_gametime) / 1000)
			Save.update_runtime_data(TitleManager.file_slot, Save.Playtime, Save.get_runtime_data(TitleManager.file_slot, Save.Playtime) + time_since_gametime_start_seconds)
		## Add to game's playcount
		Save.update_runtime_data(TitleManager.file_slot, Save.PlayCount, Save.get_runtime_data(TitleManager.file_slot, Save.PlayCount) + 1)
		## Save to file on close game
		Save.save_file(TitleManager.file_slot)
