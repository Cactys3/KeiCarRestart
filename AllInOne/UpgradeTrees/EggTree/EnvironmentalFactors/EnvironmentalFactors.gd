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
			## Find the biggest status (ties chosen by random 50/50)
			var greatest_key: String = "wet"
			var greatest_value: int = -1
			for key in status_buffs:
				var value = status_buffs[key]
				if value > greatest_value or (value == greatest_value and randi() % 2 == 0):
					greatest_key = key
					greatest_value = value
			match greatest_key:
				"bleed":
					egg_upgrade.version = egg_upgrade.Versions.bleed
				"burn":
					egg_upgrade.version = egg_upgrade.Versions.burn
				"frost":
					egg_upgrade.version = egg_upgrade.Versions.frost
				"poison":
					egg_upgrade.version = egg_upgrade.Versions.poison
				"shock":
					egg_upgrade.version = egg_upgrade.Versions.shock
				"wet":
					egg_upgrade.version = egg_upgrade.Versions.wet
				_:
					printerr("Error matching Egg/EnvironementalFactor's status to a status, got: ", greatest_key)

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

var status_buffs: Dictionary = {
	"bleed": 0,
	"burn": 0,
	"frost": 0,
	"poison": 0,
	"shock": 0,
	"wet": 0}

func bleed_proc(bleed_damage: float, enemy: Enemy):
	super(bleed_damage, enemy)
	status_buffs["bleed"] += 1
func frost_proc(frost_damage: float, enemy: Enemy):
	super(frost_damage, enemy)
	status_buffs["frost"] += 1
func poison_proc(poison_damage: float, enemy: Enemy):
	super(poison_damage, enemy)
	status_buffs["poison"] += 1
func wet_proc(wet_damage: float, enemy: Enemy):
	super(wet_damage, enemy)
	status_buffs["wet"] += 1
func shock_proc(shock_damage: float, enemy: Enemy):
	super(shock_damage, enemy)
	status_buffs["shock"] += 1
func burn_proc(burn_damage: float, enemy: Enemy):
	super(burn_damage, enemy)
	status_buffs["burn"] += 1
