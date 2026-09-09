extends ProjectileUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()

var last_heal: float = 1
const heal_damage_multiplier: float = 4
## Spawn a projectile on regen
func player_heal(heal: float, is_regen: bool):
	## Damage an enemy based on heal
	if is_regen:
		last_heal = heal
		spawn()
	super(heal, is_regen)
## Pass in heal to the custom projectile script
func initialize_projectile(projectile: Projectile) -> Projectile:
	projectile.set_heal(last_heal)
	return super(projectile)
