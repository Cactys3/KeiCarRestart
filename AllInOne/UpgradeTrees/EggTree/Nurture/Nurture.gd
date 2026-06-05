extends Upgrade
## This upgrade:
#
var egg_upgrade: EggUpgrade
const egg_name: String = "Egg"
var hatched: bool = false
func activate(new_player: Character):
	super(new_player)
	egg_upgrade = find_upgrade(egg_name)
	egg_upgrade.cooldown_finished.connect(hatch)
func hatch():
	if !hatched:
		if egg_upgrade:
			hatched = true
			egg_upgrade.additional_size += Statics.weapon_size_buff * Statics.weapon_size_factor
			egg_upgrade.additional_damage += Statics.weapon_damage_buff * Statics.weapon_damage_factor
			egg_upgrade.additional_velocity += Statics.weapon_velocity_buff * Statics.weapon_velocity_factor
			egg_upgrade.additional_count += Statics.weapon_count_buff * Statics.weapon_count_factor
			egg_upgrade.additional_attackspeed += Statics.weapon_attackspeed_buff * Statics.weapon_attackspeed_factor
			egg_upgrade.additional_inaccuracy += Statics.weapon_inaccuracy_buff * Statics.weapon_inaccuracy_factor
			egg_upgrade.additional_reloadtime += Statics.weapon_reloadtime_buff * Statics.weapon_reloadtime_factor
			egg_upgrade.additional_luck += Statics.weapon_luck_buff * Statics.weapon_luck_factor
			egg_upgrade.additional_critdamage += Statics.weapon_critdamage_buff * Statics.weapon_critdamage_factor
			egg_upgrade.additional_piercing += Statics.weapon_piercing_buff * Statics.weapon_piercing_factor
			egg_upgrade.additional_ammo += Statics.weapon_ammo_buff * Statics.weapon_ammo_factor
			egg_upgrade.additional_movespeed += Statics.weapon_movespeed_buff * Statics.weapon_movespeed_factor
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
