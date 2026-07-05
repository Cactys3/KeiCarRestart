extends Node
class_name TitleManager
@onready var audio_manager: AudioManager = $"../AudioManager"
## Nodes
@export var main: Control
@export var settings: Control 
@export var collection: Control 
@export var shop: Control 
@export var page_title: RichTextLabel 
@export var button_back: Button
@export var character_selection: Control 
@export var abilities_selection: Control
@export var map_selection: Control 
@export var weapon_selection: Control
@export var text_character: RichTextLabel
@export var text_ability1: RichTextLabel
@export var text_ability2: RichTextLabel
@export var text_ability3: RichTextLabel
@export var text_map: RichTextLabel
@export var text_weapon: RichTextLabel
@export var achievement_parent: Control
@export var weapon_parent: Control
@export var item_parent: Control
## Selections
@export var weapon_select_parent: GridContainer
@export var map_select_parent: GridContainer
@export var character_select_parent: GridContainer
@export var abilities_select_parent: GridContainer

static var file_slot: int = 0
const BaseScene: String = "res://Scenes/Main/BaseScene.tscn"
## Instances
var TEST: duple = duple.new("Test Map", "res://Scenes/Main/TestInstance.tscn")
var DARKFOREST: duple = duple.new("Dark Forest", "res://AllInOne/Maps/DarkForest/DarkForest.tscn")
var HELL: duple = duple.new("Hell", "res://AllInOne/Maps/Hell/Hell.tscn")
var FRUITSANDVEGGIES: duple = duple.new("Fruits and Veggies", "res://AllInOne/Maps/FruitsAndVeggies/FruitsAndVeggies.tscn")
## Characters [global_stats][character scene]
var WEBFISHER: duple = duple.new("WebFisher", "res://AllInOne/Characters/Webfisher/Webfisher.tres")
var LILY: duple = duple.new("Lily", "res://AllInOne/Characters/Lily/Lily.tres")
var OMI: duple = duple.new("Omi", "res://AllInOne/Characters/Lily/Lily.tres")
## Weapons
var BOXING_GLOVE: duple = duple.new("Boxing Glove", ShopManager.BOXING_GLOVES)
var PISTOL: duple = duple.new("Pistol", ShopManager.PISTOL)
var SHOTGUN: duple = duple.new("Shotgun", ShopManager.SHOTGUN)
var SHURIKEN: duple = duple.new("Shuriken", ShopManager.SHURIKEN)
## Choice Variables
var character: int = 0 ## Chosen character
var map: int = 1 ## Chosen map
var weapon: int = 3 ## Chosen weapon
var ability1: AbilityData = null
var ability2: AbilityData = null
var ability3: AbilityData = null
var characters: Array[duple] = [LILY, OMI, WEBFISHER]
var maps: Array[duple] = [TEST, DARKFOREST, HELL, FRUITSANDVEGGIES]
var weapons: Array[duple] = [BOXING_GLOVE, PISTOL, SHOTGUN, SHURIKEN]
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
	## Setup Selection Screens (except abilities)
	for c in characters:
		var button: Button = Button.new()
		button.text = c.key
		button.pressed.connect(set_character.bind(characters.find(c)))
		button.add_theme_font_size_override("font_size", 128)
		character_select_parent.add_child(button)
	for m in maps:
		var button: Button = Button.new()
		button.text = m.key
		button.pressed.connect(set_map.bind(maps.find(m)))
		button.add_theme_font_size_override("font_size", 128)
		map_select_parent.add_child(button)
	for w in weapons:
		var button: Button = Button.new()
		button.text = w.key
		button.pressed.connect(set_weapon.bind(weapons.find(w)))
		button.add_theme_font_size_override("font_size", 128)
		weapon_select_parent.add_child(button)
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
	set_visible([main])
	page_title.text = "Titlescreen"
## Return to previous screen
func press_back() -> void:
	play_button_sound()#print("back")
	set_main()
## Go to Character Selection
func press_play() -> void:
	play_button_sound()#print("play")
	press_character_select()
## Go to Settings
func press_settings() -> void:
	play_button_sound()#print("setting")
	set_visible([settings])
	page_title.text = "Settings"
## Go to Collection
func press_collection() -> void:
	play_button_sound()#print("collection")
	setup_achievements()
	set_visible([collection])
	page_title.text = "Collection"
## Go to Shop
func press_shop() -> void:
	play_button_sound()#print("shop")
	set_visible([shop])
	page_title.text = "Shop"
## Go to Character Select
func press_character_select():
	play_button_sound()#print("character_select")
	set_visible([character_selection])
	page_title.text = "Character Selection"
func press_abilities_select():
	play_button_sound()
	set_visible([abilities_selection])
	page_title.text = "Abilities Selection"
	var index: int = 1
	var chara = load(characters[character].value)
	for a in load(characters[character].value).abilities:
		var button: Button = Button.new()
		button.text = a.ability_name
		button.pressed.connect(set_ability.bind(a))
		button.add_theme_font_size_override("font_size", 128)
		abilities_select_parent.add_child(button)
		index += 1
	if index == 1:
		page_title.text = "Abilities Selection (none are unlocked)"
func press_weapon_select():
	play_button_sound()#print("weapon_selection")
	set_visible([weapon_selection])
	page_title.text = "Weapon Select"
## Go to Map Select
func press_map_select():
	play_button_sound()#print("map_select")
	set_visible([map_selection])
	page_title.text = "Map Selection"
## Go to Game Scene
func press_start_game():
	play_button_sound()
	var window = get_window()
	window.size = Vector2(3840, 2160)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	#change scene
	get_tree().paused = true
	get_tree().current_scene.queue_free()
	
	var base_scene: Node2D = load(BaseScene).instantiate()
	var instance: GameInstance = setup_instance(base_scene)
	audio_manager.reparent(base_scene)
	
	get_tree().root.add_child(base_scene)
	get_tree().current_scene = base_scene
	start_gametime = Time.get_ticks_msec()
## Creates Instance with Chosen Values
func setup_instance(base_scene) -> GameInstance:
	#print("Creating instance with Map: " + maps[map].key + ", Char: " + characters[character].key)
	var game_instance: GameInstance = get_instance()
	var chosen_character: Character = get_character()
	chosen_character.set_abilities(ability1, ability2, ability3)
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
	return load(characters[character].value).character_scene.instantiate()
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
func set_ability(ability: AbilityData):
	match ability.ability_number:
		1:
			ability1 = ability
			text_ability1.text = ability.ability_name
		2:
			ability2 = ability
			text_ability2.text = ability.ability_name
		3:
			ability3 = ability
			text_ability3.text = ability.ability_name
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
	abilities_selection.visible = false
	for node in nodes:
		node.visible = true
func _quickstart():
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

func play_button_sound():
	AudioManager.instance.play(AudioManager.instance.UI_PRESS, Vector2(0, 0))
