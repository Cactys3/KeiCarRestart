extends Control
class_name HUD
## Shield
@onready var shield: Panel = $Shield/Shield/Shield/Shield
@onready var shield_parent: Control = $Shield
## HP
@onready var hp_background: Panel = $HP/HP/HP_Background/HP_Background
@onready var hp: Panel = $HP/HP/HP_BAR/HP
@onready var hp_bar: HBoxContainer = $HP/HP/HP_BAR
## XP
@onready var xp: Panel = $XP/Offsets_X/XP/XP_BAR/XP_Middle
@onready var xp_background: Panel = $XP/Offsets_X/XP/XP_Background/XP_Middle
@onready var xp_bar: HBoxContainer = $XP/Offsets_X/XP/XP_BAR
## Labels
@onready var silver: Label = $Labels/Silver
@onready var money: Label = $Labels/Money
@onready var kills: Label = $Labels/Kills
@onready var time: Label = $Time
## Test
@onready var grow_bar: GrowBar = $TestGrowBar/GrowBar

## Variables, determined dynamically by the control nodes' stretching
var shield_ui_max_width: float:
	get():
		return hp_background.size.x
var hp_ui_max_width: float:
	get():
		if hp_background.size.x <= 0:
			return 141
		return hp_background.size.x
var xp_ui_max_width: float:
	get():
		return size.x - 45
## Variables, determined by values given via managers
var shield_max_width: float = 0
var hp_max_width: float = 0
var xp_max_width: float = 0
## Sets the width of the XP HUD, width grows with given value
func set_xp(value: float):
	xp_bar.visible = true
	## If value is maxxed out
	if value >= xp_max_width:
		## Value cannot go above max
		xp.custom_minimum_size.x = xp_max_width
		xp.size.x = xp_max_width
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	## If value is 0
	elif value <= 0.0:
		xp_bar.visible = false
	## If value is between 0 and max
	else:
		xp.custom_minimum_size.x = value
		xp.size.x = value
## Sets the width of the HP HUD, width grows with given value
func set_hp(value: float):
	grow_bar.set_value(value)
	hp_bar.visible = true
	## If value is maxxed out
	if value >= hp_max_width:
		## Value can go above max, consider changing the color for the 'above-max' portion
		hp.custom_minimum_size.x = value
		hp.size.x = value
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	## If value is 0
	elif value <= 0.0:
		hp_bar.visible = false
	## If value is between 0 and max
	else:
		hp.custom_minimum_size.x = value
		hp.size.x = value
## Sets the width of the Shield HUD, width grows with given value
func set_shield(value: float):
	shield_parent.visible = true
	#shield_bar.visible = true
	## If value is maxxed out
	if value >= shield_max_width:
		## Value can go above max, consider changing the color for the 'above-max' portion
		shield.custom_minimum_size.x = value
		shield.size.x = value
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	## If value is 0
	elif value <= 0.0:
		shield_parent.visible = false
		#shield_bar.visible = false
	## If value is between 0 and max
	else:
		shield.custom_minimum_size.x = value
		shield.size.x = value

## Sets the width of the HP background to match new value
func set_max_hp(value: float):
	if value >= 0:
		hp_max_width = value
		hp_bar.custom_minimum_size.x = value
		hp_bar.size.x = value
	else:
		printerr("trying to set maxhp lower than 1")
## Sets the width of the Shield background to match new value
func set_max_shield(value: float):
	pass
##
func set_silver(value: float):
	silver.text = str(roundi(value))
##
func set_money(value: float):
	money.text = str(roundi(value))
##
func set_kills(value: float):
	kills.text = str(roundi(value))
##
func set_time(value: float):
	time.text = str(int(value / 60)) + ":" + str(int(fmod(value, 60.0)))

## Sets XP to be a certian percent of a dynamically calculated max-width (doesn't expand max-width with larger xp value) 
func set_xp_percent(percent: float):
	xp_bar.visible = true
	if percent >= 1:
		xp.custom_minimum_size.x = xp_ui_max_width
		xp.size.x = xp_ui_max_width
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	elif percent == 0.0:
		xp_bar.visible = false
	else:
		xp.custom_minimum_size.x = percent * xp_ui_max_width
		xp.size.x = percent * xp_ui_max_width
## Sets HP to be a certian percent of a dynamically calculated max-width (doesn't expand max-width with larger hp value) 
func set_hp_percent(percent: float):
	hp_bar.visible = true
	if is_instance_valid(percent) || percent == NAN:
		hp_bar.visible = false
	elif percent >= 1:
		print("percent 1, setting width: ", hp_ui_max_width)
		hp.custom_minimum_size.x = hp_ui_max_width
		hp.size.x = hp_ui_max_width
		## TODO: play animation or smth, maybe different color if gaining 2 or more levels at once (percent > 2)
	elif percent <= 0:
		hp_bar.visible = false
	else:
		hp.custom_minimum_size.x = percent * hp_ui_max_width
		hp.size.x = percent * hp_ui_max_width
## Sets Shield to be a certian percent of a dynamically calculated max-width (doesn't expand max-width with larger shield value) 
func set_shield_percent(percent: float):
	shield_parent.visible = true
	#if percent >= 1:
		## TODO: when shield is greater than 1.0? add another line of shield? add another color of shield ontop?
	if percent <= 0:
		shield_parent.visible = false
	else:
		shield.custom_minimum_size.x = percent * shield_ui_max_width
		shield.size.x = percent * shield_ui_max_width
