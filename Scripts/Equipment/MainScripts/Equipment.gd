extends Node2D
class_name Equipment

## Stats
@export var hp: float = 0.0
@export var stance: float = 0.0
@export var movespeed: float = 0.0
@export var xp: float = 0.0
@export var mogul: float = 0.0
@export var luck: float = 0.0
@export var damage: float = 0.0
@export var _range: float = 0.0
@export var weight: float = 0.0
@export var attackcooldown: float = 0.0
@export var RELOADTIME: float = 0.0
@export var velocity: float = 0.0
@export var ammo:  float = 0.0
@export var count: float = 0.0
@export var piercing: float = 0.0
@export var duration: float = 0.0
@export var buildup: float = 0.0
@export var size: float = 0.0
@export var critchance: float = 0.0
@export var critdamage: float = 0.0
@export var ghostly: float = 0.0
@export var regen: float = 0.0
@export var magnetize: float = 0.0
@export var lifesteal: float = 0.0
@export var shield: float = 0.0
@export var difficulty: float = 0.0
@export var revies: float = 0.0
@export var thorns: float = 0.0
@export var inaccuracy: float = 0.0
func _ready() -> void:
	flash()
func get_stat(stat: String) -> float:
	## other implementations are hard because variables may be accessed before they are ready or smth i forget.
	if stat == GlobalStats.HP:
		return (GlobalStats.get_base_stat(GlobalStats.HP) + hp) * GlobalStats.get_factor_stat(GlobalStats.HP)
	elif stat == GlobalStats.STANCE:
		return (GlobalStats.get_base_stat(GlobalStats.STANCE) + stance) * GlobalStats.get_factor_stat(GlobalStats.STANCE)
	elif stat == GlobalStats.MOVESPEED:
		return (GlobalStats.get_base_stat(GlobalStats.MOVESPEED) + movespeed) * GlobalStats.get_factor_stat(GlobalStats.MOVESPEED)
	elif stat == GlobalStats.XP:
		return (GlobalStats.get_base_stat(GlobalStats.XP) + xp) * GlobalStats.get_factor_stat(GlobalStats.XP)
	elif stat == GlobalStats.MOGUL:
		return (GlobalStats.get_base_stat(GlobalStats.MOGUL) + mogul) * GlobalStats.get_factor_stat(GlobalStats.MOGUL)
	elif stat == GlobalStats.LUCK:
		return (GlobalStats.get_base_stat(GlobalStats.LUCK) + luck) * GlobalStats.get_factor_stat(GlobalStats.LUCK)
	elif stat == GlobalStats.DAMAGE:
		return (GlobalStats.get_base_stat(GlobalStats.DAMAGE) + damage) * GlobalStats.get_factor_stat(GlobalStats.DAMAGE)
	elif stat == GlobalStats.RANGE:
		return (GlobalStats.get_base_stat(GlobalStats.RANGE) + _range) * GlobalStats.get_factor_stat(GlobalStats.RANGE)
	elif stat == GlobalStats.WEIGHT:
		return (GlobalStats.get_base_stat(GlobalStats.WEIGHT) + weight) * GlobalStats.get_factor_stat(GlobalStats.WEIGHT)
	elif stat == GlobalStats.ATTACKCOOLDOWN:
		return (GlobalStats.get_base_stat(GlobalStats.ATTACKCOOLDOWN) + attackcooldown) * GlobalStats.get_factor_stat(GlobalStats.ATTACKCOOLDOWN)
	elif stat == GlobalStats.RELOADTIME:
		return (GlobalStats.get_base_stat(GlobalStats.RELOADTIME) + RELOADTIME) * GlobalStats.get_factor_stat(GlobalStats.RELOADTIME)
	elif stat == GlobalStats.VELOCITY:
		return (GlobalStats.get_base_stat(GlobalStats.VELOCITY) + velocity) * GlobalStats.get_factor_stat(GlobalStats.VELOCITY)
	elif stat == GlobalStats.AMMO:
		return (GlobalStats.get_base_stat(GlobalStats.AMMO) + ammo) * GlobalStats.get_factor_stat(GlobalStats.AMMO)
	elif stat == GlobalStats.COUNT:
		return (GlobalStats.get_base_stat(GlobalStats.COUNT) + count) * GlobalStats.get_factor_stat(GlobalStats.COUNT)
	elif stat == GlobalStats.PIERCING:
		return (GlobalStats.get_base_stat(GlobalStats.PIERCING) + piercing) * GlobalStats.get_factor_stat(GlobalStats.PIERCING)
	elif stat == GlobalStats.DURATION:
		return (GlobalStats.get_base_stat(GlobalStats.DURATION) + duration) * GlobalStats.get_factor_stat(GlobalStats.DURATION)
	elif stat == GlobalStats.BUILDUP:
		return (GlobalStats.get_base_stat(GlobalStats.BUILDUP) + buildup) * GlobalStats.get_factor_stat(GlobalStats.BUILDUP)
	elif stat == GlobalStats.SIZE:
		return (GlobalStats.get_base_stat(GlobalStats.SIZE) + size) * GlobalStats.get_factor_stat(GlobalStats.SIZE)
	elif stat == GlobalStats.CRITCHANCE:
		return (GlobalStats.get_base_stat(GlobalStats.CRITCHANCE) + critchance) * GlobalStats.get_factor_stat(GlobalStats.CRITCHANCE)
	elif stat == GlobalStats.CRITDAMAGE:
		return (GlobalStats.get_base_stat(GlobalStats.CRITDAMAGE) + critdamage) * GlobalStats.get_factor_stat(GlobalStats.CRITDAMAGE)
	elif stat == GlobalStats.GHOSTLY:
		return (GlobalStats.get_base_stat(GlobalStats.GHOSTLY) + ghostly) * GlobalStats.get_factor_stat(GlobalStats.GHOSTLY)
	elif stat == GlobalStats.REGEN:
		return (GlobalStats.get_base_stat(GlobalStats.REGEN) + regen) * GlobalStats.get_factor_stat(GlobalStats.REGEN)
	elif stat == GlobalStats.MAGNETIZE:
		return (GlobalStats.get_base_stat(GlobalStats.MAGNETIZE) + magnetize) * GlobalStats.get_factor_stat(GlobalStats.MAGNETIZE)
	elif stat == GlobalStats.LIFESTEAL:
		return (GlobalStats.get_base_stat(GlobalStats.LIFESTEAL) + lifesteal) * GlobalStats.get_factor_stat(GlobalStats.LIFESTEAL)
	elif stat == GlobalStats.SHIELD:
		return (GlobalStats.get_base_stat(GlobalStats.SHIELD) + shield) * GlobalStats.get_factor_stat(GlobalStats.SHIELD)
	elif stat == GlobalStats.DIFFICULTY:
		return (GlobalStats.get_base_stat(GlobalStats.DIFFICULTY) + difficulty) * GlobalStats.get_factor_stat(GlobalStats.DIFFICULTY)
	elif stat == GlobalStats.REVIES:
		return (GlobalStats.get_base_stat(GlobalStats.REVIES) + revies) * GlobalStats.get_factor_stat(GlobalStats.REVIES)
	elif stat == GlobalStats.THORNS:
		return (GlobalStats.get_base_stat(GlobalStats.THORNS) + thorns) * GlobalStats.get_factor_stat(GlobalStats.THORNS)
	elif stat == GlobalStats.INACCURACY:
		return (GlobalStats.get_base_stat(GlobalStats.INACCURACY) + inaccuracy) * GlobalStats.get_factor_stat(GlobalStats.INACCURACY)
	printerr("Stat not found: ", stat)
	return -999
## Flashing stuff
func flash():
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true

## Data Fields
var player: Character
## Generic Fields (always active)
@export_placeholder("Name Go Here") var item_name: String = "unset"
@export_multiline var item_description: String = "default description"
@export var item_type: item_types
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D 
@export var item_rarity: item_rarities
## is this weapon or upgrade equipped
var active: bool = false
## unset, upgrade, projectile, weapon
enum item_types{unset, upgrade, projectile, weapon}
## unset, common, rare, epic, exclusive
enum item_rarities {unset, common, rare, epic, exclusive}
## Rarity Colors
const DEFAULT_COLOR: Color = Color.GRAY
const COMMON_COLOR: Color = Color.LIME_GREEN
const RARE_COLOR: Color = Color.ROYAL_BLUE
const EPIC_COLOR: Color = Color.MEDIUM_PURPLE
const EXCLUSIVE_COLOR: Color = Color.ORANGE_RED
## Returns rarity for the given rarity_types index
static func get_rarity(i: int) -> String:
	match(i):
		item_rarities.common:
			return "Common"
		item_rarities.rare:
			return "Rare"
		item_rarities.epic:
			return "Epic"
		item_rarities.exclusive:
			return "Exclusive"
		item_rarities.unset:
			return "unset"
	return "Rarity: " + str(i)
## Returns type for the given item_types index
static func get_type(i: int) -> String:
	match(i):
		item_types.unset:
			return "unset"
		item_types.projectile:
			return "projectile"
		item_types.weapon:
			return "weapon"
		item_types.upgrade:
			return "upgrade"
	return "Type: " + str(i)

## enable and apply the functionality of this Equipment
func activate(new_player: Character):
	player = new_player
	active = true
## disable and halt the functionality of this Equipment
func deactivate():
	active = false
