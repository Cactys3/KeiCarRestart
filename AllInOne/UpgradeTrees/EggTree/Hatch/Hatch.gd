extends Upgrade
## This upgrade:
#
var egg_upgrade: EggUpgrade
const egg_name: String = "Egg"
var hatched: bool = false

func activate(new_player: Character):
	super(new_player)
	egg_upgrade = find_upgrade(egg_name)
	hatch()
func hatch():
	if !hatched:
		if egg_upgrade:
			hatched = true
			egg_upgrade.emit_cooldown_finished()
			egg_upgrade.cooldownUI.queue_free()
		else:
			printerr("Couldn't fulfill Hatch upgrade's purpose because can't find Egg upgrade")
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
