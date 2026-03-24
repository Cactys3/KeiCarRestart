extends Resource
class_name UpgradeData
@export var scene: PackedScene
@export var save_key: String = "unset"
@export var upgrade_name: String
@export var upgrade_description: String
@export var upgrade_color: Color = Color.DARK_SLATE_BLUE
@export var upgrade_image: Texture2D 
@export var upgrade_rarity: Upgrade.UpgradeRarities = Upgrade.UpgradeRarities.unset
@export var prerequisite_upgrades: Array[UpgradeData]
@export var decedent_upgrades: Array[UpgradeData]
## Upgrades that this upgrade disables obtaining
@export var disable_upgrades: Array[UpgradeData]
## Returns a list with the data of all prerequisite required upgrades to obtain this upgrade
func get_prereqs() -> Array[UpgradeData]:
	return prerequisite_upgrades
## Returns a list with the data of all upgrades this upgrade is a prereq for 
func get_decedent_upgrades() -> Array[UpgradeData]:
	return decedent_upgrades
## Checks if all the preqreq upgrades are obtained, if self is already obtained, if another upgrade disables self
func can_obtain(equipped_upgrades: Array[Upgrade]) -> bool:
	## If already obtained self, return false
	if equipped_upgrades.has(self):
		return false
	## If all prerequisite upgrades are obtained, return true
	var copy: Array[UpgradeData] = prerequisite_upgrades.duplicate()
	for upgrade in equipped_upgrades:
		## If there's an upgrade obtained that disables this upgrade, return false
		if upgrade.data.disable_upgrades.has(self):
			return false
		if copy.has(upgrade.data):
			copy.erase(upgrade.data)
	return copy.is_empty()
## Makes and returns the associated Upgrade scene for this data
func get_upgrade() -> Upgrade:
	var upgrade: Upgrade = scene.instantiate()
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
