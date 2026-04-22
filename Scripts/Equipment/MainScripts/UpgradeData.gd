extends Resource
class_name UpgradeData
@export var scene: PackedScene
@export var save_key: String = "unset"
@export var upgrade_name: String
@export_multiline("Description") var upgrade_description: String
@export var upgrade_color: Color = Color.DARK_SLATE_BLUE
@export var upgrade_image: Texture2D 
@export var upgrade_rarity: Upgrade.UpgradeRarities = Upgrade.UpgradeRarities.unset
@export var prerequisite_upgrades: Array[UpgradeData]
@export var decedent_upgrades: Array[UpgradeData]
@export var upgrades_to_overwrite_functionality: Array[UpgradeData]
## This must be a string value of the upgrade's names because if two upgrades disable each other
# we get compiling looping reference errors
@export var disable_upgrades_names: Array[String] 
## Prereq other Upgrades tags
@export_group("Prereqs")
@export var prereq_num_of_projectile_upgrades: int = 0
@export var prereq_num_of_creation_upgrades: int = 0
@export var prereq_num_of_summons_upgrades: int = 0
@export var prereq_num_of_traps_upgrades: int = 0
@export var prereq_num_of_burn_upgrades: int = 0
@export var prereq_num_of_poison_upgrades: int = 0
@export var prereq_num_of_bleed_upgrades: int = 0
@export var prereq_num_of_frost_upgrades: int = 0
@export var prereq_num_of_shock_upgrades: int = 0
@export var prereq_num_of_wet_upgrades: int = 0
@export var prereq_num_of_dodge_upgrades: int = 0
@export var prereq_num_of_magical_upgrades: int = 0
@export var prereq_num_of_blunt_upgrades: int = 0
@export var prereq_num_of_player_buffs_upgrades: int = 0
@export var prereq_num_of_weapon_buffs_upgrades: int = 0
@export var prereq_num_of_projectile_buffs_upgrades: int = 0
@export var prereq_num_of_summon_buffs_upgrades: int = 0
@export var prereq_num_of_creation_buffs_upgrades: int = 0
@export var prereq_num_of_trap_buffs_upgrades: int = 0
## Tags this upgrade has
@export_group("Upgrade Tags")
## Buffs
#@export_placeholder("Buffs Player") var Buffs_Player: String
@export_subgroup("Buffs")
@export var gives_player_buff: bool = false
@export var gives_player_stats: bool = false
@export var gives_weapon_stats: bool = false
@export var gives_projectiles_stats: bool = false
@export var gives_creations_stats: bool = false
@export var gives_summons_stats: bool = false
@export var gives_traps_stats: bool = false
@export var makes_player_dodge: bool = false
## Give things Status
#@export_placeholder("Give things Status") var Give_things_Status: String
@export_subgroup("Give things Status")
@export var makes_main_weapon_do_status: bool = false
@export var makes_upgrade_projectiles_do_status: bool = false
@export var makes_creations_do_status: bool = false
## Spawn things
#@export_placeholder("Spawn Things") var Spawn_Things: String
@export_subgroup("Spawn Things")
@export var spawns_projectile: bool = false
@export var spawns_creation: bool = false
@export var spawns_summon: bool = false
@export var spawns_trap: bool = false
#@export_placeholder("Do things to enemies") var Do_Things_to_Enemies: String
@export_subgroup("Do things to enemies")
## Do things to enemies
@export var applies_burn: bool = false
@export var applies_poison: bool = false
@export var applies_bleed: bool = false
@export var applies_frost: bool = false
@export var applies_shock: bool = false
@export var applies_wet: bool = false
@export var fears_enemies: bool = false
@export var slows_enemies: bool = false
@export var stuns_enemies: bool = false
@export_subgroup("Vibes")
@export var is_magical: bool = false
@export var is_blunt: bool = false
## Returns a list with the data of all prerequisite required upgrades to obtain this upgrade
func get_prereqs() -> Array[UpgradeData]:
	return prerequisite_upgrades
## Returns a list with the data of all upgrades this upgrade is a prereq for 
func get_decedent_upgrades() -> Array[UpgradeData]:
	return decedent_upgrades
## Checks if all the preqreq upgrades are obtained, if self is already obtained, if another upgrade disables self
func can_obtain(equipped_upgrades: Array[Upgrade]) -> bool:
	## If all prerequisite upgrades are obtained, return true
	var copy: Array[UpgradeData] = prerequisite_upgrades.duplicate()
	var prereq_projectile: int = prereq_num_of_projectile_upgrades
	var prereq_creation: int = prereq_num_of_creation_upgrades
	var prereq_summon: int = prereq_num_of_summons_upgrades
	var prereq_trap: int = prereq_num_of_traps_upgrades
	for upgrade in equipped_upgrades:
		## Check spawn prereqs
		if upgrade.data.spawns_projectile:
			prereq_projectile -= 1
		if upgrade.data.spawns_creation:
			prereq_creation -= 1
		if upgrade.data.spawns_summon:
			prereq_summon -= 1
		if upgrade.data.spawns_trap:
			prereq_trap -= 1
		## You can only have one upgrade that makes main weapon do status effects
		if upgrade.data.makes_main_weapon_do_status && makes_main_weapon_do_status:
			return false
		## You can only have one upgrade that makes upgrade projectiles do status effects
		if upgrade.data.makes_upgrade_projectiles_do_status && makes_upgrade_projectiles_do_status:
			return false
		## You can only have one upgrade that makes creations do status effects
		if upgrade.data.makes_creations_do_status && makes_creations_do_status:
			return false
		## If already obtained self, return false 
		if upgrade.data == self:
			return false
		## If there's an upgrade obtained that disables this upgrade, return false
		if upgrade.data.disable_upgrades_names.has(upgrade_name):
			return false
		## Remove prereq upgrades until list is empty or left only with prereqs that aren't active
		if copy.has(upgrade.data):
			copy.erase(upgrade.data)
	## Returns if all prereqs were in equipped upgardes and enough upgrades of each type were in equipped
	return copy.is_empty() && (prereq_projectile + prereq_creation + prereq_summon + prereq_trap) <= 0
## Makes and returns the associated Upgrade scene for this data
func get_upgrade() -> Upgrade:
	var upgrade: Upgrade = scene.instantiate()
	upgrade.upgrades_to_overwrite_functionality = upgrades_to_overwrite_functionality
	upgrade.item_name = upgrade_name
	upgrade.item_description = upgrade_description
	upgrade.item_color = upgrade_color
	upgrade.upgrade_rarity = upgrade_rarity
	upgrade.data = self
	return upgrade

func is_unlocked() -> bool:
	if save_key == "unset":
		return true
	printerr("Save Key Unset for upgradedata: ", upgrade_name + " - ", resource_name)
	return bool(Save.get_runtime_data(TitleManager.file_slot, save_key))
