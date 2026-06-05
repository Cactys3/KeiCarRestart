extends Upgrade
## This upgrade:
#
var egg_upgrade: EggUpgrade
const egg_name: String = "Egg"
var hatched: bool = false
var additional_movespeed: float = 0
var additional_velocity: float = 0
var additional_piercing: float = 0
var additional_ammo: float = 0
var additional_count: float = 0
func activate(new_player: Character):
	super(new_player)
	egg_upgrade = find_upgrade(egg_name)
	egg_upgrade.cooldown_finished.connect(hatch)
func hatch():
	if !hatched:
		if egg_upgrade:
			hatched = true
			## Check how many of each thing are alive
			## at 10, gain 20 additional
			additional_movespeed += get_tree().get_node_count_in_group("creation") * 2
			## at 10, gain 30 additional 
			additional_velocity += get_tree().get_node_count_in_group("projectile") * 3
			## at 10, gain 10 additional 
			additional_piercing += get_tree().get_node_count_in_group("summon") 
			## at 10, gain 5 additional 
			additional_ammo += ceil(get_tree().get_node_count_in_group("trap") * 0.5)
			## at 10, gain 10 additional
			additional_count += get_tree().get_node_count_in_group("weapon")
			## Add Stats
			egg_upgrade.additional_movespeed += additional_movespeed
			egg_upgrade.additional_velocity += additional_velocity
			egg_upgrade.additional_piercing += additional_piercing
			egg_upgrade.additional_ammo += additional_ammo
			egg_upgrade.additional_count += additional_count

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
