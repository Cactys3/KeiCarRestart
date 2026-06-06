extends ProjectileUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)
func apply_buff():
	super()
func remove_buff():
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

## Gain chance to spread shock based on current shield value, scaling up to 100% chance
var shock_chance: float:
	get():
		return clamp(GameManager.instance.shield, 0, 1)

func shock_proc(shock_damage: float, enemy: Enemy):
	if shock_chance > randf():
		spread_shock(shock_damage, enemy)
## Spawns a node that determines if shock can be spread and to what nearby things it will spread to
func spread_shock(shock_damage: float, enemy: Enemy):
	## set projectile spawn to be ontop of enemy position
	## Get list of nearby enemies 
	## Set projectile target to be a random one of those enemies
	## Spawn projectile and tell it how many shocks have jumped before it to use to chance calculation
	## On projectile hits, kill projectile and use shock_chance divided by number of jumps to determine if it should jump again
	pass
