extends ProjectileUpgrade
## This upgrade:
#
## Set Vars
func _ready() -> void:
	spawn_on_reload = true
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, bleed_factor_buff)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, -bleed_factor_buff)
	super()
const bleed_factor_buff: float = 0.15

func spawn() -> bool:
	var ret = super()
	print("Spawn!, ", ret )
	return ret

func initialize_projectile(projectile: Projectile) -> Projectile:
	var ret = super(projectile)
	print("Spawn!, ", ret )
	return ret
