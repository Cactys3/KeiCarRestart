extends Node
class_name ShopManager
## Weapon Names
const PISTOL = "Pistol"
const BOXING_GLOVES = "Boxing Glove"
## Upgrade Names
# Blood Path
const BLOOD_BORN = "Blood Born"
const BLOOD_MECHANIC = "Blood Mechanic"
const BLOOD_METER = "Blood Meter"
const BLOOD_RAGE = "Blood Rage"
const BLOOD_SPHERE = "Blood Sphere"
const BLOOD_TURRETS = "Blood Turrets"
const BLOODY_MAGAZINE = "Bloody Magazine"
const BLOODY_NEEDLES = "Bloody Needles"
const BLOODY_QUIVER = "Bloody Quiver"
const CUTTING_STRIKES = "Cutting Strikes"
const GELID_HEOLFOR = "Gelid Heolfor"
const HEMOPLOSION = "Hemoplosion"
const PROLIFERATE = "Proliferate"
## Projectile Names
const _9_MM = "9mm"
## Weapon Scenes
const PISTOL_SCENE = preload("uid://cjkad8i0d5u2g")
const BOXING_GLOVES_SCENE = preload("uid://bbw0s4nlfy63s")
## Upgrades Scenes	
const BLOOD_BORN_SCENE = preload("uid://c6tfvrx3jikpg")
const BLOOD_MECHANIC_SCENE = preload("uid://bcfc0hdhceqpc")
const BLOOD_METER_SCENE = preload("uid://1xwwnlfmp6et")
const BLOOD_RAGE_SCENE = preload("uid://ug72dev0jq2d")
const BLOOD_SPHERE_SCENE = preload("uid://bwjdr1umu6h5k")
const BLOOD_TURRETS_SCENE = preload("uid://c5wosxw2gtbd5")
const BLOODY_MAGAZINE_SCENE = preload("uid://d1f0stejlye0n")
const BLOODY_NEEDLES_SCENE = preload("uid://jxh1upa5f50q")
const BLOODY_QUIVER_SCENE = preload("uid://br44c2vh2fhtf")
const CUTTING_STRIKES_SCENE = preload("uid://e4ho6vfqngai")
const GELID_HEOLFOR_SCENE = preload("uid://b3gs60rx8eg8u")
const HEMOPLOSION_SCENE = preload("uid://clsx2ugtfnojs")
const PROLIFERATE_SCENE = preload("uid://kers0tuck4se")

## Projectiles
const _9_MM_SCENE = preload("uid://c5n35stv668tp")
## Arrays
static var unlocked_projectiles_keys: Array [String] = []
static var unlocked_weapon_keys: Array [String] = []
static var unlocked_upgrade_keys: Array [String] = []
const upgrade_list: Dictionary [String, UpgradeData] = {
	BLOOD_BORN: BLOOD_BORN_SCENE,
	BLOOD_MECHANIC: BLOOD_MECHANIC_SCENE,
	BLOOD_METER: BLOOD_METER_SCENE,
	BLOOD_RAGE: BLOOD_RAGE_SCENE,
	BLOOD_SPHERE: BLOOD_SPHERE_SCENE,
	BLOOD_TURRETS: BLOOD_TURRETS_SCENE,
	BLOODY_MAGAZINE: BLOODY_MAGAZINE_SCENE,
	BLOODY_NEEDLES: BLOODY_NEEDLES_SCENE,
	BLOODY_QUIVER: BLOODY_QUIVER_SCENE,
	CUTTING_STRIKES: CUTTING_STRIKES_SCENE,
	GELID_HEOLFOR: GELID_HEOLFOR_SCENE,
	HEMOPLOSION: HEMOPLOSION_SCENE,
	PROLIFERATE: PROLIFERATE_SCENE}
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
## Returns Random, valid upgrade, will return empty array if no valid upgrade
static func get_rand_upgrades(count: int, game_man: GameManager) -> Array[UpgradeData]:
	var valid_upgrades: Array[UpgradeData] = get_all_valid_upgrades(game_man)
	var ret: Array[UpgradeData] = []
	## Pick At Random
	for e in count:
		if valid_upgrades.size() > 0:
			var upgrade: UpgradeData = valid_upgrades.pick_random()
			ret.append(upgrade)
			valid_upgrades.erase(upgrade)
	if ret.is_empty():
		printerr("Trying to get upgrade, but there are no valid upgrades")
	return ret
## Returns random projectile instance
static func get_projectile(key: String) -> Projectile:
	if projectile_list.has(key):
		return projectile_list.get(key).instantiate()
	printerr("Requesting non-existent projectile: ", key)
	return null
## Returns random weapon instance
static func get_weapon(key: String) -> Weapon:
	if weapon_list.has(key):
		return weapon_list.get(key).instantiate()
	printerr("Requesting non-existent weapon: ", key)
	return null
## 
static func get_upgrade(key: String) -> UpgradeData:
	if upgrade_list.has(key):
		return upgrade_list.get(key)
	printerr("Requesting non-existent upgrade: ", key)
	return null
## Returns random unlocked projectile's index
static func get_random_unlocked_projectile_key() -> String:
	return unlocked_weapon_keys.pick_random() #TODO: Check if attachment is unlocked?
static func get_random_unlocked_weapon_key() -> String:
	return unlocked_projectiles_keys.pick_random() #TODO: Check if attachment is unlocked?
#static func get_random_unlocked_upgrade_key() -> String:
	#return unlocked_upgrade_keys.pick_random() #TODO: Check if item is unlocked?
static func get_all_unlocked_weapons() -> Array[String]:
	return unlocked_weapon_keys
#static func get_all_unlocked_upgrades() -> Array[String]:
	#return unlocked_upgrade_keys
static func get_all_unlocked_projectiles() -> Array[String]:
	return unlocked_projectiles_keys
## Returns Random, valid upgrade, except those in avoided_items
static func get_rand_upgrades_except(avoided_items: Array[Upgrade], count: int, game_man: GameManager) -> Array[UpgradeData]:
	var valid_upgrades: Array[UpgradeData] = get_all_valid_upgrades(game_man)
	## Remove avoids
	for upgrade in avoided_items:
		if valid_upgrades.has(upgrade):
			valid_upgrades.erase(upgrade)
	## Pick At Random
	var ret: Array[UpgradeData] = []
	for e in count:
		if valid_upgrades.size() > 0:
			var upgrade: UpgradeData = valid_upgrades.pick_random()
			ret.append(upgrade)
			valid_upgrades.erase(upgrade)
	return ret
## Returns all upgrades that are valid to obtain and not already obtained
static func get_all_valid_upgrades(game_man: GameManager) -> Array[UpgradeData]:
	var array: Array[UpgradeData]
	for upgrade: UpgradeData in upgrade_list.values():
		## If we can obtain, add to list
		if upgrade.can_obtain(game_man.active_upgrades):
			array.append(upgrade)
	return array
