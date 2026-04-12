extends TrapUpgrade
## This upgrade:
# Every 5 seconds, Spawn mines that explode when enemies walk over them
# Your everything you spawn lasts 10% longer
func activate(new_player: Character):
	spawn_with_cd = true
	spawn_every_seconds = 5
	UpgradeStatics.trap_duration_buff += duration_buffs
	UpgradeStatics.projectile_duration_buff += duration_buffs
	UpgradeStatics.creation_duration_buff += duration_buffs
	UpgradeStatics.summon_duration_buff += duration_buffs
	super(new_player)
func deactivate():
	UpgradeStatics.trap_duration_buff -= duration_buffs
	UpgradeStatics.projectile_duration_buff -= duration_buffs
	UpgradeStatics.creation_duration_buff -= duration_buffs
	UpgradeStatics.summon_duration_buff -= duration_buffs
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const duration_buffs: float = 10
