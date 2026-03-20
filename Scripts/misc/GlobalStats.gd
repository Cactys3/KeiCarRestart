extends Node
class_name GlobalStats
# Stats Constants
const HP = "hp"
const STANCE = "stance"
const MOVESPEED = "movespeed"
const XP = "xp"
const MOGUL = "mogul"
const LUCK = "luck"
const DAMAGE = "damage"
const RANGE = "range"
const WEIGHT = "weight"
## Determines cooldown between projectiles
const ATTACKCOOLDOWN = "attack cooldown"
## Determines cooldown for reloading
const RELOADTIME = "reload cooldown"
const VELOCITY = "velocity"
const AMMO = "ammo"
const COUNT = "count"
const PIERCING = "piercing"
const DURATION = "duration"
const BUILDUP = "buildup"
const SIZE = "size"
const CRITCHANCE = "critical strike chance"
const CRITDAMAGE = "critical strike damage"
const GHOSTLY = "ghostly"
const REGEN = "regen"
const MAGNETIZE = "magentize"
const LIFESTEAL = "lifesteal"
const SHIELD = "shield"
const DIFFICULTY = "difficulty"
const REVIES = "revies"
const THORNS = "thorns"
const INACCURACY = "inaccuracy"
## Stats Added to Stat Getters
static var statsbase = StatsList.new(0)
## Stats Multiplied to Stat Getters
static var statsfactor = StatsList.new(1)
## Likely resets everything in preparation for a new run
static func setup():
	statsbase = StatsList.new(0)
	statsfactor = StatsList.new(1)
static func get_base_stat(stat: String) -> float:
	return statsbase[stat]
static func get_factor_stat(stat: String) -> float:
	return statsfactor[stat]
## Calculates the stat
static func get_stat(stat: String) -> float:
	return get_base_stat(stat) * get_factor_stat(stat)
## add stats
static func increase_stats_base(stat: String, value: float):
	statsbase[stat] += value
static func increase_stats_factor(stat: String, value: float):
	statsfactor[stat] += value
## Stores a variable for each stat
class StatsList:
	func _init(default_value: float):
		list = {
			HP: default_value,
			STANCE: default_value,
			MOVESPEED: default_value,
			XP: default_value,
			MOGUL: default_value,
			LUCK: default_value, 
			DAMAGE: default_value,
			RANGE: default_value,
			WEIGHT: default_value,
			ATTACKCOOLDOWN: default_value,
			RELOADTIME: default_value,
			VELOCITY: default_value,
			AMMO: default_value,
			COUNT: default_value,
			PIERCING: default_value,
			DURATION: default_value,
			BUILDUP: default_value,
			SIZE: default_value, 
			CRITCHANCE: default_value,
			CRITDAMAGE: default_value,
			GHOSTLY: default_value,
			REGEN: default_value,
			MAGNETIZE: default_value,
			LIFESTEAL: default_value,
			SHIELD: default_value,
			DIFFICULTY: default_value,
			REVIES: default_value,
			THORNS: default_value,
			INACCURACY: default_value}
	func _get(key: StringName):
		return list.get(key)
	func _set(key: StringName, value) -> bool:
		if list.has(key):
			list[key] = value
			return true
		return false
	var list = {
		HP: 0.0,
		STANCE: 0.0,
		MOVESPEED: 0.0,
		XP: 0.0,
		MOGUL: 0.0,
		LUCK: 0.0, 
		DAMAGE: 0.0,
		RANGE: 0.0,
		WEIGHT: 0.0,
		ATTACKCOOLDOWN: 0.0,
		RELOADTIME: 0.0,
		VELOCITY: 0.0,
		AMMO: 0.0,
		COUNT: 0.0,
		PIERCING: 0.0,
		DURATION: 0.0,
		BUILDUP: 0.0,
		SIZE: 0.0, 
		CRITCHANCE: 0.0,
		CRITDAMAGE: 0.0,
		GHOSTLY: 0.0,
		REGEN: 0.0,
		MAGNETIZE: 0.0,
		LIFESTEAL: 0.0,
		SHIELD: 0.0,
		DIFFICULTY: 0.0,
		REVIES: 0.0,
		THORNS: 0.0,
		INACCURACY: 0.0}
## STOLEN FROM STATS.GD
## Round original_stat to have 'digits' digits at max
static func round_to_digits(original_stat: float, digits: int) -> String:
	var number: String = str(snapped(original_stat, 0.01))
	var decimals = digits - number.split(".")[0].length()
	if decimals > 0:
		if "." in number:
			number = number.rstrip("0").rstrip(".")
	else:
		number = number.split(".")[0]
	return number
## Calculates and returns Scale for given Size:
static func calculate_scale(size: float) -> float:
	return 1 + ((size - 1) / 10)
## Calculate Movespeed:
static func calculate_movespeed(movespeed: float) -> float:
	return movespeed * 2
static func calculate_critdamage(critdamage: float) -> float:
	return critdamage
static func calculate_critchance(critchance: float) -> float:
	return critchance
static func calculate_damage(damage: float, critchance: float, critdamage: float):
	if (critchance / 100) > randf():
		return damage * (1 + (critdamage / 100))
	else:
		return damage
static func calculate_avoid_damage(ghostly: float) -> bool:
	var ScalingConstant: float = 160 ## Half-Saturation: at Ghostly = 160, it will reach half of 160 (chance = 80)
	if ghostly > 0.0:
		return ghostly / (1.0 + (ghostly / ScalingConstant)) > randf() * 100.0
	return false
	#return min(ghostly, 85) / 100 > randf()
static func calculate_regen(regen: float) -> float:
	return regen / 10
static func calculate_spawning_cd(base_cd: float, difficulty: float) -> float:
	## Can be at minimum half of normal cd
	return max(base_cd - (difficulty / 100), base_cd / 2)
static func calculate_max_enemies(base_max: float, difficulty: float) -> float:
	return base_max + (difficulty / 2)
static func calculate_min_enemies(base_min: float, difficulty: float) -> float:
	return base_min + (difficulty / 2)
static func calculate_uprade_rarity_count(luck: float) -> int:
	var ret: int = 0
	## Luck: 50 means 50% chance to upgrade
	## Luck: 150 means 100% chance to upgrade 1, 50% chance to upgrade twice
	while(randf() < luck / 100):
		luck -= 100
		ret += 1
	return ret
static func calculate_stat_upgrade_level_multiplier(level: float) -> float:
	return (level / 100) + 1
