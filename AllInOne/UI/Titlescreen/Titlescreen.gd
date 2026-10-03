extends Node
#class_name TitleManager
@onready var audio_manager: AudioManager = $"../AudioManager"
## Selections
@onready var character_selection: GridContainer = $SelectionsPage/CharacterSelection
@onready var weapon_selection: GridContainer = $SelectionsPage/WeaponSelection
@onready var map_selection_parent: TextureRect = $SelectionsPage/MapSelectionParent
@onready var map_selection: HBoxContainer = $SelectionsPage/MapSelectionParent/ScrollContainer/MapSelection
@onready var scroll_container: ScrollContainer = $SelectionsPage/MapSelectionParent/ScrollContainer
@onready var start_game_button: TextureRect = $SelectionsPage/EmbarkOutline
@onready var character_option: TextureRect = $SelectionsPage/CharacterOption
@onready var weapon_option: TextureRect = $SelectionsPage/WeaponOption

## Pages
@onready var start_page: Control = $StartPage
var settings_page: Control
var collections_page: Control
@onready var selections_page: Control = $SelectionsPage

const SELECTION_OPTION = preload("uid://7agjses182bt")
const MAP_OPTION = preload("uid://dhecocpqq2dd7")

enum screens {title, settings, collection, map, character, weapon, abilities}
var current_screen: screens = screens.title
var previous_screens: Array[screens]

static var file_slot: int = 0
const BaseScene: String = "res://Scenes/Main/BaseScene.tscn"
## Instances
var TEST = preload("uid://6rr4rk82t1jk")
var DARKFOREST = preload("uid://bdfkg05dhqxwy")
var HELL = preload("uid://6qybeb73ksh0")
var FRUITSANDVEGGIES = preload("uid://ccidnfrdxi1ap")
## Characters [global_stats][character scene]
var WEBFISHER = preload("uid://c8bqja567m367")
var LILY = preload("uid://cceu21txmlm84")
var OMI = preload("uid://bkf2gykr0mhbs")
## Weapons
var BOXING_GLOVE = preload("uid://cq5nhmlksnt4w")
var PISTOL = preload("uid://cekjsgpmxcbxn")
var SHOTGUN = preload("uid://b1piik111lyye")
var SHURIKEN = preload("uid://csgjy43t3xrnb")
## Choice Variables
var character: int = 1 ## Chosen character
var map: int = 1 ## Chosen map
var weapon: int = 1 ## Chosen weapon
var ability1: AbilityData = null
var ability2: AbilityData = null
var ability3: AbilityData = null
var characters: Array[CharacterData] = [LILY, OMI, WEBFISHER]
var maps: Array[MapData] = [TEST, DARKFOREST, HELL, FRUITSANDVEGGIES, TEST, DARKFOREST, HELL, FRUITSANDVEGGIES]
var weapons: Array[WeaponData] = [BOXING_GLOVE, PISTOL, SHOTGUN, SHURIKEN]
var array: Array[Control] = []
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
	
	## Set Visible
	set_page(start_page)
	set_selection(null)
	start_game_button.visible = false
	character_option.visible = false
	weapon_option.visible = false
	var stylebox1: StyleBoxEmpty = StyleBoxEmpty.new()
	var stylebox2: StyleBoxFlat = StyleBoxFlat.new()
	var stylebox3: StyleBoxFlat = StyleBoxFlat.new()
	stylebox2.bg_color = Color("7e7e7e")
	stylebox3.bg_color = Color("e3e3e3")
	var bar := scroll_container.get_h_scroll_bar()
	bar.custom_minimum_size += Vector2(0, 6)
	bar.add_theme_stylebox_override("scroll", stylebox1)
	bar.add_theme_stylebox_override("grabber", stylebox2)
	bar.add_theme_stylebox_override("grabber_highlight", stylebox3)
	bar.add_theme_stylebox_override("grabber_pressed", stylebox3)
	## TODO: Make the sides of the 'scroll' seperate from the main scroll sprite
	## Then Put the sides so they appear on top of everything else (including the scroll bar and contents)
	## Would give a nice Effect
	
	## Setup Selection Screens (except abilities)
	for c in characters:
		var option = SELECTION_OPTION.instantiate()
		character_selection.add_child(option)
		option.button.pressed.connect(set_character.bind(characters.find(c)))
		if c.icon:
			option.icon.texture = c.icon
	for m in maps:
		var option = MAP_OPTION.instantiate()
		map_selection.add_child(option)
		if m.map_thumbnail:
			option.map_thumbnail = m.map_thumbnail
		option.label.text = m.map_name
		option.button.pressed.connect(set_map.bind(maps.find(m)))
	for w in weapons:
		var option = SELECTION_OPTION.instantiate()
		weapon_selection.add_child(option)
		option.button.pressed.connect(set_weapon.bind(weapons.find(w)))
		if w.icon:
			option.icon.texture = w.icon
	## Make sure file is created
	call_deferred("save")
func save():
	if !Save.check_save_data(0):
		Save.create_file(0)
	Save.load_file(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(previous_screens)
	pass
### UI Code
## Return to previous screen
func press_back() -> void:
	if previous_screens.size() > 0:
		var screen = previous_screens[previous_screens.size() - 1]
		go_to_screen(screen)
		## Don't call changed_screens bc that adds to previous_screens
		current_screen = screen
		previous_screens.remove_at(previous_screens.size() - 1)
		play_button_sound()
	else:
		pass ## TODO: play failed button
	## Return to the previous selection (or to main menu)
## Go to Character Selection
func press_play() -> void:
	play_button_sound()
	set_page(selections_page)
	## Setup Character Select
	set_selection(character_selection)
	changed_screens(screens.character)
## Go to Settings
func press_settings() -> void:
	play_button_sound()
## Go to Collection
func press_collection() -> void:
	play_button_sound()
## Go to Powers (shop)
func press_powers() -> void:
	play_button_sound()
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
	return maps[map].map_scene.instantiate()
func get_character() -> Character:
	return characters[character].character_scene.instantiate()
func get_weapon() -> String:
	return weapons[weapon].weapon_name
func set_map(index: int):
	if maps.size() > index:
		map = index
	## Map set, Show start game button
	start_game_button.visible = true
func set_character(index: int):
	if characters.size() > index:
		character = index
		if characters[index] && characters[index].icon:
			character_option.icon.texture = characters[index].icon
			character_option.visible = true
	## Character set, move on to weapons
	set_selection(weapon_selection)
	changed_screens(screens.weapon)
func set_ability(ability: AbilityData):
	match ability.ability_number:
		1:
			ability1 = ability
		2:
			ability2 = ability
		3:
			ability3 = ability
func set_weapon(index: int):
	if weapons.size() > index:
		weapon = index
		if weapons[index] && weapons[index].icon:
			weapon_option.icon.texture = weapons[index].icon
			weapon_option.visible = true
	## Weapon set, move on to maps
	set_selection(map_selection_parent)
	changed_screens(screens.map)
func set_page(page: Control):
	start_page.visible = false
	selections_page.visible = false
	if page != null:
		page.visible = true
func set_selection(selection: Control):
	character_selection.visible = false
	map_selection_parent.visible = false
	weapon_selection.visible = false
	if selection != null:
		selection.visible = true
## Keep Track of Screen History
func changed_screens(screen: screens):
	previous_screens.append(current_screen)
	current_screen = screen
func go_to_screen(screen: screens):
	match screen:
		screens.title:
			set_page(start_page)
			set_selection(null)
		screens.settings:
			set_page(settings_page)
			set_selection(null)
		screens.collection:
			set_page(collections_page)
			set_selection(null)
		screens.map:
			set_page(selections_page)
			set_selection(map_selection_parent)
		screens.character:
			set_page(selections_page)
			set_selection(character_selection)
		screens.weapon:
			set_page(selections_page)
			set_selection(weapon_selection)
		screens.abilities:
			pass

func _quickstart():
	character = characters.find(LILY)
	weapon = weapons.find(PISTOL)
	map = maps.find(HELL)
	for a in characters[character].abilities:
		if a.ability_number == 1:
			ability1 = a
		elif a.ability_number == 2:
			ability2 = a
		elif a.ability_number == 3:
			ability3 = a
	press_start_game()

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
	var value: Variant
	func _init(new_key: String, new_value: Variant):
		key = new_key
		value = new_value
func _on_choose_0_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.

func play_button_sound():
	pass##AudioManager.instance.play(AudioManager.instance.UI_PRESS, Vector2(0, 0))
