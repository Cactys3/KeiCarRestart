extends Control
class_name HUD
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
