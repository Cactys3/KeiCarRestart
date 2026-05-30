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
## How many times can fire before reloading
const AMMO = "ammo"
## How many bullets per fire (if can shoot multiple)
const COUNT = "count"
const PIERCING = "piercing"
const DURATION = "duration"
const SIZE = "size"
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
## Status - Weapons have these default to 1 (unless the weapon can't apply it), 
## as these stats don't matter unless the weapon has 'can_effect' enabled in StatusEffects
const BURN_APPLY = "burn apply"
const FROST_APPLY = "frost apply"
const POISON_APPLY = "poison apply"
const BLEED_APPLY = "bleed apply"
const SHOCK_APPLY = "shock apply"
const WET_APPLY = "wet apply"
## Status Damages
## Damage done every burn tick
const BURN_DAMAGE = "burn damage"
## Damage done on frost proc
const FROST_DAMAGE = "frost damage"
## Damage done every poison tick
const POISON_DAMAGE = "poison damage"
## Percent (out of 100) HP that bleed procs do
const BLEED_DAMAGE = "bleed damage"
## Bonus damage from shock
const SHOCK_DAMAGE = "shock damage"
## Bonus damage from wet
const WET_DAMAGE = "wet damage"
## Stats Added to Stat Getters
static var statsbase = StatsList.new(0)
## Stats Multiplied to Stat Getters
static var statsfactor = StatsList.new(1)
## Likely resets everything in preparation for a new run
static func reset():
	statsbase = StatsList.new(0)
	statsfactor = StatsList.new(1)
	## Status Effect Base Damages are default
	statsbase.set_stat(BURN_DAMAGE, 25.0)
	statsbase.set_stat(FROST_DAMAGE, 10.0)
	statsbase.set_stat(POISON_DAMAGE, 10.0)
	statsbase.set_stat(BLEED_DAMAGE, 25.0) # Percent
	statsbase.set_stat(SHOCK_DAMAGE, 10.0)
	statsbase.set_stat(WET_DAMAGE, 1.0)
static func get_base_stat(stat: String) -> float:
	return statsbase.get_stat(stat)
static func get_factor_stat(stat: String) -> float:
	return statsfactor.get_stat(stat)
## Calculates the full stat
static func get_stat(stat: String) -> float:
	return get_base_stat(stat) * get_factor_stat(stat)
## add stats
static func add_to_stats_base(stat: String, value: float):
	statsbase.add_to_stat(stat, value)
static func add_to_stats_factor(stat: String, value: float):
	statsfactor.add_to_stat(stat, value)
## Returns a copy of the Factor StatsList
static func get_statslist_factor() -> StatsList:
	return statsfactor.get_copy()
## Returns a copy of the Base StatsList
static func get_statslist_base() -> StatsList:
	return statsbase.get_copy()
## Stores a variable for each stat
class StatsList:
	var list: Dictionary = {}
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
			SIZE: default_value, 
			CRITDAMAGE: default_value,
			GHOSTLY: default_value,
			REGEN: default_value,
			MAGNETIZE: default_value,
			LIFESTEAL: default_value,
			SHIELD: default_value,
			DIFFICULTY: default_value,
			REVIES: default_value,
			THORNS: default_value,
			INACCURACY: default_value,
			BURN_APPLY: default_value,
			FROST_APPLY: default_value,
			POISON_APPLY: default_value,
			BLEED_APPLY: default_value,
			SHOCK_APPLY: default_value,
			WET_APPLY: default_value,
			BURN_DAMAGE: default_value,
			FROST_DAMAGE: default_value,
			POISON_DAMAGE: default_value,
			BLEED_DAMAGE: default_value,
			SHOCK_DAMAGE: default_value,
			WET_DAMAGE: default_value
			}
	func has(key: String) -> bool:
		return list.has(key)
	func get_stat(key: String):
		return list.get(key)
	func set_stat(key: String, value: float) -> bool:
		if list.has(key):
			list[key] = value
			return true
		return false
	func add_to_stat(key: String, value: float) -> bool:
		if list.has(key):
			list[key] = list[key] + value
			return true
		return false
	func print_stats():
		print("Stats: ")
		for stat in list.keys():
			print("\t", stat, " : ", list.get(stat))
	## Returns duplicate copy of this StatsList
	func get_copy() -> StatsList: 
		var new_list = StatsList.new(0)
		for key in new_list.list.keys():
			new_list.set_stat(key, get_stat(key))
		return new_list
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
## Calculate if this move is a critical strike
static func calculate_crit(luck: float) -> bool:
	return luck >= randf_range(0, 100)
static func calculate_damage(damage: float, crit: bool, critdamage: float):
	if crit:
		return damage * Statics.global_crit_damage_factor * (1 + critdamage)
	else:
		return damage
static func calculate_knockback(damage: float, weight: float) -> float:
	return (damage / 2) + (weight * 2) ## More to do with weight than damage
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
