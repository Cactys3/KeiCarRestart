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
	GameManager.instance.StatsChanged.connect(stats_changed)
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
## Called when stats change to recalculate things
func stats_changed():
	pass
var game_man: 
	get():
		return GameManager.instance

## Attacks

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
	#var attack: Attack = Attack.new(get_attack_type(), self, get_attack_position(), status, base, factor)
	var attack: Attack = Attack.new(get_attack_source(), get_attack_type(), get_attacker_node(), get_attack_position(), status, base, factor)
	handle_attack(attack)
	return attack
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
func get_attack_source() -> Attack.AttackSources:
	return Attack.AttackSources.unset
func get_attacker_node() -> Node:
	return self
func get_attack_position() -> Vector2:
	return global_position
## Pass attack through game manager as well as custom handles for this node
func handle_attack(attack: Attack):
	game_man.handle_attack(attack)
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
	var ret = (GlobalStats.get_base_stat(GlobalStats.HP) + _hp) * GlobalStats.get_factor_stat(GlobalStats.HP)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_hp_buff) * Statics.weapon_hp_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_hp_buff) * Statics.ability_hp_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_hp_buff) * Statics.upgrade_hp_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_hp_buff) * Statics.melee_hp_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_hp_buff + Statics.spawn_hp_buff) * Statics.projectile_hp_factor * Statics.spawn_hp_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_hp_buff + Statics.spawn_hp_buff) * Statics.trap_hp_factor * Statics.spawn_hp_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_hp_buff + Statics.spawn_hp_buff) * Statics.creation_hp_factor * Statics.spawn_hp_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_hp_buff + Statics.spawn_hp_buff) * Statics.summon_hp_factor * Statics.spawn_hp_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_stance_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.STANCE) + _stance) * GlobalStats.get_factor_stat(GlobalStats.STANCE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_stance_buff) * Statics.weapon_stance_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_stance_buff) * Statics.ability_stance_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_stance_buff) * Statics.upgrade_stance_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_stance_buff) * Statics.melee_stance_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_stance_buff + Statics.spawn_stance_buff) * Statics.projectile_stance_factor * Statics.spawn_stance_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_stance_buff + Statics.spawn_stance_buff) * Statics.trap_stance_factor * Statics.spawn_stance_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_stance_buff + Statics.spawn_stance_buff) * Statics.creation_stance_factor * Statics.spawn_stance_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_stance_buff + Statics.spawn_stance_buff) * Statics.summon_stance_factor * Statics.spawn_stance_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_movespeed_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.MOVESPEED) + _movespeed) * GlobalStats.get_factor_stat(GlobalStats.MOVESPEED)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_movespeed_buff) * Statics.weapon_movespeed_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_movespeed_buff) * Statics.ability_movespeed_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_movespeed_buff) * Statics.upgrade_movespeed_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_movespeed_buff) * Statics.melee_movespeed_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_movespeed_buff + Statics.spawn_movespeed_buff) * Statics.projectile_movespeed_factor * Statics.spawn_movespeed_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_movespeed_buff + Statics.spawn_movespeed_buff) * Statics.trap_movespeed_factor * Statics.spawn_movespeed_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_movespeed_buff + Statics.spawn_movespeed_buff) * Statics.creation_movespeed_factor * Statics.spawn_movespeed_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_movespeed_buff + Statics.spawn_movespeed_buff) * Statics.summon_movespeed_factor * Statics.spawn_movespeed_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_xp_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.XP) + _xp) * GlobalStats.get_factor_stat(GlobalStats.XP)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_xp_buff) * Statics.weapon_xp_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_xp_buff) * Statics.ability_xp_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_xp_buff) * Statics.upgrade_xp_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_xp_buff) * Statics.melee_xp_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_xp_buff + Statics.spawn_xp_buff) * Statics.projectile_xp_factor * Statics.spawn_xp_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_xp_buff + Statics.spawn_xp_buff) * Statics.trap_xp_factor * Statics.spawn_xp_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_xp_buff + Statics.spawn_xp_buff) * Statics.creation_xp_factor * Statics.spawn_xp_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_xp_buff + Statics.spawn_xp_buff) * Statics.summon_xp_factor * Statics.spawn_xp_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_mogul_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.MOGUL) + _mogul) * GlobalStats.get_factor_stat(GlobalStats.MOGUL)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_mogul_buff) * Statics.weapon_mogul_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_mogul_buff) * Statics.ability_mogul_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_mogul_buff) * Statics.upgrade_mogul_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_mogul_buff) * Statics.melee_mogul_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_mogul_buff + Statics.spawn_mogul_buff) * Statics.projectile_mogul_factor * Statics.spawn_mogul_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_mogul_buff + Statics.spawn_mogul_buff) * Statics.trap_mogul_factor * Statics.spawn_mogul_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_mogul_buff + Statics.spawn_mogul_buff) * Statics.creation_mogul_factor * Statics.spawn_mogul_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_mogul_buff + Statics.spawn_mogul_buff) * Statics.summon_mogul_factor * Statics.spawn_mogul_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_luck_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.LUCK) + _luck) * GlobalStats.get_factor_stat(GlobalStats.LUCK)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_luck_buff) * Statics.weapon_luck_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_luck_buff) * Statics.ability_luck_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_luck_buff) * Statics.upgrade_luck_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_luck_buff) * Statics.melee_luck_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_luck_buff + Statics.spawn_luck_buff) * Statics.projectile_luck_factor * Statics.spawn_luck_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_luck_buff + Statics.spawn_luck_buff) * Statics.trap_luck_factor * Statics.spawn_luck_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_luck_buff + Statics.spawn_luck_buff) * Statics.creation_luck_factor * Statics.spawn_luck_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_luck_buff + Statics.spawn_luck_buff) * Statics.summon_luck_factor * Statics.spawn_luck_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_damage_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.DAMAGE) + _damage) * GlobalStats.get_factor_stat(GlobalStats.DAMAGE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_damage_buff) * Statics.weapon_damage_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_damage_buff) * Statics.ability_damage_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_damage_buff) * Statics.upgrade_damage_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_damage_buff) * Statics.melee_damage_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_damage_buff + Statics.spawn_damage_buff) * Statics.projectile_damage_factor * Statics.spawn_damage_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_damage_buff + Statics.spawn_damage_buff) * Statics.trap_damage_factor * Statics.spawn_damage_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_damage_buff + Statics.spawn_damage_buff) * Statics.creation_damage_factor * Statics.spawn_damage_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_damage_buff + Statics.spawn_damage_buff) * Statics.summon_damage_factor * Statics.spawn_damage_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_range_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.RANGE) + _range) * GlobalStats.get_factor_stat(GlobalStats.RANGE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_range_buff) * Statics.weapon_range_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_range_buff) * Statics.ability_range_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_range_buff) * Statics.upgrade_range_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_range_buff) * Statics.melee_range_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_range_buff + Statics.spawn_range_buff) * Statics.projectile_range_factor * Statics.spawn_range_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_range_buff + Statics.spawn_range_buff) * Statics.trap_range_factor * Statics.spawn_range_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_range_buff + Statics.spawn_range_buff) * Statics.creation_range_factor * Statics.spawn_range_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_range_buff + Statics.spawn_range_buff) * Statics.summon_range_factor * Statics.spawn_range_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_weight_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.WEIGHT) + _weight) * GlobalStats.get_factor_stat(GlobalStats.WEIGHT)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_weight_buff) * Statics.weapon_weight_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_weight_buff) * Statics.ability_weight_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_weight_buff) * Statics.upgrade_weight_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_weight_buff) * Statics.melee_weight_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_weight_buff + Statics.spawn_weight_buff) * Statics.projectile_weight_factor * Statics.spawn_weight_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_weight_buff + Statics.spawn_weight_buff) * Statics.trap_weight_factor * Statics.spawn_weight_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_weight_buff + Statics.spawn_weight_buff) * Statics.creation_weight_factor * Statics.spawn_weight_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_weight_buff + Statics.spawn_weight_buff) * Statics.summon_weight_factor * Statics.spawn_weight_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_attackcooldown_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.ATTACKCOOLDOWN) + _attackcooldown) * GlobalStats.get_factor_stat(GlobalStats.ATTACKCOOLDOWN)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_attackcooldown_buff) * Statics.weapon_attackcooldown_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_attackcooldown_buff) * Statics.ability_attackcooldown_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_attackcooldown_buff) * Statics.upgrade_attackcooldown_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_attackcooldown_buff) * Statics.melee_attackcooldown_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_attackcooldown_buff + Statics.spawn_attackcooldown_buff) * Statics.projectile_attackcooldown_factor * Statics.spawn_attackcooldown_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_attackcooldown_buff + Statics.spawn_attackcooldown_buff) * Statics.trap_attackcooldown_factor * Statics.spawn_attackcooldown_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_attackcooldown_buff + Statics.spawn_attackcooldown_buff) * Statics.creation_attackcooldown_factor * Statics.spawn_attackcooldown_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_attackcooldown_buff + Statics.spawn_attackcooldown_buff) * Statics.summon_attackcooldown_factor * Statics.spawn_attackcooldown_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_reloadtime_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.RELOADTIME) + _reloadtime) * GlobalStats.get_factor_stat(GlobalStats.RELOADTIME)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_reloadtime_buff) * Statics.weapon_reloadtime_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_reloadtime_buff) * Statics.ability_reloadtime_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_reloadtime_buff) * Statics.upgrade_reloadtime_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_reloadtime_buff) * Statics.melee_reloadtime_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_reloadtime_buff + Statics.spawn_reloadtime_buff) * Statics.projectile_reloadtime_factor * Statics.spawn_reloadtime_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_reloadtime_buff + Statics.spawn_reloadtime_buff) * Statics.trap_reloadtime_factor * Statics.spawn_reloadtime_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_reloadtime_buff + Statics.spawn_reloadtime_buff) * Statics.creation_reloadtime_factor * Statics.spawn_reloadtime_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_reloadtime_buff + Statics.spawn_reloadtime_buff) * Statics.summon_reloadtime_factor * Statics.spawn_reloadtime_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_velocity_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.VELOCITY) + _velocity) * GlobalStats.get_factor_stat(GlobalStats.VELOCITY)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_velocity_buff) * Statics.weapon_velocity_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_velocity_buff) * Statics.ability_velocity_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_velocity_buff) * Statics.upgrade_velocity_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_velocity_buff) * Statics.melee_velocity_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_velocity_buff + Statics.spawn_velocity_buff) * Statics.projectile_velocity_factor * Statics.spawn_velocity_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_velocity_buff + Statics.spawn_velocity_buff) * Statics.trap_velocity_factor * Statics.spawn_velocity_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_velocity_buff + Statics.spawn_velocity_buff) * Statics.creation_velocity_factor * Statics.spawn_velocity_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_velocity_buff + Statics.spawn_velocity_buff) * Statics.summon_velocity_factor * Statics.spawn_velocity_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_ammo_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.AMMO) + _ammo) * GlobalStats.get_factor_stat(GlobalStats.AMMO)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_ammo_buff) * Statics.weapon_ammo_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_ammo_buff) * Statics.ability_ammo_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_ammo_buff) * Statics.upgrade_ammo_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_ammo_buff) * Statics.melee_ammo_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_ammo_buff + Statics.spawn_ammo_buff) * Statics.projectile_ammo_factor * Statics.spawn_ammo_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_ammo_buff + Statics.spawn_ammo_buff) * Statics.trap_ammo_factor * Statics.spawn_ammo_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_ammo_buff + Statics.spawn_ammo_buff) * Statics.creation_ammo_factor * Statics.spawn_ammo_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_ammo_buff + Statics.spawn_ammo_buff) * Statics.summon_ammo_factor * Statics.spawn_ammo_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_count_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.COUNT) + _count) * GlobalStats.get_factor_stat(GlobalStats.COUNT)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_count_buff) * Statics.weapon_count_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_count_buff) * Statics.ability_count_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_count_buff) * Statics.upgrade_count_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_count_buff) * Statics.melee_count_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_count_buff + Statics.spawn_count_buff) * Statics.projectile_count_factor * Statics.spawn_count_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_count_buff + Statics.spawn_count_buff) * Statics.trap_count_factor * Statics.spawn_count_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_count_buff + Statics.spawn_count_buff) * Statics.creation_count_factor * Statics.spawn_count_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_count_buff + Statics.spawn_count_buff) * Statics.summon_count_factor * Statics.spawn_count_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_piercing_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.PIERCING) + _piercing) * GlobalStats.get_factor_stat(GlobalStats.PIERCING)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_piercing_buff) * Statics.weapon_piercing_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_piercing_buff) * Statics.ability_piercing_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_piercing_buff) * Statics.upgrade_piercing_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_piercing_buff) * Statics.melee_piercing_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_piercing_buff + Statics.spawn_piercing_buff) * Statics.projectile_piercing_factor * Statics.spawn_piercing_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_piercing_buff + Statics.spawn_piercing_buff) * Statics.trap_piercing_factor * Statics.spawn_piercing_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_piercing_buff + Statics.spawn_piercing_buff) * Statics.creation_piercing_factor * Statics.spawn_piercing_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_piercing_buff + Statics.spawn_piercing_buff) * Statics.summon_piercing_factor * Statics.spawn_piercing_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_duration_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.DURATION) + _duration) * GlobalStats.get_factor_stat(GlobalStats.DURATION)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_duration_buff) * Statics.weapon_duration_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_duration_buff) * Statics.ability_duration_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_duration_buff) * Statics.upgrade_duration_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_duration_buff) * Statics.melee_duration_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_duration_buff + Statics.spawn_duration_buff) * Statics.projectile_duration_factor * Statics.spawn_duration_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_duration_buff + Statics.spawn_duration_buff) * Statics.trap_duration_factor * Statics.spawn_duration_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_duration_buff + Statics.spawn_duration_buff) * Statics.creation_duration_factor * Statics.spawn_duration_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_duration_buff + Statics.spawn_duration_buff) * Statics.summon_duration_factor * Statics.spawn_duration_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_size_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.SIZE) + _size + 1) * GlobalStats.get_factor_stat(GlobalStats.SIZE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_size_buff) * Statics.weapon_size_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_size_buff) * Statics.ability_size_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_size_buff) * Statics.upgrade_size_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_size_buff) * Statics.melee_size_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_size_buff + Statics.spawn_size_buff) * Statics.projectile_size_factor * Statics.spawn_size_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_size_buff + Statics.spawn_size_buff) * Statics.trap_size_factor * Statics.spawn_size_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_size_buff + Statics.spawn_size_buff) * Statics.creation_size_factor * Statics.spawn_size_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_size_buff + Statics.spawn_size_buff) * Statics.summon_size_factor * Statics.spawn_size_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_critdamage_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.CRITDAMAGE) + _critdamage) * GlobalStats.get_factor_stat(GlobalStats.CRITDAMAGE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_critdamage_buff) * Statics.weapon_critdamage_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_critdamage_buff) * Statics.ability_critdamage_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_critdamage_buff) * Statics.upgrade_critdamage_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_critdamage_buff) * Statics.melee_critdamage_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_critdamage_buff + Statics.spawn_critdamage_buff) * Statics.projectile_critdamage_factor * Statics.spawn_critdamage_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_critdamage_buff + Statics.spawn_critdamage_buff) * Statics.trap_critdamage_factor * Statics.spawn_critdamage_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_critdamage_buff + Statics.spawn_critdamage_buff) * Statics.creation_critdamage_factor * Statics.spawn_critdamage_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_critdamage_buff + Statics.spawn_critdamage_buff) * Statics.summon_critdamage_factor * Statics.spawn_critdamage_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_ghostly_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.GHOSTLY) + _ghostly) * GlobalStats.get_factor_stat(GlobalStats.GHOSTLY)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_ghostly_buff) * Statics.weapon_ghostly_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_ghostly_buff) * Statics.ability_ghostly_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_ghostly_buff) * Statics.upgrade_ghostly_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_ghostly_buff) * Statics.melee_ghostly_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_ghostly_buff + Statics.spawn_ghostly_buff) * Statics.projectile_ghostly_factor * Statics.spawn_ghostly_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_ghostly_buff + Statics.spawn_ghostly_buff) * Statics.trap_ghostly_factor * Statics.spawn_ghostly_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_ghostly_buff + Statics.spawn_ghostly_buff) * Statics.creation_ghostly_factor * Statics.spawn_ghostly_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_ghostly_buff + Statics.spawn_ghostly_buff) * Statics.summon_ghostly_factor * Statics.spawn_ghostly_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_regen_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.REGEN) + _regen) * GlobalStats.get_factor_stat(GlobalStats.REGEN)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_regen_buff) * Statics.weapon_regen_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_regen_buff) * Statics.ability_regen_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_regen_buff) * Statics.upgrade_regen_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_regen_buff) * Statics.melee_regen_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_regen_buff + Statics.spawn_regen_buff) * Statics.projectile_regen_factor * Statics.spawn_regen_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_regen_buff + Statics.spawn_regen_buff) * Statics.trap_regen_factor * Statics.spawn_regen_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_regen_buff + Statics.spawn_regen_buff) * Statics.creation_regen_factor * Statics.spawn_regen_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_regen_buff + Statics.spawn_regen_buff) * Statics.summon_regen_factor * Statics.spawn_regen_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_magnetize_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.MAGNETIZE) + _magnetize) * GlobalStats.get_factor_stat(GlobalStats.MAGNETIZE)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_magnetize_buff) * Statics.weapon_magnetize_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_magnetize_buff) * Statics.ability_magnetize_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_magnetize_buff) * Statics.upgrade_magnetize_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_magnetize_buff) * Statics.melee_magnetize_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_magnetize_buff + Statics.spawn_magnetize_buff) * Statics.projectile_magnetize_factor * Statics.spawn_magnetize_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_magnetize_buff + Statics.spawn_magnetize_buff) * Statics.trap_magnetize_factor * Statics.spawn_magnetize_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_magnetize_buff + Statics.spawn_magnetize_buff) * Statics.creation_magnetize_factor * Statics.spawn_magnetize_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_magnetize_buff + Statics.spawn_magnetize_buff) * Statics.summon_magnetize_factor * Statics.spawn_magnetize_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_lifesteal_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.LIFESTEAL) + _lifesteal) * GlobalStats.get_factor_stat(GlobalStats.LIFESTEAL)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_lifesteal_buff) * Statics.weapon_lifesteal_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_lifesteal_buff) * Statics.ability_lifesteal_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_lifesteal_buff) * Statics.upgrade_lifesteal_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_lifesteal_buff) * Statics.melee_lifesteal_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_lifesteal_buff + Statics.spawn_lifesteal_buff) * Statics.projectile_lifesteal_factor * Statics.spawn_lifesteal_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_lifesteal_buff + Statics.spawn_lifesteal_buff) * Statics.trap_lifesteal_factor * Statics.spawn_lifesteal_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_lifesteal_buff + Statics.spawn_lifesteal_buff) * Statics.creation_lifesteal_factor * Statics.spawn_lifesteal_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_lifesteal_buff + Statics.spawn_lifesteal_buff) * Statics.summon_lifesteal_factor * Statics.spawn_lifesteal_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_shield_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.SHIELD) + _shield) * GlobalStats.get_factor_stat(GlobalStats.SHIELD)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_shield_buff) * Statics.weapon_shield_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_shield_buff) * Statics.ability_shield_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_shield_buff) * Statics.upgrade_shield_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_shield_buff) * Statics.melee_shield_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_shield_buff + Statics.spawn_shield_buff) * Statics.projectile_shield_factor * Statics.spawn_shield_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_shield_buff + Statics.spawn_shield_buff) * Statics.trap_shield_factor * Statics.spawn_shield_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_shield_buff + Statics.spawn_shield_buff) * Statics.creation_shield_factor * Statics.spawn_shield_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_shield_buff + Statics.spawn_shield_buff) * Statics.summon_shield_factor * Statics.spawn_shield_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_difficulty_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.DIFFICULTY) + _difficulty) * GlobalStats.get_factor_stat(GlobalStats.DIFFICULTY)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_difficulty_buff) * Statics.weapon_difficulty_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_difficulty_buff) * Statics.ability_difficulty_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_difficulty_buff) * Statics.upgrade_difficulty_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_difficulty_buff) * Statics.melee_difficulty_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_difficulty_buff + Statics.spawn_difficulty_buff) * Statics.projectile_difficulty_factor * Statics.spawn_difficulty_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_difficulty_buff + Statics.spawn_difficulty_buff) * Statics.trap_difficulty_factor * Statics.spawn_difficulty_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_difficulty_buff + Statics.spawn_difficulty_buff) * Statics.creation_difficulty_factor * Statics.spawn_difficulty_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_difficulty_buff + Statics.spawn_difficulty_buff) * Statics.summon_difficulty_factor * Statics.spawn_difficulty_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_revies_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.REVIES) + _revies) * GlobalStats.get_factor_stat(GlobalStats.REVIES)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_revies_buff) * Statics.weapon_revies_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_revies_buff) * Statics.ability_revies_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_revies_buff) * Statics.upgrade_revies_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_revies_buff) * Statics.melee_revies_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_revies_buff + Statics.spawn_revies_buff) * Statics.projectile_revies_factor * Statics.spawn_revies_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_revies_buff + Statics.spawn_revies_buff) * Statics.trap_revies_factor * Statics.spawn_revies_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_revies_buff + Statics.spawn_revies_buff) * Statics.creation_revies_factor * Statics.spawn_revies_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_revies_buff + Statics.spawn_revies_buff) * Statics.summon_revies_factor * Statics.spawn_revies_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_thorns_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.THORNS) + _thorns) * GlobalStats.get_factor_stat(GlobalStats.THORNS)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_thorns_buff) * Statics.weapon_thorns_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_thorns_buff) * Statics.ability_thorns_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_thorns_buff) * Statics.upgrade_thorns_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_thorns_buff) * Statics.melee_thorns_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_thorns_buff + Statics.spawn_thorns_buff) * Statics.projectile_thorns_factor * Statics.spawn_thorns_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_thorns_buff + Statics.spawn_thorns_buff) * Statics.trap_thorns_factor * Statics.spawn_thorns_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_thorns_buff + Statics.spawn_thorns_buff) * Statics.creation_thorns_factor * Statics.spawn_thorns_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_thorns_buff + Statics.spawn_thorns_buff) * Statics.summon_thorns_factor * Statics.spawn_thorns_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
func _get_inaccuracy_stat():
	var ret = (GlobalStats.get_base_stat(GlobalStats.INACCURACY) + _inaccuracy) * GlobalStats.get_factor_stat(GlobalStats.INACCURACY)
	## Source
	match get_attack_source():
		Attack.AttackSources.weapon:
			ret = (ret + Statics.weapon_inaccuracy_buff) * Statics.weapon_inaccuracy_factor
		Attack.AttackSources.ability:
			ret = (ret + Statics.ability_inaccuracy_buff) * Statics.ability_inaccuracy_factor
		Attack.AttackSources.upgrade:
			ret = (ret + Statics.upgrade_inaccuracy_buff) * Statics.upgrade_inaccuracy_factor
		Attack.AttackSources.unset:
			push_error("Unset Attack source When Accessing Stats")
	## Type
	match get_attack_type():
		Attack.AttackTypes.melee:
			ret = (ret + Statics.melee_inaccuracy_buff) * Statics.melee_inaccuracy_factor
		Attack.AttackTypes.projectile:
			ret = (ret + Statics.projectile_inaccuracy_buff + Statics.spawn_inaccuracy_buff) * Statics.projectile_inaccuracy_factor * Statics.spawn_inaccuracy_factor
		Attack.AttackTypes.trap:
			ret = (ret + Statics.trap_inaccuracy_buff + Statics.spawn_inaccuracy_buff) * Statics.trap_inaccuracy_factor * Statics.spawn_inaccuracy_factor
		Attack.AttackTypes.creation:
			ret = (ret + Statics.creation_inaccuracy_buff + Statics.spawn_inaccuracy_buff) * Statics.creation_inaccuracy_factor * Statics.spawn_inaccuracy_factor
		Attack.AttackTypes.summon:
			ret = (ret + Statics.summon_inaccuracy_buff + Statics.spawn_inaccuracy_buff) * Statics.summon_inaccuracy_factor * Statics.spawn_inaccuracy_factor
		Attack.AttackTypes.unset:
			push_error("Unset Attack type When Accessing Stats")
	return ret
