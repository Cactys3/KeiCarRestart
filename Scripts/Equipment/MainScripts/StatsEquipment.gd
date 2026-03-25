extends Equipment
## Equipment that needs its own stats to damage enemies or other actives
class_name StatsEquipment
## Stats
@export_group("Status")
@export var status: StatusEffects = StatusEffects.new()
@export var burn_apply: float = 0.35 # takes 3 hits base for each to proc (at threshold of 1)
@export var frost_apply: float = 0.35
@export var poison_apply: float = 0.35
@export var bleed_apply: float = 0.35
@export var shock_apply: float = 0.35
@export var wet_apply: float = 0.35
# not used, status damages are only GlobalStats
#@export var burn_damage: float = 5.0
#@export var frost_damage: float = 20.0
#@export var poison_damage: float = 3.0
#@export var bleed_damage: float = 35.0
#@export var shock_damage: float = 5.0
#@export var wet_damage: float = 1.0
@export_group("Weapon Stats")
## Weapon Stats
@export var damage: float = 0.0
@export var _range: float = 0.0
@export var attackcooldown: float = 0.0
@export var reloadtime: float = 0.0
## Projectile Stats
@export var velocity: float = 0.0
@export var ammo:  float = 0.0
@export var count: float = 0.0
@export var piercing: float = 0.0
@export var duration: float = 0.0
@export var size: float = 0.0
## Loosly/Sometimes Weapon Stats
@export var inaccuracy: float = 0.0
@export var luck: float = 0.0
@export var critdamage: float = 0.0
@export var weight: float = 0.0
@export var ghostly: float = 0.0
@export var lifesteal: float = 0.0
@export_group("Non-Weapon Stats")
## Non-Weapon Stats
@export var hp: float = 0.0
@export var stance: float = 0.0
@export var movespeed: float = 0.0
@export var xp: float = 0.0
@export var mogul: float = 0.0
@export var shield: float = 0.0
@export var difficulty: float = 0.0
@export var revies: float = 0.0
@export var thorns: float = 0.0
@export var regen: float = 0.0
@export var magnetize: float = 0.0



## Stat variables that return stat + globalstats.stat
var hp_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.HP) + hp) * GlobalStats.get_factor_stat(GlobalStats.HP)
var stance_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.STANCE) + stance) * GlobalStats.get_factor_stat(GlobalStats.STANCE)
var movespeed_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.MOVESPEED) + movespeed) * GlobalStats.get_factor_stat(GlobalStats.MOVESPEED)
var xp_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.XP) + xp) * GlobalStats.get_factor_stat(GlobalStats.XP)
var mogul_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.MOGUL) + mogul) * GlobalStats.get_factor_stat(GlobalStats.MOGUL)
var luck_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.LUCK) + luck) * GlobalStats.get_factor_stat(GlobalStats.LUCK)
var damage_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.DAMAGE) + damage) * GlobalStats.get_factor_stat(GlobalStats.DAMAGE)
var range_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.RANGE) + _range) * GlobalStats.get_factor_stat(GlobalStats.RANGE)
var weight_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.WEIGHT) + weight) * GlobalStats.get_factor_stat(GlobalStats.WEIGHT)
var attackcooldown_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.ATTACKCOOLDOWN) + attackcooldown) * GlobalStats.get_factor_stat(GlobalStats.ATTACKCOOLDOWN)
var reloadtime_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.RELOADTIME) + reloadtime) * GlobalStats.get_factor_stat(GlobalStats.RELOADTIME)
var velocity_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.VELOCITY) + velocity) * GlobalStats.get_factor_stat(GlobalStats.VELOCITY)
var ammo_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.AMMO) + ammo) * GlobalStats.get_factor_stat(GlobalStats.AMMO)
var count_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.COUNT) + count) * GlobalStats.get_factor_stat(GlobalStats.COUNT)
var piercing_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.PIERCING) + piercing) * GlobalStats.get_factor_stat(GlobalStats.PIERCING)
var duration_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.DURATION) + duration) * GlobalStats.get_factor_stat(GlobalStats.DURATION)
var size_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.SIZE) + size) * GlobalStats.get_factor_stat(GlobalStats.SIZE)
var critdamage_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.CRITDAMAGE) + critdamage) * GlobalStats.get_factor_stat(GlobalStats.CRITDAMAGE)
var ghostly_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.GHOSTLY) + ghostly) * GlobalStats.get_factor_stat(GlobalStats.GHOSTLY)
var regen_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.REGEN) + regen) * GlobalStats.get_factor_stat(GlobalStats.REGEN)
var magnetize_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.MAGNETIZE) + magnetize) * GlobalStats.get_factor_stat(GlobalStats.MAGNETIZE)
var lifesteal_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.LIFESTEAL) + lifesteal) * GlobalStats.get_factor_stat(GlobalStats.LIFESTEAL)
var shield_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.SHIELD) + shield) * GlobalStats.get_factor_stat(GlobalStats.SHIELD)
var difficulty_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.DIFFICULTY) + difficulty) * GlobalStats.get_factor_stat(GlobalStats.DIFFICULTY)
var revies_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.REVIES) + revies) * GlobalStats.get_factor_stat(GlobalStats.REVIES)
var thorns_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.THORNS) + thorns) * GlobalStats.get_factor_stat(GlobalStats.THORNS)
var inaccuracy_stat:
	get():
		return (GlobalStats.get_base_stat(GlobalStats.INACCURACY) + inaccuracy) * GlobalStats.get_factor_stat(GlobalStats.INACCURACY)


## Calculate and return an attack with damage multiplier
func make_attack(damage_multiplier: float) -> Attack:
	## Make Two Stats Lists
	var base: GlobalStats.StatsList = GlobalStats.get_statslist_base()
	var factor: GlobalStats.StatsList = GlobalStats.get_statslist_factor()
	
	## Add Self's Base Stats to Base StatList
	base = add_to_stats_list(base)
	factor.add_to_stat(GlobalStats.DAMAGE, damage_multiplier - 1) # -1 to make it a multiplier
	
	## Make Attack Values
	var attack_type: Attack.AttackTypes
	if item_type == item_types.upgrade:
		attack_type = Attack.AttackTypes.upgrade_melee
	elif item_type == item_types.weapon:
		attack_type = Attack.AttackTypes.player_weapon_melee 
	## Make attack and Pass attack through each active upgrade
	var attack: Attack = Attack.new(attack_type, self, player.global_position, status, base, factor)
	game_man.handle_player_attack(attack)
	return attack

## Adds Base Stats to given StatsList (Base Stat, not Base Stat + Global Stat)
func add_to_stats_list(list: GlobalStats.StatsList) -> GlobalStats.StatsList: 
	list.add_to_stat(GlobalStats.HP, hp)
	list.add_to_stat(GlobalStats.STANCE, stance)
	list.add_to_stat(GlobalStats.MOVESPEED, movespeed)
	list.add_to_stat(GlobalStats.XP, xp)
	list.add_to_stat(GlobalStats.MOGUL, mogul)
	list.add_to_stat(GlobalStats.LUCK, luck)
	list.add_to_stat(GlobalStats.DAMAGE, damage)
	list.add_to_stat(GlobalStats.RANGE, _range)
	list.add_to_stat(GlobalStats.WEIGHT, weight)
	list.add_to_stat(GlobalStats.ATTACKCOOLDOWN, attackcooldown)
	list.add_to_stat(GlobalStats.RELOADTIME, reloadtime)
	list.add_to_stat(GlobalStats.VELOCITY, velocity)
	list.add_to_stat(GlobalStats.AMMO, ammo)
	list.add_to_stat(GlobalStats.COUNT, count)
	list.add_to_stat(GlobalStats.PIERCING, piercing)
	list.add_to_stat(GlobalStats.DURATION, duration)
	list.add_to_stat(GlobalStats.SIZE, size)
	list.add_to_stat(GlobalStats.CRITDAMAGE, critdamage)
	list.add_to_stat(GlobalStats.GHOSTLY, ghostly)
	list.add_to_stat(GlobalStats.REGEN, regen)
	list.add_to_stat(GlobalStats.MAGNETIZE, magnetize)
	list.add_to_stat(GlobalStats.LIFESTEAL, lifesteal)
	list.add_to_stat(GlobalStats.SHIELD, shield)
	list.add_to_stat(GlobalStats.DIFFICULTY, difficulty)
	list.add_to_stat(GlobalStats.REVIES, revies)
	list.add_to_stat(GlobalStats.THORNS, thorns)
	list.add_to_stat(GlobalStats.INACCURACY, inaccuracy)
	list.add_to_stat(GlobalStats.BURN_APPLY, burn_apply)
	list.add_to_stat(GlobalStats.FROST_APPLY, frost_apply)
	list.add_to_stat(GlobalStats.POISON_APPLY, poison_apply)
	list.add_to_stat(GlobalStats.BLEED_APPLY, bleed_apply)
	list.add_to_stat(GlobalStats.SHOCK_APPLY, shock_apply)
	list.add_to_stat(GlobalStats.WET_APPLY, wet_apply)

	
	
	return list
