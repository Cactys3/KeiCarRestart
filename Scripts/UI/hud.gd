extends Control
class_name HUD
const GROW_BAR = preload("uid://b18b5v5lx44ak")
const ASSIGNED_INPUT_UI = preload("uid://jpvvjna8n8bx")
## Upgrade UI
@export var upgrade_cooldowns: GridContainer
@export var upgrade_bars: VBoxContainer 
var upgrade_bars_list: Array[GrowBar]
@export var assigned_inputs: HBoxContainer
var assigned_inputs_list: Array[AssignedInputUI]
## Labels
@export var silver: Label
@export var money: Label
@export var kills: Label 
@export var time: Label 
## Grow Bars
@export var hp: GrowBar
@export var shield: GrowBar 
@export var xp: GrowBar 
## Sets XP: uniquely, the parameter is a percent, not a value
func set_xp(percent: float):
	xp.set_value_percent(percent)
func set_hp(value: float):
	hp.set_value(value)
func set_shield(value: float):
	shield.set_value(value)
func set_max_hp(value: float):
	hp.set_max(value)
func set_max_shield(value: float):
	shield.set_max(value)
func set_silver(value: float):
	silver.text = str(roundi(value))
func set_money(value: float):
	money.text = str(roundi(value))
func set_kills(value: float):
	kills.text = str(roundi(value))
func set_time(value: float):
	time.text = str(int(value / 60)) + ":" + str(int(fmod(value, 60.0)))
## Sets the xp's foreground bar's visible to value, used after finishing a level up (xp at 100%)
func set_xp_visible(value: bool) -> void:
	xp.set_foreground_visible(value)
## Pass a pre-setup CooldownUI and hud will add it visually
func add_upgrade_cooldown_ui(ui: CooldownUI):
	if ui:
		upgrade_cooldowns.add_child(ui)
## Add new Input UI
func add_assigned_input_ui(texture: Texture2D, input_name: String, slot: int):
	var ui: AssignedInputUI = ASSIGNED_INPUT_UI.instantiate()
	assigned_inputs_list.append(ui)
	assigned_inputs.add_child(ui)
	var place: int = 0
	for input_ui in assigned_inputs_list:
		if input_ui.slot > ui.slot:
			place = input_ui.get_index()
	assigned_inputs.move_child(ui, place)
	ui.setup(texture, input_name, slot)
## Sets up and returns a GrowBar for upgrades
func add_upgrade_bar_ui(foreground_color: Color) -> GrowBar:
	var bar: GrowBar = GROW_BAR.instantiate()
	## Do stuff before bar's ready() function
	if foreground_color != null:
		bar.foreground_color = foreground_color
	bar.use_custom_sizes = true
	## bars are same length as bar parent
	bar.start_max = upgrade_bars.size.x
	upgrade_bars.add_child(bar)
		## Do stuff after bar's ready() function
	bar.size_flags_vertical = Control.SIZE_FILL
	upgrade_bars_list.append(bar)
	return bar
## Sets all the bars lengths in case of resolution change
func set_upgrade_bars_length():
	for bar in upgrade_bars_list:
		## bars are same length as bar parent
		bar.start_max = upgrade_bars.size.x
