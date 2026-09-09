extends Resource
class_name Statics

static func changed_stats():
	GameManager.instance.StatsChanged.emit()

## Tracking Variables:

## Number of currently active spawns
static var active_summons: int = 0
static var active_traps: int = 0
static var active_creations: int = 0
static var active_projectiles: int = 0

## Buff Variables:

## Global Buffs
static var global_crit_damage_factor: float = 1.5 
static var global_damage_buff: float = 0
static var global_projectile_size_buff: float = 0

## General Upgrade Buffs
static var upgrade_buff_duration_buff: float = 0 ## Duration of buffs applied by upgrades that are limited time
static var upgrade_cooldown_rate: float = 1 ## Number of seconds added to cooldown stopwatch each second


## Status Buffs
## Increase debuff by x each proc
static var enemy_frost_frozen_duration: float = 2
static var enemy_frost_movespeed_reduction: float = 5
static var enemy_shock_defense_reduction: float = 5
## Multiplier increase of enemy status threshold after each proc
static var enemy_bleed_threshold_multiplier: float = 1.7
static var enemy_frost_threshold_multiplier: float = 2
## Raw Burn damage
static var burn_buff_base: float = 0
static var burn_buff_factor: float = 1
## Trigger based buffs (applied in places where things are spawned via specific triggers)
static var reload_spawns_count_buff: int = 0
## Player Buffs
static var player_movespeed_buff: float = 0
static var player_size_buff: float = 0
static var player_xp_gain_buff: float = 0
static var player_magnetize_buff: float = 0
static var player_ghostly_buff: float = 0
static var player_mogul_buff: float = 0
static var player_hp_buff: float = 0
static var player_regen_buff: float = 0
static var player_lifesteal_buff: float = 0
static var player_thorns_buff: float = 0
static var player_shield_buff: float = 0
static var player_revives_buff: float = 0
static var player_stance_buff: float = 0
static var player_knockback_resistance_buff: float = 0
## Trackers for specific Upgrades
static var enemies_lose_health_while_feared: float = 0 # value > 0 means true
static var bleeds_crit_on_enemy: float = 0 # value > 0 means true

## Melee Only Buffs
## Projectile Only Buffs
static var projectile_pierce_damage_buff: float = 0 ## Additional percent damage after piercing for projectiles
static var projectile_pierce_damage_buff_doubled_on_kill: bool = false ## Is the percent doubled if enemy is killed
static var additional_projectiles_damage_debuff: float = 0 ## percent less damage that projectiles that can spawn multiple do when certian upgrades are active
## Trap Only Buffs
## Creation Only Buffs
## Summon Only Buffs
static var creation_dodge_buff: float = 0
static var creation_dodges_count_for_player: float = 0 # value > 0 means true
## Spawn Only Buffs

## Number of additional spawns per spawn 
static var melee_count_buff: float = 0
static var projectile_count_buff: float = 0
static var trap_count_buff: float = 0
static var creation_count_buff: float = 0
static var summon_count_buff: float = 0
static var spawn_count_buff: float = 0
static var weapon_count_buff: float = 0
static var ability_count_buff: float = 0
static var upgrade_count_buff: float = 0
## Duration Increases for each spawn 
static var melee_duration_buff: float = 0
static var projectile_duration_buff: float = 0
static var trap_duration_buff: float = 0
static var creation_duration_buff: float = 0
static var summon_duration_buff: float = 0
static var spawn_duration_buff: float = 0
static var weapon_duration_buff: float = 0
static var ability_duration_buff: float = 0
static var upgrade_duration_buff: float = 0
## Damage Increases for each spawn
static var melee_damage_buff: float = 0
static var projectile_damage_buff: float = 0
static var trap_damage_buff: float = 0
static var creation_damage_buff: float = 0
static var summon_damage_buff: float = 0
static var spawn_damage_buff: float = 0
static var weapon_damage_buff: float = 0
static var ability_damage_buff: float = 0
static var upgrade_damage_buff: float = 0
## Size Increases for each spawn 
static var melee_size_buff: float = 0
static var projectile_size_buff: float = 0
static var trap_size_buff: float = 0
static var creation_size_buff: float = 0
static var summon_size_buff: float = 0
static var spawn_size_buff: float = 0
static var weapon_size_buff: float = 0
static var ability_size_buff: float = 0
static var upgrade_size_buff: float = 0
## HP
static var melee_hp_buff: float = 0
static var projectile_hp_buff: float = 0
static var trap_hp_buff: float = 0
static var creation_hp_buff: float = 0
static var summon_hp_buff: float = 0
static var spawn_hp_buff: float = 0
static var weapon_hp_buff: float = 0
static var ability_hp_buff: float = 0
static var upgrade_hp_buff: float = 0
## Stance
static var melee_stance_buff: float = 0
static var projectile_stance_buff: float = 0
static var trap_stance_buff: float = 0
static var creation_stance_buff: float = 0
static var summon_stance_buff: float = 0
static var spawn_stance_buff: float = 0
static var weapon_stance_buff: float = 0
static var ability_stance_buff: float = 0
static var upgrade_stance_buff: float = 0
## Movespeed
static var melee_movespeed_buff: float = 0
static var projectile_movespeed_buff: float = 0
static var trap_movespeed_buff: float = 0
static var creation_movespeed_buff: float = 0
static var summon_movespeed_buff: float = 0
static var spawn_movespeed_buff: float = 0
static var weapon_movespeed_buff: float = 0
static var ability_movespeed_buff: float = 0
static var upgrade_movespeed_buff: float = 0
## XP
static var melee_xp_buff: float = 0
static var projectile_xp_buff: float = 0
static var trap_xp_buff: float = 0
static var creation_xp_buff: float = 0
static var summon_xp_buff: float = 0
static var spawn_xp_buff: float = 0
static var weapon_xp_buff: float = 0
static var ability_xp_buff: float = 0
static var upgrade_xp_buff: float = 0
## Mogul
static var melee_mogul_buff: float = 0
static var projectile_mogul_buff: float = 0
static var trap_mogul_buff: float = 0
static var creation_mogul_buff: float = 0
static var summon_mogul_buff: float = 0
static var spawn_mogul_buff: float = 0
static var weapon_mogul_buff: float = 0
static var ability_mogul_buff: float = 0
static var upgrade_mogul_buff: float = 0
## Luck
static var melee_luck_buff: float = 0
static var projectile_luck_buff: float = 0
static var trap_luck_buff: float = 0
static var creation_luck_buff: float = 0
static var summon_luck_buff: float = 0
static var spawn_luck_buff: float = 0
static var weapon_luck_buff: float = 0
static var ability_luck_buff: float = 0
static var upgrade_luck_buff: float = 0
## Range
static var melee_range_buff: float = 0
static var projectile_range_buff: float = 0
static var trap_range_buff: float = 0
static var creation_range_buff: float = 0
static var summon_range_buff: float = 0
static var spawn_range_buff: float = 0
static var weapon_range_buff: float = 0
static var ability_range_buff: float = 0
static var upgrade_range_buff: float = 0
## Weight
static var melee_weight_buff: float = 0
static var projectile_weight_buff: float = 0
static var trap_weight_buff: float = 0
static var creation_weight_buff: float = 0
static var summon_weight_buff: float = 0
static var spawn_weight_buff: float = 0
static var weapon_weight_buff: float = 0
static var ability_weight_buff: float = 0
static var upgrade_weight_buff: float = 0
## Attackcooldown
static var melee_attackcooldown_buff: float = 0
static var projectile_attackcooldown_buff: float = 0
static var trap_attackcooldown_buff: float = 0
static var creation_attackcooldown_buff: float = 0
static var summon_attackcooldown_buff: float = 0
static var spawn_attackcooldown_buff: float = 0
static var weapon_attackcooldown_buff: float = 0
static var ability_attackcooldown_buff: float = 0
static var upgrade_attackcooldown_buff: float = 0
## Attackspeed
static var melee_attackspeed_buff: float = 0
static var projectile_attackspeed_buff: float = 0
static var trap_attackspeed_buff: float = 0
static var creation_attackspeed_buff: float = 0
static var summon_attackspeed_buff: float = 0
static var spawn_attackspeed_buff: float = 0
static var weapon_attackspeed_buff: float = 0
static var ability_attackspeed_buff: float = 0
static var upgrade_attackspeed_buff: float = 0
## Reloadtime 
static var melee_reloadtime_buff: float = 0
static var projectile_reloadtime_buff: float = 0
static var trap_reloadtime_buff: float = 0
static var creation_reloadtime_buff: float = 0
static var summon_reloadtime_buff: float = 0
static var spawn_reloadtime_buff: float = 0
static var weapon_reloadtime_buff: float = 0
static var ability_reloadtime_buff: float = 0
static var upgrade_reloadtime_buff: float = 0
## Velocity
static var melee_velocity_buff: float = 0
static var projectile_velocity_buff: float = 0
static var trap_velocity_buff: float = 0
static var creation_velocity_buff: float = 0
static var summon_velocity_buff: float = 0
static var spawn_velocity_buff: float = 0
static var weapon_velocity_buff: float = 0
static var ability_velocity_buff: float = 0
static var upgrade_velocity_buff: float = 0
## Ammo
static var melee_ammo_buff: float = 0
static var projectile_ammo_buff: float = 0
static var trap_ammo_buff: float = 0
static var creation_ammo_buff: float = 0
static var summon_ammo_buff: float = 0
static var spawn_ammo_buff: float = 0
static var weapon_ammo_buff: float = 0
static var ability_ammo_buff: float = 0
static var upgrade_ammo_buff: float = 0
## Piercing
static var melee_piercing_buff: float = 0
static var projectile_piercing_buff: float = 0
static var trap_piercing_buff: float = 0
static var creation_piercing_buff: float = 0
static var summon_piercing_buff: float = 0
static var spawn_piercing_buff: float = 0
static var weapon_piercing_buff: float = 0
static var ability_piercing_buff: float = 0
static var upgrade_piercing_buff: float = 0
## Critdamage
static var melee_critdamage_buff: float = 0
static var projectile_critdamage_buff: float = 0
static var trap_critdamage_buff: float = 0
static var creation_critdamage_buff: float = 0
static var summon_critdamage_buff: float = 0
static var spawn_critdamage_buff: float = 0
static var weapon_critdamage_buff: float = 0
static var ability_critdamage_buff: float = 0
static var upgrade_critdamage_buff: float = 0
## Ghostly
static var melee_ghostly_buff: float = 0
static var projectile_ghostly_buff: float = 0
static var trap_ghostly_buff: float = 0
static var creation_ghostly_buff: float = 0
static var summon_ghostly_buff: float = 0
static var spawn_ghostly_buff: float = 0
static var weapon_ghostly_buff: float = 0
static var ability_ghostly_buff: float = 0
static var upgrade_ghostly_buff: float = 0
## Regen
static var melee_regen_buff: float = 0
static var projectile_regen_buff: float = 0
static var trap_regen_buff: float = 0
static var creation_regen_buff: float = 0
static var summon_regen_buff: float = 0
static var spawn_regen_buff: float = 0
static var weapon_regen_buff: float = 0
static var ability_regen_buff: float = 0
static var upgrade_regen_buff: float = 0
## Magnetize
static var melee_magnetize_buff: float = 0
static var projectile_magnetize_buff: float = 0
static var trap_magnetize_buff: float = 0
static var creation_magnetize_buff: float = 0
static var summon_magnetize_buff: float = 0
static var spawn_magnetize_buff: float = 0
static var weapon_magnetize_buff: float = 0
static var ability_magnetize_buff: float = 0
static var upgrade_magnetize_buff: float = 0
## Lifesteal
static var melee_lifesteal_buff: float = 0
static var projectile_lifesteal_buff: float = 0
static var trap_lifesteal_buff: float = 0
static var creation_lifesteal_buff: float = 0
static var summon_lifesteal_buff: float = 0
static var spawn_lifesteal_buff: float = 0
static var weapon_lifesteal_buff: float = 0
static var ability_lifesteal_buff: float = 0
static var upgrade_lifesteal_buff: float = 0
## Shield
static var melee_shield_buff: float = 0
static var projectile_shield_buff: float = 0
static var trap_shield_buff: float = 0
static var creation_shield_buff: float = 0
static var summon_shield_buff: float = 0
static var spawn_shield_buff: float = 0
static var weapon_shield_buff: float = 0
static var ability_shield_buff: float = 0
static var upgrade_shield_buff: float = 0
## Difficulty
static var melee_difficulty_buff: float = 0
static var projectile_difficulty_buff: float = 0
static var trap_difficulty_buff: float = 0
static var creation_difficulty_buff: float = 0
static var summon_difficulty_buff: float = 0
static var spawn_difficulty_buff: float = 0
static var weapon_difficulty_buff: float = 0
static var ability_difficulty_buff: float = 0
static var upgrade_difficulty_buff: float = 0
## Revies
static var melee_revies_buff: float = 0
static var projectile_revies_buff: float = 0
static var trap_revies_buff: float = 0
static var creation_revies_buff: float = 0
static var summon_revies_buff: float = 0
static var spawn_revies_buff: float = 0
static var weapon_revies_buff: float = 0
static var ability_revies_buff: float = 0
static var upgrade_revies_buff: float = 0
## Thorns
static var melee_thorns_buff: float = 0
static var projectile_thorns_buff: float = 0
static var trap_thorns_buff: float = 0
static var creation_thorns_buff: float = 0
static var summon_thorns_buff: float = 0
static var spawn_thorns_buff: float = 0
static var weapon_thorns_buff: float = 0
static var ability_thorns_buff: float = 0
static var upgrade_thorns_buff: float = 0
## Inaccuracy
static var melee_inaccuracy_buff: float = 0
static var projectile_inaccuracy_buff: float = 0
static var trap_inaccuracy_buff: float = 0
static var creation_inaccuracy_buff: float = 0
static var summon_inaccuracy_buff: float = 0
static var spawn_inaccuracy_buff: float = 0
static var weapon_inaccuracy_buff: float = 0
static var ability_inaccuracy_buff: float = 0
static var upgrade_inaccuracy_buff: float = 0

## Factor Buffs (adds directly to factor stats)

## count
static var melee_count_factor: float = 1
static var projectile_count_factor: float = 1
static var trap_count_factor: float = 1
static var creation_count_factor: float = 1
static var summon_count_factor: float = 1
static var spawn_count_factor: float = 1
static var weapon_count_factor: float = 1
static var ability_count_factor: float = 1
static var upgrade_count_factor: float = 1
## duration
static var melee_duration_factor: float = 1
static var projectile_duration_factor: float = 1
static var trap_duration_factor: float = 1
static var creation_duration_factor: float = 1
static var summon_duration_factor: float = 1
static var spawn_duration_factor: float = 1
static var weapon_duration_factor: float = 1
static var ability_duration_factor: float = 1
static var upgrade_duration_factor: float = 1
## damage
static var melee_damage_factor: float = 1
static var projectile_damage_factor: float = 1
static var trap_damage_factor: float = 1
static var creation_damage_factor: float = 1
static var summon_damage_factor: float = 1
static var spawn_damage_factor: float = 1
static var weapon_damage_factor: float = 1
static var ability_damage_factor: float = 1
static var upgrade_damage_factor: float = 1
## size
static var melee_size_factor: float = 1
static var projectile_size_factor: float = 1
static var trap_size_factor: float = 1
static var creation_size_factor: float = 1
static var summon_size_factor: float = 1
static var spawn_size_factor: float = 1
static var weapon_size_factor: float = 1
static var ability_size_factor: float = 1
static var upgrade_size_factor: float = 1
## hp
static var melee_hp_factor: float = 1
static var projectile_hp_factor: float = 1
static var trap_hp_factor: float = 1
static var creation_hp_factor: float = 1
static var summon_hp_factor: float = 1
static var spawn_hp_factor: float = 1
static var weapon_hp_factor: float = 1
static var ability_hp_factor: float = 1
static var upgrade_hp_factor: float = 1
## stance
static var melee_stance_factor: float = 1
static var projectile_stance_factor: float = 1
static var trap_stance_factor: float = 1
static var creation_stance_factor: float = 1
static var summon_stance_factor: float = 1
static var spawn_stance_factor: float = 1
static var weapon_stance_factor: float = 1
static var ability_stance_factor: float = 1
static var upgrade_stance_factor: float = 1
## movespeed
static var melee_movespeed_factor: float = 1
static var projectile_movespeed_factor: float = 1
static var trap_movespeed_factor: float = 1
static var creation_movespeed_factor: float = 1
static var summon_movespeed_factor: float = 1
static var spawn_movespeed_factor: float = 1
static var weapon_movespeed_factor: float = 1
static var ability_movespeed_factor: float = 1
static var upgrade_movespeed_factor: float = 1
## xp
static var melee_xp_factor: float = 1
static var projectile_xp_factor: float = 1
static var trap_xp_factor: float = 1
static var creation_xp_factor: float = 1
static var summon_xp_factor: float = 1
static var spawn_xp_factor: float = 1
static var weapon_xp_factor: float = 1
static var ability_xp_factor: float = 1
static var upgrade_xp_factor: float = 1
## mogul
static var melee_mogul_factor: float = 1
static var projectile_mogul_factor: float = 1
static var trap_mogul_factor: float = 1
static var creation_mogul_factor: float = 1
static var summon_mogul_factor: float = 1
static var spawn_mogul_factor: float = 1
static var weapon_mogul_factor: float = 1
static var ability_mogul_factor: float = 1
static var upgrade_mogul_factor: float = 1
## luck
static var melee_luck_factor: float = 1
static var projectile_luck_factor: float = 1
static var trap_luck_factor: float = 1
static var creation_luck_factor: float = 1
static var summon_luck_factor: float = 1
static var spawn_luck_factor: float = 1
static var weapon_luck_factor: float = 1
static var ability_luck_factor: float = 1
static var upgrade_luck_factor: float = 1
## range
static var melee_range_factor: float = 1
static var projectile_range_factor: float = 1
static var trap_range_factor: float = 1
static var creation_range_factor: float = 1
static var summon_range_factor: float = 1
static var spawn_range_factor: float = 1
static var weapon_range_factor: float = 1
static var ability_range_factor: float = 1
static var upgrade_range_factor: float = 1
## weight
static var melee_weight_factor: float = 1
static var projectile_weight_factor: float = 1
static var trap_weight_factor: float = 1
static var creation_weight_factor: float = 1
static var summon_weight_factor: float = 1
static var spawn_weight_factor: float = 1
static var weapon_weight_factor: float = 1
static var ability_weight_factor: float = 1
static var upgrade_weight_factor: float = 1
## attackcooldown
static var melee_attackcooldown_factor: float = 1
static var projectile_attackcooldown_factor: float = 1
static var trap_attackcooldown_factor: float = 1
static var creation_attackcooldown_factor: float = 1
static var summon_attackcooldown_factor: float = 1
static var spawn_attackcooldown_factor: float = 1
static var weapon_attackcooldown_factor: float = 1
static var ability_attackcooldown_factor: float = 1
static var upgrade_attackcooldown_factor: float = 1
## attackspeed
static var melee_attackspeed_factor: float = 1
static var projectile_attackspeed_factor: float = 1
static var trap_attackspeed_factor: float = 1
static var creation_attackspeed_factor: float = 1
static var summon_attackspeed_factor: float = 1
static var spawn_attackspeed_factor: float = 1
static var weapon_attackspeed_factor: float = 1
static var ability_attackspeed_factor: float = 1
static var upgrade_attackspeed_factor: float = 1
## reloadtime
static var melee_reloadtime_factor: float = 1
static var projectile_reloadtime_factor: float = 1
static var trap_reloadtime_factor: float = 1
static var creation_reloadtime_factor: float = 1
static var summon_reloadtime_factor: float = 1
static var spawn_reloadtime_factor: float = 1
static var weapon_reloadtime_factor: float = 1
static var ability_reloadtime_factor: float = 1
static var upgrade_reloadtime_factor: float = 1
## velocity
static var melee_velocity_factor: float = 1
static var projectile_velocity_factor: float = 1
static var trap_velocity_factor: float = 1
static var creation_velocity_factor: float = 1
static var summon_velocity_factor: float = 1
static var spawn_velocity_factor: float = 1
static var weapon_velocity_factor: float = 1
static var ability_velocity_factor: float = 1
static var upgrade_velocity_factor: float = 1
## ammo
static var melee_ammo_factor: float = 1
static var projectile_ammo_factor: float = 1
static var trap_ammo_factor: float = 1
static var creation_ammo_factor: float = 1
static var summon_ammo_factor: float = 1
static var spawn_ammo_factor: float = 1
static var weapon_ammo_factor: float = 1
static var ability_ammo_factor: float = 1
static var upgrade_ammo_factor: float = 1
## piercing
static var melee_piercing_factor: float = 1
static var projectile_piercing_factor: float = 1
static var trap_piercing_factor: float = 1
static var creation_piercing_factor: float = 1
static var summon_piercing_factor: float = 1
static var spawn_piercing_factor: float = 1
static var weapon_piercing_factor: float = 1
static var ability_piercing_factor: float = 1
static var upgrade_piercing_factor: float = 1
## critdamage
static var melee_critdamage_factor: float = 1
static var projectile_critdamage_factor: float = 1
static var trap_critdamage_factor: float = 1
static var creation_critdamage_factor: float = 1
static var summon_critdamage_factor: float = 1
static var spawn_critdamage_factor: float = 1
static var weapon_critdamage_factor: float = 1
static var ability_critdamage_factor: float = 1
static var upgrade_critdamage_factor: float = 1
## ghostly
static var melee_ghostly_factor: float = 1
static var projectile_ghostly_factor: float = 1
static var trap_ghostly_factor: float = 1
static var creation_ghostly_factor: float = 1
static var summon_ghostly_factor: float = 1
static var spawn_ghostly_factor: float = 1
static var weapon_ghostly_factor: float = 1
static var ability_ghostly_factor: float = 1
static var upgrade_ghostly_factor: float = 1
## regen
static var melee_regen_factor: float = 1
static var projectile_regen_factor: float = 1
static var trap_regen_factor: float = 1
static var creation_regen_factor: float = 1
static var summon_regen_factor: float = 1
static var spawn_regen_factor: float = 1
static var weapon_regen_factor: float = 1
static var ability_regen_factor: float = 1
static var upgrade_regen_factor: float = 1
## magnetize
static var melee_magnetize_factor: float = 1
static var projectile_magnetize_factor: float = 1
static var trap_magnetize_factor: float = 1
static var creation_magnetize_factor: float = 1
static var summon_magnetize_factor: float = 1
static var spawn_magnetize_factor: float = 1
static var weapon_magnetize_factor: float = 1
static var ability_magnetize_factor: float = 1
static var upgrade_magnetize_factor: float = 1
## lifesteal
static var melee_lifesteal_factor: float = 1
static var projectile_lifesteal_factor: float = 1
static var trap_lifesteal_factor: float = 1
static var creation_lifesteal_factor: float = 1
static var summon_lifesteal_factor: float = 1
static var spawn_lifesteal_factor: float = 1
static var weapon_lifesteal_factor: float = 1
static var ability_lifesteal_factor: float = 1
static var upgrade_lifesteal_factor: float = 1
## shield
static var melee_shield_factor: float = 1
static var projectile_shield_factor: float = 1
static var trap_shield_factor: float = 1
static var creation_shield_factor: float = 1
static var summon_shield_factor: float = 1
static var spawn_shield_factor: float = 1
static var weapon_shield_factor: float = 1
static var ability_shield_factor: float = 1
static var upgrade_shield_factor: float = 1
## difficulty
static var melee_difficulty_factor: float = 1
static var projectile_difficulty_factor: float = 1
static var trap_difficulty_factor: float = 1
static var creation_difficulty_factor: float = 1
static var summon_difficulty_factor: float = 1
static var spawn_difficulty_factor: float = 1
static var weapon_difficulty_factor: float = 1
static var ability_difficulty_factor: float = 1
static var upgrade_difficulty_factor: float = 1
## revies
static var melee_revies_factor: float = 1
static var projectile_revies_factor: float = 1
static var trap_revies_factor: float = 1
static var creation_revies_factor: float = 1
static var summon_revies_factor: float = 1
static var spawn_revies_factor: float = 1
static var weapon_revies_factor: float = 1
static var ability_revies_factor: float = 1
static var upgrade_revies_factor: float = 1
## thorns
static var melee_thorns_factor: float = 1
static var projectile_thorns_factor: float = 1
static var trap_thorns_factor: float = 1
static var creation_thorns_factor: float = 1
static var summon_thorns_factor: float = 1
static var spawn_thorns_factor: float = 1
static var weapon_thorns_factor: float = 1
static var ability_thorns_factor: float = 1
static var upgrade_thorns_factor: float = 1
## inaccuracy
static var melee_inaccuracy_factor: float = 1
static var projectile_inaccuracy_factor: float = 1
static var trap_inaccuracy_factor: float = 1
static var creation_inaccuracy_factor: float = 1
static var summon_inaccuracy_factor: float = 1
static var spawn_inaccuracy_factor: float = 1
static var weapon_inaccuracy_factor: float = 1
static var ability_inaccuracy_factor: float = 1
static var upgrade_inaccuracy_factor: float = 1
