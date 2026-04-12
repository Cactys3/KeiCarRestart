extends ProjectileUpgrade
## This upgrade:
#
## Set Vars
func _ready() -> void:
	spawn_on_reload = true
	scene_to_spawn = SCENE
	homing = true
	homing_speed = 20
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, bleed_factor_buff)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, -bleed_factor_buff)
	super()
const SCENE = preload("uid://hwgphgu8fcjy")
const bleed_factor_buff: float = 0.15
