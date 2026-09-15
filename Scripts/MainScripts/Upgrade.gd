extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## variables set in ready() method or by UpgradeData
const COOLDOWN_UI = preload("uid://brjmxsn8spmpe")

## Booleans that say what this upgrade does
## Should attacks be passed through this upgrade before being sent to enemy
@export var edits_attack: bool = false
@export var edits_incoming_attack: bool = false
@export var has_meter: bool = false
## Variables given by UpgradeData
var spawns_projectile: bool = false
var spawns_summon: bool = false
var spawns_creation: bool = false
var spawns_trap: bool = false
var upgrades_to_overwrite_functionality: Array[UpgradeData]
var upgrade_rarity: Upgrade.UpgradeRarities = UpgradeRarities.unset
enum UpgradeRarities {unset, Basic, Intermediate, Advanced, Exclusive}
const BASIC_COLOR: Color = Color.RED
const INTERMEDIATE_COLOR: Color = Color.BLUE
const ADVANCED_COLOR: Color = Color.REBECCA_PURPLE
const EXCLUSIVE_COLOR: Color = Color.LIGHT_GOLDENROD
var data: UpgradeData
## Disable all functions 
var disabled_by_inherited_upgrade: bool = false
## Called whenever an upgrade cooldown finishes, may be called for multiple cooldowns on one Upgrade
signal cooldown_finished
## Check to remove buffs or other stuff on leaving scene
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		check_remove()
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	if !disabled_by_inherited_upgrade && active:
		if has_custom_input && assigned_input != "" && Input.is_action_just_pressed(assigned_input):
			custom_input_just_pressed()
		if buff_applied && buff_time_left > 0:
			buff_time_left -= delta
		else:
			check_remove()
## Override below
## Enables the functionality of this upgrade
func activate(new_player: Character):
	var upgrades_found: Array[UpgradeData] = upgrades_to_overwrite_functionality
	for upgrade in GameManager.instance.active_upgrades:
		if upgrades_to_overwrite_functionality.has(upgrade.data):
			disable_upgrade(upgrade)
			upgrades_found.erase(upgrade.data)
	if !upgrades_found.is_empty():
		var error = ""
		for upgrade in upgrades_found:
			error += str("Couldn't Find ", upgrade.upgrade_name, " to disable them (from ", data.upgrade_name, ")\n")
		printerr(error)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	check_remove()
	super()
## Overwrite so you can access upgrade data before disabling them
func disable_upgrade(upgrade: Upgrade):
	upgrade.disable_by_inherited(self)
func disable_by_inherited(inherited_upgrade: Upgrade):
	disabled_by_inherited_upgrade = true
	deactivate()
## Override method to edit an attack and return
func edit_attack(attack: Attack) -> Attack:
	return attack
## Override method to edit an attack and return (with enemy)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return attack
## Override method to edit an attack from an enemy to the player
func edit_incoming_attack(attack: Attack, enemy: Enemy, character: Character) -> Attack:
	return attack
## Overide method to edit the list of stats
func edit_stats():
	pass
var buff_time_left: float = 0
var buff_applied: bool = false
## Checks if a buff is applied and calls remove_buff()
func check_remove():
	if buff_applied:
		remove_buff()
func remove_buff():
	buff_applied = false
func apply_buff():
	buff_applied = true
func add_to_buff_time(value: float):
	buff_time_left += value + Statics.upgrade_buff_duration_buff
func find_upgrade(upgrade_name: String) -> Upgrade:
	for upgrade in GameManager.instance.active_upgrades:
		if upgrade.data.upgrade_name == upgrade_name:
			return upgrade
	return null
func emit_cooldown_finished():
	GameManager.instance.UpgradeCooldownFinished.emit(self)
	cooldown_finished.emit()
func custom_input_just_pressed():
	pass
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
func get_attack_source() -> Attack.AttackSources:
	return Attack.AttackSources.upgrade
## Creations send back their damage returns
func creation_damage_return(damage_return: Enemy.DamageReturn):
	total_damage += damage_return.total_damage_dealt
	if damage_return.killed:
		units_killed += 1
