extends Upgrade
## This upgrade:
# Duplicate all of your summons
func activate(new_player: Character):
	UpgradeStatics.summon_count_buff += summon_count_buff
	super(new_player)
func deactivate():
	UpgradeStatics.summon_count_buff -= summon_count_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const summon_count_buff: int = 1
