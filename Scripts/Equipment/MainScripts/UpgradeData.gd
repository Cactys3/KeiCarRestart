extends Resource
class_name UpgradeData
@export var scene: PackedScene
@export var upgrade_name: String
@export var upgrade_description: String
@export var prerequisite_upgrades: Array[UpgradeData]
@export var decedent_upgrades: Array[UpgradeData]
## Returns a list with the data of all prerequisite required upgrades to obtain this upgrade
func get_prereqs() -> Array[UpgradeData]:
	return prerequisite_upgrades
## Returns a list with the data of all upgrades this upgrade is a prereq for 
func get_decedent_upgrades() -> Array[UpgradeData]:
	return decedent_upgrades
## Checks if all the preqreq upgrades are obtained
func can_obtain(equipped_upgrades: Array[UpgradeData]) -> bool:
	var copy: Array[UpgradeData] = prerequisite_upgrades.duplicate()
	for upgrade in equipped_upgrades:
		if copy.has(upgrade):
			copy.erase(upgrade)
	return copy.is_empty()
## Makes and returns the associated Upgrade scene for this data
func make_upgrade() -> Upgrade:
	return scene.instantiate()
