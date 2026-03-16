extends Node
class_name ShopManager

## Weapons
const PISTOL = preload("uid://cjkad8i0d5u2g")

## Upgrades

## Projectiles
const _9_MM = preload("uid://c5n35stv668tp")

## Arrays
static var unlocked_projectiles_indicies: Array [int] = []
static var unlocked_weapon_indicies: Array [int] = []
static var unlocked_upgrade_indicies: Array [int] = []
const upgrade_list: Array [PackedScene] = []
const weapon_list: Array [PackedScene] = []
const projectile_list: Array [PackedScene] = []
## Weapon Indexes
const pistol_index: int = 0

## Projectile Indexes
const nine_mm_index: int = 0

## Upgrade Indexes

## Returns Random Projectile
static func get_rand_projectile() -> Projectile:
	return projectile_list.get(get_random_unlocked_weapon_index()).duplicate()
## Returns Random Weapon
static func get_rand_weapon() -> Weapon:
		return get_weapon(get_random_unlocked_weapon_index())
## Returns Random Upgrade
static func get_rand_upgrade() -> Upgrade:
	return (upgrade_list.get(get_random_unlocked_upgrade_index())).instantiate()
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_projectile(num: int) -> Projectile:
	if num < projectile_list.size() && num > -1:
		return projectile_list.get(num).instantiate()
	return projectile_list.get(get_random_unlocked_projectile_index()).instantiate()
## 1 = FLAMETHROWER, 2 = PISTOL, 3 = RAILGUN, 4 = SWORD, other = RANDOM COMPONENTS
static func get_weapon(num: int) -> Weapon:
	if num < weapon_list.size() && num > -1:
		return weapon_list.get(num).instantiate()
	return weapon_list.get(get_random_unlocked_weapon_index()).instantiate()
## 1 = DamageBuff
static func get_upgrade(num: int) -> Upgrade:
	if num < upgrade_list.size() && num > -1:
		return upgrade_list.get(num).instantiate()
	return upgrade_list.get(get_random_unlocked_upgrade_index()).instantiate()
## Returns random unlocked projectile's index
static func get_random_unlocked_projectile_index() -> int:
	return randi_range(0, projectile_list.size() - 1) #TODO: Check if attachment is unlocked?
static func get_random_unlocked_weapon_index() -> int:
	return randi_range(0, projectile_list.size() - 1) #TODO: Check if attachment is unlocked?
static func get_random_unlocked_upgrade_index() -> int:
	return randi_range(0, upgrade_list.size() - 1) #TODO: Check if item is unlocked?
static func get_all_unlocked_weapon_indices() -> Array[int]:
	return unlocked_weapon_indicies
static func get_all_unlocked_upgrade_indices() -> Array[int]:
	return unlocked_upgrade_indicies
static func get_all_unlocked_projectiles_indices() -> Array[int]:
	return unlocked_projectiles_indicies
## TODO: Implement
static func get_rand_upgrade_except(avoided_items: Array[Equipment]) -> Upgrade:
	return get_rand_upgrade()
