extends Control
class_name HUD
const GROW_BAR = preload("uid://b18b5v5lx44ak")
## Upgrade UI
@onready var upgrade_cooldowns: GridContainer = $UpgradeCooldowns
@onready var upgrade_bars: VBoxContainer = $UpgradeBars
var upgrade_bars_list: Array[GrowBar]
## Labels
@onready var silver: Label = $Labels/Silver
@onready var money: Label = $Labels/Money
@onready var kills: Label = $Labels/Kills
@onready var time: Label = $Time
## Grow Bars
@onready var hp: GrowBar = $hp
@onready var shield: GrowBar = $shield
@onready var xp: GrowBar = $xp
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
