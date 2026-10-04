extends Control
class_name UIManager
## Sheets
@export var upgrade_sheet: UpgradeSheet
@export var character_sheet: CharacterSheet
## Tutorial Or Stats
@export var stats: Control
@export var tutorial: Control
@export var TutorialOrStatsButton: Button
var tutorial_or_stats: bool = true
## Labels
@export var money_label: Label
@export var xp_label: Label
@export var level_label: Label
@export var hp_label: Label
@export var fps_label: Label
@export var stopwatch_label: Label
@export var enemies_killed_label: Label
@export var bosses_killed_label: Label
@export var you_win: RichTextLabel
@export var you_lose: RichTextLabel
## Parents
@export var tab_menu_parent: Control
@export var esc_menu_parent: Control
@export var level_up_parent: Control
@export var static_ui_parent: Control
@export var misc_parent: Control
@export var relative_to_game_parent: Control
@export var top_level_labels_parent: Control
@export var upgrade_parent: Control
## Inventories
## Other
@export var hud: HUD
var enabled: bool = true
signal delete_proximity
func _ready() -> void:
	call_deferred("_connect_signals")
	process_mode = Node.PROCESS_MODE_ALWAYS
	if tab_menu_parent.visible:
		tab_menu_parent.visible = false
	if esc_menu_parent.visible:
		esc_menu_parent.visible = false
	if misc_parent.visible:
		misc_parent.visible = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(InputManager.SETTINGS_MENU):
		escape_pressed()
	if Input.is_action_just_pressed(InputManager.GAMEPLAY_MENU):
		tab_pressed()
func _connect_signals():
	pass#GameManager.instance.toggle_inventory.connect(toggle_inventory)
## Pause Queue
class PauseItem:
	func _init(UnpauseMethod: Callable, PauseType: PauseTypes, CanEscape: bool, ShowTab: bool, PauseParent: Control) -> void:
		unpause_method = UnpauseMethod
		type = PauseType
		can_escape = CanEscape
		show_tab = ShowTab
		pause_parent = PauseParent
	enum PauseTypes {gameplay, ui, level, tab, escape, system}
	var unpause_method: Callable
	var type: PauseTypes
	var can_escape: bool 
	var show_tab: bool
	var pause_parent: Control
	func get_priority() -> int:
		return type
var PauseQueue: Array[PauseItem]
var current_pause_item: PauseItem = null
## Pause Bools
var paused: bool = false ## Is Game Instance Paused or Not
var paused_for_esc: bool = false
var paused_for_tab: bool = false
var paused_for_level_up: bool = false
var paused_for_proximity: bool = false
var paused_for_misc: bool = false
## Pause Methods
## Called when Escape is pressed
func escape_pressed():
	if current_pause_item == null:
		## If no current pause, simply pause for escape menu
		print("current_pause_item == null")
		PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.escape, true, false, esc_menu_parent))
		next_pause_or_unpause()
	else:
		print("current_pause_item != null")
		if current_pause_item.can_escape:
			## If pressing escape should escape current pause, escape current pause
			print("current_pause_item.can_escape:")
			next_pause_or_unpause()
		else:
			print("!current_pause_item.can_escape:")
			## Press Esc while smth of lower priority is active = queue the other thing after new Esc pause
			PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.escape, true, false, esc_menu_parent))
			PauseQueue.append(current_pause_item)
			next_pause_or_unpause()
## Called when Escape is pressed
func tab_pressed():
	if current_pause_item == null:
		## If no current pause, simply pause for tab menu
		PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.tab, true, false, tab_menu_parent))
		next_pause_or_unpause()
	else:
		if PauseItem.PauseTypes.tab == current_pause_item.get_priority():
			## Press Tab while Tab is active = Deactivate Tab
			next_pause_or_unpause()
		elif PauseItem.PauseTypes.tab > current_pause_item.get_priority():
			## Press Tab while smth of lower priority is active = queue the other thing after tab
			if !current_pause_item.show_tab: ## And we aren't already showing tab
				PauseQueue.append(PauseItem.new(Callable(), PauseItem.PauseTypes.tab, true, false, tab_menu_parent))
				PauseQueue.append(current_pause_item)
				next_pause_or_unpause()
		else:
			pass ## Do Nothing if we are lower priority, don't want to queue a bunch of tab pauses
## Called when pausing for a given pause_item
func pause(pause_item: PauseItem):
	## We add the pause item to queue in all cases
	PauseQueue.append(pause_item)
	if current_pause_item == null:
		## If no current pause, simply pause for new pause_item
		next_pause_or_unpause()
	else:
		if PauseItem.PauseTypes.tab > current_pause_item.get_priority():
			## Pause while smth of lower priority is active = queue the other thing after new pause
			PauseQueue.append(current_pause_item)
			next_pause_or_unpause()
		else:
			pass ## We already Queued the pause item
## Called when wishing to unpause, checks PauseQueue first
func next_pause_or_unpause():
	if GameInstance.is_game_over:
		return
	if current_pause_item:
		current_pause_item.pause_parent.visible = false
		current_pause_item.pause_parent.propagate_call("set", ["process_mode", PROCESS_MODE_DISABLED])
		## If PauseQueue.has(current_pause_item), then that pause isn't removed, just postponed, so don't call it's 'delete pause' method
		if !PauseQueue.has(current_pause_item) && current_pause_item.unpause_method != null && current_pause_item.unpause_method.is_valid():
			current_pause_item.unpause_method.call()
		current_pause_item = null
	if PauseQueue.is_empty():
		GameManager.instance.pause(false)
		tab_menu_parent.visible = false ## always hide tab because some pauses show it 
	else:
		var priority_item = PauseQueue[0]
		for item in PauseQueue:
			if item.get_priority() > priority_item.get_priority():
				priority_item = item
		priority_item.pause_parent.visible = true
		priority_item.pause_parent.propagate_call("set", ["process_mode", PROCESS_MODE_ALWAYS])
		current_pause_item = priority_item
		if current_pause_item.show_tab:
			tab_menu_parent.visible = true
			tab_menu_parent.propagate_call("set", ["process_mode", PROCESS_MODE_ALWAYS])
		if current_pause_item.pause_parent.get_parent() == self:
			## Maybe this is good, or maybe they should have permanent heiarchy.
			#move_child(current_pause_item.pause_parent, max(0, get_child_count() - 1))
			pass
		PauseQueue.erase(priority_item)
		GameManager.instance.pause(true)
## Called to unpause or remove pause_item from PauseQueue
func unpause(pause_item: PauseItem):
	if pause_item == null:
		return
	if current_pause_item == pause_item:
		current_pause_item = null
		next_pause_or_unpause()
	elif PauseQueue.has(pause_item):
		PauseQueue.erase(pause_item)
func set_level(value: String) -> void:
	level_label.text = value
func set_max_hp(value: float) -> void:
	hud.set_max_hp(value)
func set_max_shield(value: float) -> void:
	hud.set_max_shield(value)
func set_shield(value: float) -> void:
	hud.set_shield(value)
func set_hp(value: float) -> void:
	hp_label.text = str(round(value))
	hud.set_hp(value)
func finished_level_up() -> void:
	hud.set_xp_visible(false)
func set_xp(text: String, value: float) -> void:
	#print("xp: ", text, ", ", value)
	xp_label.text = text
	## XP uses xp percent
	hud.set_xp(value)
func set_money(value: float) -> void:
	money_label.text = str(roundi(value))
	hud.set_money(value)
func set_stopwatch(value: float) -> void:
	stopwatch_label.text = str(int(value / 60)) + ":" + str(int(fmod(value, 60.0)))
	hud.set_time(value)
func set_kills(value: float) -> void:
	hud.set_kills(value)
	enemies_killed_label.text = str(value)
func set_fps(value: float) -> void:
	fps_label.text = str(roundi(value))
func toggle_you_win(value: bool) -> void:
	you_win.visible = value
func toggle_you_lose(value: bool) -> void:
	you_lose.visible = value
## Adds the weapon to the UI which displays weapons
func add_weapon(weapon: Weapon):
	## Basic adding image of thing ## TODO: make real ui 
	var image: TextureRect = TextureRect.new()
	if weapon.item_image != null:
		image.texture = weapon.item_image
	else:
		image.texture = load("uid://b7v3ge0yvguti")
	var label: Label
	if weapon.item_name != "":
		label = Label.new()
		label.text = weapon.item_name
	else:
		label = Label.new()
		label.text = weapon.item_name
	upgrade_parent.add_child(image)
	image.add_child(label)
## Adds the upgrade to the UI which displays upgrades
func add_upgrade(upgrade: Upgrade):
	## Basic adding image of thing ## TODO: make real ui 
	var image: TextureRect = TextureRect.new()
	if upgrade.item_image != null:
		image.texture = upgrade.item_image
	else:
		image.texture = load("uid://b7v3ge0yvguti")
	var label: Label
	if upgrade.item_name != "":
		label = Label.new()
		label.text = upgrade.item_name
	else:
		label = Label.new()
		label.text = upgrade.item_name
	upgrade_parent.add_child(image)
	image.add_child(label)
	## Add the real upgrade UI
	upgrade_sheet.add_upgrade(upgrade.data)
func _on_tutorial_or_stats_pressed() -> void:
	tutorial_or_stats = !tutorial_or_stats
	if tutorial_or_stats:
		TutorialOrStatsButton.text = "Show Stats"
		tutorial.visible = true
		stats.visible = false
	else:
		TutorialOrStatsButton.text = "Show Tutorial"
		tutorial.visible = false
		stats.visible = true
func setup_cooldown_ui(is_upgrade: bool, is_ability: bool, text_on_hover: String, color: Color, thumbnail: Texture2D) -> CooldownUI:
	var cooldownUI: CooldownUI = preload("uid://brjmxsn8spmpe").instantiate()
	if is_upgrade:
		hud.add_upgrade_cooldown_ui(cooldownUI)
	if is_ability:
		hud.add_ability_cooldown_ui(cooldownUI)
	cooldownUI.setup(text_on_hover, color, thumbnail)
	return cooldownUI
