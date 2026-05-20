extends Upgrade
## This upgrade:
# Your projectiles gain 10% size and 25% duration
func activate(new_player: Character):
	UpgradeStatics.projectile_size_buff += projectile_size_buff
	UpgradeStatics.projectile_duration_buff += projectile_duration_buff
	super(new_player)
func deactivate():
	UpgradeStatics.projectile_size_buff -= projectile_size_buff
	UpgradeStatics.projectile_duration_buff -= projectile_duration_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const projectile_duration_buff: int = 25
const projectile_size_buff: int = 10
