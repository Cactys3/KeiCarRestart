extends FlashFixNode
class_name StatsObject
@export_group("Stats Equipment")
@export_subgroup("Status")
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
@export_subgroup("Weapon Stats")
## Weapon Stats
@export var _damage: float = 0.0
@export var _range: float = 0.0
@export var _attackcooldown: float = 0.0
@export var _reloadtime: float = 0.0
@export var _ammo:  float = 0.0
@export var _count: float = 0.0
@export var _inaccuracy: float = 0.0
## Projectile Stats
@export var _size: float = 0.0
@export var _velocity: float = 0.0
@export var _piercing: float = 0.0
@export var _duration: float = 0.0 ## base duration and size just so spawned things appear for at least a second by default
## Loosly/Sometimes Weapon Stats
@export var _luck: float = 0.0
@export var _critdamage: float = 0.0
@export var _weight: float = 0.0
@export var _lifesteal: float = 0.0
@export_subgroup("Non-Weapon Stats")
## Non-Weapon Stats
@export var _hp: float = 0.0
@export var _stance: float = 0.0
@export var _ghostly: float = 0.0
@export var _movespeed: float = 0.0
@export var _xp: float = 0.0
@export var _mogul: float = 0.0
@export var _shield: float = 0.0
@export var _difficulty: float = 0.0
@export var _revies: float = 0.0
@export var _thorns: float = 0.0
@export var _regen: float = 0.0
@export var _magnetize: float = 0.0

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	pass
## Adds Base Stats to given StatsList (Base Stat, not Base Stat + Global Stat)
func add_to_stats_list(list: GlobalStats.StatsList) -> GlobalStats.StatsList: 
	list.add_to_stat(GlobalStats.HP, _hp)
	list.add_to_stat(GlobalStats.STANCE, _stance)
	list.add_to_stat(GlobalStats.MOVESPEED, _movespeed)
	list.add_to_stat(GlobalStats.XP, _xp)
	list.add_to_stat(GlobalStats.MOGUL, _mogul)
	list.add_to_stat(GlobalStats.LUCK, _luck)
	list.add_to_stat(GlobalStats.DAMAGE, _damage)
	list.add_to_stat(GlobalStats.RANGE, _range)
	list.add_to_stat(GlobalStats.WEIGHT, _weight)
	list.add_to_stat(GlobalStats.ATTACKCOOLDOWN, _attackcooldown)
	list.add_to_stat(GlobalStats.RELOADTIME, _reloadtime)
	list.add_to_stat(GlobalStats.VELOCITY, _velocity)
	list.add_to_stat(GlobalStats.AMMO, _ammo)
	list.add_to_stat(GlobalStats.COUNT, _count)
	list.add_to_stat(GlobalStats.PIERCING, _piercing)
	list.add_to_stat(GlobalStats.DURATION, _duration)
	list.add_to_stat(GlobalStats.SIZE, _size)
	list.add_to_stat(GlobalStats.CRITDAMAGE, _critdamage)
	list.add_to_stat(GlobalStats.GHOSTLY, _ghostly)
	list.add_to_stat(GlobalStats.REGEN, _regen)
	list.add_to_stat(GlobalStats.MAGNETIZE, _magnetize)
	list.add_to_stat(GlobalStats.LIFESTEAL, _lifesteal)
	list.add_to_stat(GlobalStats.SHIELD, _shield)
	list.add_to_stat(GlobalStats.DIFFICULTY, _difficulty)
	list.add_to_stat(GlobalStats.REVIES, _revies)
	list.add_to_stat(GlobalStats.THORNS, _thorns)
	list.add_to_stat(GlobalStats.INACCURACY, _inaccuracy)
	list.add_to_stat(GlobalStats.BURN_APPLY, burn_apply)
	list.add_to_stat(GlobalStats.FROST_APPLY, frost_apply)
	list.add_to_stat(GlobalStats.POISON_APPLY, poison_apply)
	list.add_to_stat(GlobalStats.BLEED_APPLY, bleed_apply)
	list.add_to_stat(GlobalStats.SHOCK_APPLY, shock_apply)
	list.add_to_stat(GlobalStats.WET_APPLY, wet_apply)
	return list
var game_man: 
	get():
		return GameManager.instance
## Base check for the body having the methods required to be attacked
func can_attack(body: Node2D) -> bool:
	return body.has_method("damage") && "can_be_damaged" in body && body.get("can_be_damaged")
func get_can_attack_callable() -> Callable:
	return can_attack
	#return func(body: Node2D) -> bool:
		#return body.has_method("damage") && "can_be_damaged" in body && body.get("can_be_damaged")
## Calculate and return an attack with damage multiplier
func make_attack(attack_damage_multiplier: float) -> Attack:
	## Make Two Stats Lists
	var base: GlobalStats.StatsList = GlobalStats.get_statslist_base()
	var factor: GlobalStats.StatsList = GlobalStats.get_statslist_factor()
	## Add Self's Base Stats to Base StatList
	base = add_to_stats_list(base)
	factor.add_to_stat(GlobalStats.DAMAGE, attack_damage_multiplier - 1) # -1 to make it a multiplier
	## Make attack and Pass attack through each active upgrade
	var attack: Attack = Attack.new(get_attack_type(), self, get_attack_position(), status, base, factor)
	game_man.handle_attack(attack)
	return attack
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
func get_attack_position() -> Vector2:
	return global_position

## Getters
var hp_stat:
	get():
		return _get_hp_stat()
var stance_stat:
	get():
		return _get_stance_stat()
var movespeed_stat:
	get():
		return _get_movespeed_stat()
var xp_stat:
	get():
		return _get_xp_stat()
var mogul_stat:
	get():
		return _get_mogul_stat()
var luck_stat:
	get():
		return _get_luck_stat()
var damage_stat:
	get():
		return _get_damage_stat()
var range_stat:
	get():
		return _get_range_stat()
var weight_stat:
	get():
		return _get_weight_stat()
var attackcooldown_stat:
	get():
		return _get_attackcooldown_stat()
var reloadtime_stat:
	get():
		return _get_reloadtime_stat()
var velocity_stat:
	get():
		return _get_velocity_stat()
var ammo_stat:
	get():
		return _get_ammo_stat()
var count_stat:
	get():
		return _get_count_stat()
var piercing_stat:
	get():
		return _get_piercing_stat()
var duration_stat:
	get():
		return _get_duration_stat()
var size_stat:
	get():
		return _get_size_stat()
var critdamage_stat:
	get():
		return _get_critdamage_stat()
var ghostly_stat:
	get():
		return _get_ghostly_stat()
var regen_stat:
	get():
		return _get_regen_stat()
var magnetize_stat:
	get():
		return _get_magnetize_stat()
var lifesteal_stat:
	get():
		return _get_lifesteal_stat()
var shield_stat:
	get():
		return _get_shield_stat()
var difficulty_stat:
	get():
		return _get_difficulty_stat()
var revies_stat:
	get():
		return _get_revies_stat()
var thorns_stat:
	get():
		return _get_thorns_stat()
var inaccuracy_stat:
	get():
		return _get_inaccuracy_stat()
func _get_hp_stat():
	return (GlobalStats.get_base_stat(GlobalStats.HP) + _hp) * GlobalStats.get_factor_stat(GlobalStats.HP)
func _get_stance_stat():
	return (GlobalStats.get_base_stat(GlobalStats.STANCE) + _stance) * GlobalStats.get_factor_stat(GlobalStats.STANCE)
func _get_movespeed_stat():
	return (GlobalStats.get_base_stat(GlobalStats.MOVESPEED) + _movespeed) * GlobalStats.get_factor_stat(GlobalStats.MOVESPEED)
func _get_xp_stat():
	return (GlobalStats.get_base_stat(GlobalStats.XP) + _xp) * GlobalStats.get_factor_stat(GlobalStats.XP)
func _get_mogul_stat():
	return (GlobalStats.get_base_stat(GlobalStats.MOGUL) + _mogul) * GlobalStats.get_factor_stat(GlobalStats.MOGUL)
func _get_luck_stat():
	return (GlobalStats.get_base_stat(GlobalStats.LUCK) + _luck) * GlobalStats.get_factor_stat(GlobalStats.LUCK)
func _get_damage_stat():
	return (GlobalStats.get_base_stat(GlobalStats.DAMAGE) + _damage) * GlobalStats.get_factor_stat(GlobalStats.DAMAGE)
func _get_range_stat():
	return (GlobalStats.get_base_stat(GlobalStats.RANGE) + _range) * GlobalStats.get_factor_stat(GlobalStats.RANGE)
func _get_weight_stat():
	return (GlobalStats.get_base_stat(GlobalStats.WEIGHT) + _weight) * GlobalStats.get_factor_stat(GlobalStats.WEIGHT)
func _get_attackcooldown_stat():
	return (GlobalStats.get_base_stat(GlobalStats.ATTACKCOOLDOWN) + _attackcooldown) * GlobalStats.get_factor_stat(GlobalStats.ATTACKCOOLDOWN)
func _get_reloadtime_stat():
	return (GlobalStats.get_base_stat(GlobalStats.RELOADTIME) + _reloadtime) * GlobalStats.get_factor_stat(GlobalStats.RELOADTIME)
func _get_velocity_stat():
	return (GlobalStats.get_base_stat(GlobalStats.VELOCITY) + _velocity) * GlobalStats.get_factor_stat(GlobalStats.VELOCITY)
func _get_ammo_stat():
	return (GlobalStats.get_base_stat(GlobalStats.AMMO) + _ammo) * GlobalStats.get_factor_stat(GlobalStats.AMMO)
func _get_count_stat():
	return (GlobalStats.get_base_stat(GlobalStats.COUNT) + _count) * GlobalStats.get_factor_stat(GlobalStats.COUNT)
func _get_piercing_stat():
	return (GlobalStats.get_base_stat(GlobalStats.PIERCING) + _piercing) * GlobalStats.get_factor_stat(GlobalStats.PIERCING)
func _get_duration_stat():
	return (GlobalStats.get_base_stat(GlobalStats.DURATION) + _duration) * GlobalStats.get_factor_stat(GlobalStats.DURATION)
func _get_size_stat():
	return (GlobalStats.get_base_stat(GlobalStats.SIZE) + _size) * GlobalStats.get_factor_stat(GlobalStats.SIZE)
func _get_critdamage_stat():
	return (GlobalStats.get_base_stat(GlobalStats.CRITDAMAGE) + _critdamage) * GlobalStats.get_factor_stat(GlobalStats.CRITDAMAGE)
func _get_ghostly_stat():
	return (GlobalStats.get_base_stat(GlobalStats.GHOSTLY) + _ghostly) * GlobalStats.get_factor_stat(GlobalStats.GHOSTLY)
func _get_regen_stat():
	return (GlobalStats.get_base_stat(GlobalStats.REGEN) + _regen) * GlobalStats.get_factor_stat(GlobalStats.REGEN)
func _get_magnetize_stat():
	return (GlobalStats.get_base_stat(GlobalStats.MAGNETIZE) + _magnetize) * GlobalStats.get_factor_stat(GlobalStats.MAGNETIZE)
func _get_lifesteal_stat():
	return (GlobalStats.get_base_stat(GlobalStats.LIFESTEAL) + _lifesteal) * GlobalStats.get_factor_stat(GlobalStats.LIFESTEAL)
func _get_shield_stat():
	return (GlobalStats.get_base_stat(GlobalStats.SHIELD) + _shield) * GlobalStats.get_factor_stat(GlobalStats.SHIELD)
func _get_difficulty_stat():
	return (GlobalStats.get_base_stat(GlobalStats.DIFFICULTY) + _difficulty) * GlobalStats.get_factor_stat(GlobalStats.DIFFICULTY)
func _get_revies_stat():
	return (GlobalStats.get_base_stat(GlobalStats.REVIES) + _revies) * GlobalStats.get_factor_stat(GlobalStats.REVIES)
func _get_thorns_stat():
	return (GlobalStats.get_base_stat(GlobalStats.THORNS) + _thorns) * GlobalStats.get_factor_stat(GlobalStats.THORNS)
func _get_inaccuracy_stat():
	return (GlobalStats.get_base_stat(GlobalStats.INACCURACY) + _inaccuracy) * GlobalStats.get_factor_stat(GlobalStats.INACCURACY)
