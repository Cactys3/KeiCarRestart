extends Upgrade
## This upgrade:
#
var egg_upgrade: EggUpgrade
const egg_name: String = "Egg"
var hatched: bool = false
var additional_size: float = 0
var additional_damage: float = 0
var additional_velocity: float = 0
var additional_count: float = 0
var additional_status: float = 0
var additional_attackspeed: float = 0
func activate(new_player: Character):
	super(new_player)
	egg_upgrade = find_upgrade(egg_name)
	egg_upgrade.cooldown_finished.connect(hatch)
func hatch():
	if !hatched:
		hatched = true
		if egg_upgrade:
			egg_upgrade.additional_size += additional_size
			egg_upgrade.additional_damage += additional_damage
			egg_upgrade.additional_velocity += additional_velocity
			egg_upgrade.additional_count += additional_count
			egg_upgrade.additional_status += additional_status
			egg_upgrade.additional_attackspeed += additional_attackspeed
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

## Add to stats on enemy killed
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	super(enemy, attack)
	if attack.is_melee():
		## At 100 it is 10 more attackspeed
		additional_attackspeed += 0.1
	elif attack.is_projectile():
		## At 100 it is 10 more damage
		additional_damage += 0.1
	elif attack.is_creation():
		## At 100 it is 50% bigger
		additional_size += 0.005
	elif attack.is_summon():
		## At 100 it is 20 more velocity
		additional_velocity += 0.2
	elif attack.is_trap():
		## at 100 it is 1 more count
		additional_count += 0.01
	elif attack.is_status():
		## at 100, it is 0.5 more apply for status
		additional_status += 0.005
	else:
		print("What status was this? lets check: ", attack.attack_type, ", ",  Attack.AttackTypes.values())
