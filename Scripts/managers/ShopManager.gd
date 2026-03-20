extends Node
class_name ShopManager
## Weapon Names
const PISTOL = "Pistol"
const BOXING_GLOVES = "Boxing Glove"
## Upgrade Names
const test = "test"
## Projectile Names
const _9_MM = "9mm"
## Weapon Scenes
const PISTOL_SCENE = preload("uid://cjkad8i0d5u2g")
const BOXING_GLOVES_SCENE = preload("uid://bbw0s4nlfy63s")
## Upgrades Scenes
## Projectiles
const _9_MM_SCENE = preload("uid://c5n35stv668tp")
## Arrays
static var unlocked_projectiles_keys: Array [String] = []
static var unlocked_weapon_keys: Array [String] = []
static var unlocked_upgrade_keys: Array [String] = []
const upgrade_list: Dictionary [String, UpgradeData] = {}
const weapon_list: Dictionary [String, PackedScene] = {
	PISTOL: PISTOL_SCENE,
	BOXING_GLOVES: BOXING_GLOVES_SCENE}
const projectile_list: Dictionary [String, PackedScene] = {
	_9_MM: _9_MM_SCENE}

## Upgrade Indexes

## Returns Random Projectile
static func get_rand_projectile() -> Projectile:
	return projectile_list.get(get_random_unlocked_weapon_key()).instantiate()
## Returns Random Weapon
static func get_rand_weapon() -> Weapon:
		return weapon_list.get(get_random_unlocked_weapon_key()).instantiate()
## Returns Random Upgrade
static func get_rand_upgrade() -> Upgrade:
	return upgrade_list.get(get_random_unlocked_upgrade_key()).instantiate()
##
static func get_projectile(key: String) -> Projectile:
	if projectile_list.has(key):
		return projectile_list.get(key).instantiate()
	printerr("Requesting non-existent projectile: ", key)
	return null
##
static func get_weapon(key: String) -> Weapon:
	if weapon_list.has(key):
		return weapon_list.get(key).instantiate()
	printerr("Requesting non-existent weapon: ", key)
	return null
## 
static func get_upgrade(key: String) -> Upgrade:
	if upgrade_list.has(key):
		return upgrade_list.get(key).instantiate()
	printerr("Requesting non-existent upgrade: ", key)
	return null
## Returns random unlocked projectile's index
static func get_random_unlocked_projectile_key() -> String:
	return unlocked_weapon_keys.pick_random() #TODO: Check if attachment is unlocked?
static func get_random_unlocked_weapon_key() -> String:
	return unlocked_projectiles_keys.pick_random() #TODO: Check if attachment is unlocked?
static func get_random_unlocked_upgrade_key() -> String:
	return unlocked_upgrade_keys.pick_random() #TODO: Check if item is unlocked?
static func get_all_unlocked_weapons() -> Array[String]:
	return unlocked_weapon_keys
static func get_all_unlocked_upgrades() -> Array[String]:
	return unlocked_upgrade_keys
static func get_all_unlocked_projectiles() -> Array[String]:
	return unlocked_projectiles_keys
## TODO: Implement
static func get_rand_upgrade_except(avoided_items: Array[Equipment]) -> Upgrade:
	return get_rand_upgrade()
