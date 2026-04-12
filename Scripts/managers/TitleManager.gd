extends Node
class_name TitleManager
## Nodes
@export var main: Control
@export var settings: Control 
@export var collection: Control 
@export var shop: Control 
@export var page_title: RichTextLabel 
@export var button_back: Button
@export var character_selection: Control 
@export var map_selection: Control 
@export var weapon_selection: Control
@export var text_character: RichTextLabel
@export var text_map: RichTextLabel
@export var text_weapon: RichTextLabel
@export var achievement_parent: Control
@export var weapon_parent: Control
@export var item_parent: Control
static var file_slot: int = 0

const BaseScene: String = "res://Scenes/Main/BaseScene.tscn"
## Instances
var TEST: duple = duple.new("TEST", "res://Scenes/Main/TestInstance.tscn")
var DARKFOREST: duple = duple.new("DARKFOREST", "res://Scenes/DarkForest/DarkForest.tscn")
## Characters [global_stats][character scene]
var WEBFISHER: duple = duple.new("WebFisher", "res://Scenes/Characters/Character.tscn")
var LILY: duple = duple.new("Lily", "res://Scenes/Characters/Lily.tscn")
## Weapons
var BOXING_GLOVE: duple = duple.new("Boxing Glove", ShopManager.BOXING_GLOVES)
## Choice Variables
var character: int ## Chosen character
var map: int ## Chosen map
var weapon: int ## Chosen weapon
var characters: Array[duple] = [WEBFISHER, LILY]
var maps: Array[duple] = [TEST, DARKFOREST]
var weapons: Array[duple] = [BOXING_GLOVE]

var array: Array[Control] = [main, settings, collection, shop, character_selection, map_selection]

static var start_playtime: float 
static var start_gametime: float 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_playtime = Time.get_ticks_msec()
	## For testing:
	GlobalStats.reset()
	GameInstance.is_game_over = false
	
	set_process_input(true)
	set_process_unhandled_input(true)
	# For buttons specifically:
	process_mode = Node.PROCESS_MODE_INHERIT
	
	var window = get_window()
	## Set to saved screen size
	window.size = Vector2(1920, 1080)
	## Setup Titlescreen window settings (make sure to resetup when changing to game scene)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	window.move_to_center()
	set_main()
	
	#print("connect signals")
	button_back.button_down.connect(set_main)
	#print("Tree paused: ", get_tree().paused)

	## Make sure file is created
	call_deferred("save")
func save():
	if !Save.check_save_data(0):
		Save.create_file(0)
	Save.load_file(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

### UI Code
## Sets up main buttons to be visible
func set_main():
	#print("Main")
	set_visible([main])
	page_title.text = "Titlescreen"
## Return to previous screen
func press_back() -> void:
	#print("back")
	set_main()
## Go to Character Selection
func press_play() -> void:
	#print("play")
	press_character_select()
## Go to Settings
func press_settings() -> void:
	#print("setting")
	set_visible([settings])
	page_title.text = "Settings"
## Go to Collection
func press_collection() -> void:
	#print("collection")
	setup_achievements()
	set_visible([collection])
	page_title.text = "Collection"
## Go to Shop
func press_shop() -> void:
	#print("shop")
	set_visible([shop])
	page_title.text = "Shop"
## Go to Character Select
func press_character_select():
	#print("character_select")
	set_visible([character_selection])
	page_title.text = "Character Selection"
func press_weapon_select():
	#print("weapon_selection")
	set_visible([weapon_selection])
	page_title.text = "Weapon Select"
## Go to Map Select
func press_map_select():
	#print("map_select")
	set_visible([map_selection])
	page_title.text = "Map Selection"
## Go to Game Scene
func press_start_game():
	var window = get_window()
	window.size = Vector2(3840, 2160)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	#change scene
	get_tree().paused = true
	get_tree().current_scene.queue_free()
	
	var base_scene: Node2D = load(BaseScene).instantiate()
	var instance: GameInstance = setup_instance(base_scene)
	get_tree().root.add_child(base_scene)
	get_tree().current_scene = base_scene
	start_gametime = Time.get_ticks_msec()
## Creates Instance with Chosen Values
func setup_instance(base_scene) -> GameInstance:
	#print("Creating instance with Map: " + maps[map].key + ", Char: " + characters[character].key)
	var game_instance: GameInstance = get_instance()
	var chosen_character: Character = get_character()
	var chosen_weapon: String = get_weapon()
	base_scene.add_child(game_instance)
	base_scene.setup_instance(game_instance)
	game_instance.setup(chosen_character, chosen_weapon, null)
	## 
	return game_instance
## Returns chosen instance
func get_instance() -> GameInstance:
	return load(maps[map].value).instantiate()
func get_character() -> Character:
	return load(characters[character].value).instantiate()
func get_weapon() -> String:
	return weapons[weapon].value
func set_map(index: int):
	if maps.size() > index:
		map = index
		text_map.text = "Map: " + maps[map].key
func set_character(index: int):
	if characters.size() > index:
		character = index
		text_character.text = "Character: " + characters[character].key
func set_weapon(index: int):
	if weapons.size() > index:
		weapon = index
		text_weapon.text = "Weapon: " + weapons[weapon].key
## Sets only parameter as visible
func set_visible(nodes: Array[Control]):
	main.visible = false
	settings.visible = false
	collection.visible = false
	shop.visible = false
	character_selection.visible = false
	map_selection.visible = false
	weapon_selection.visible = false
	for node in nodes:
		node.visible = true
func _quickstart():
	character = 1
	map = 1
	weapon = 0
	press_start_game()
## Setup the achievements visual based on Save Data
func setup_achievements():
	for child in achievement_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	for child in weapon_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	for child in item_parent.get_children():
		if child.name.contains("delete_this"):
			child.queue_free()
	## Setup Achievements
	var first = true
	for a in Save.ACHIEVEMENTS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		achievement_parent.add_child(new_visual)
		new_visual.text = " " + str(a) + ": "
		if Save.ACHIEVEMENTS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.ACHIEVEMENTS_DICT[a]) + "[/color]"
			achievement_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.ACHIEVEMENTS_DICT[a]) + "[/color]"
			achievement_parent.move_child(new_visual, achievement_parent.get_child_count())
		setup_label(new_visual)
	## Setup Weapon Unlocks
	first = true
	for a in Save.WEAPON_UNLOCKS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		new_visual.text = " Unlocked " + str(a) + ": " 
		weapon_parent.add_child(new_visual)
		if Save.WEAPON_UNLOCKS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.WEAPON_UNLOCKS_DICT[a]) + "[/color]"
			weapon_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.WEAPON_UNLOCKS_DICT[a]) + "[/color]"
			weapon_parent.move_child(new_visual, weapon_parent.get_child_count())
		setup_label(new_visual)
	## Setup Item Unlocks
	first = true
	for a in Save.ITEM_UNLOCKS_DICT:
		print("a:" + str(a))
		if first:
			first = false
			continue
		var new_visual = RichTextLabel.new()
		new_visual.text = " Unlocked " + str(a) + ": "
		item_parent.add_child(new_visual)
		if Save.ITEM_UNLOCKS_DICT[a]:
			new_visual.text += "[color=green]" + str(Save.ITEM_UNLOCKS_DICT[a]) + "[/color]"
			item_parent.move_child(new_visual, 1)
		else:
			new_visual.text += "[color=red]" + str(Save.ITEM_UNLOCKS_DICT[a]) + "[/color]"
			item_parent.move_child(new_visual, item_parent.get_child_count())
		setup_label(new_visual)

func setup_label(label: RichTextLabel) -> RichTextLabel:
		label.bbcode_enabled = true
		label.fit_content = true
		label.scroll_active = false
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.add_theme_font_size_override("normal_font_size", 64)
		label.name += "delete_this"
		return label

class duple:
	var key: String
	var value: String
	func _init(new_key: String, new_value: String):
		key = new_key
		value = new_value


func _on_choose_0_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.
