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
