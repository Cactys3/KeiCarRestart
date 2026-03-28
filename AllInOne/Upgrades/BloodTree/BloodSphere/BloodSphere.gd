extends SpawningUpgrade
## This upgrade:
#
## Set Vars
func _ready() -> void:
	spawn_projectiles = true
	spawn_on_reload = true
	scene_to_spawn = SCENE
	homing = true
	homing_speed = 20
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	buff_applied = true
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, bleed_factor_buff)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	check_remove()
	super()
const SCENE = preload("uid://hwgphgu8fcjy")
const bleed_factor_buff: float = 0.15
var buff_applied: bool = false
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		check_remove()
func check_remove():
	if buff_applied:
		GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, -bleed_factor_buff)
		buff_applied = false
