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
func player_heal(heal_amount: float, heal_type: GameManager.HealTypes):
	## Damage an enemy based on heal
	if heal_type == GameManager.HealTypes.regen:
		last_heal = heal_amount
		spawn()
	super(heal_amount, heal_type)
## Pass in heal to the custom projectile script
func initialize_projectile(projectile: Projectile) -> Projectile:
	projectile._damage += last_heal * 10
	projectile._piercing += max(0, floor(player.regen / 5))
	return super(projectile)
