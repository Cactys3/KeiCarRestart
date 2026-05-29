extends Resource
class_name Statics

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

## Status Buffs
## Increase debuff by x each proc
static var enemy_frost_frozen_duration: float = 2
static var enemy_frost_movespeed_reduction: float = 5
static var enemy_shock_defense_reduction: float = 5
## Multiplier increase of enemy status threshold after each proc
static var enemy_bleed_threshold_multiplier: float = 1.7
static var enemy_frost_threshold_multiplier: float = 2
## Crits
static var bleeds_crit_on_enemy: bool = false

## Trigger based buffs (applied in places where things are spawned via specific triggers)
static var reload_spawns_count_buff: int = 0

## Summon Only Buffs
static var creation_dodge_buff: float = 0
static var creation_dodges_count_for_player: float = 0 # value > 0 means true

## Stat Buffs (some may be unused):

## Number of additional spawns per spawn (I think this is probably flat, so 1 = 1)
static var summon_count_buff: int = 0
static var trap_count_buff: int = 0
static var creation_count_buff: int = 0
static var projectile_count_buff: int = 0
static var spawn_count_buff: float = 0 
## Duration Increases for each spawn (I think this is probably percent)
static var summon_duration_buff: float = 0
static var trap_duration_buff: float = 0
static var creation_duration_buff: float = 0
static var projectile_duration_buff: float = 0
static var spawn_duration_buff: float = 0 
## Damage Increases for each spawn (I think this is probably percent too)
static var summon_damage_buff: float = 0
static var trap_damage_buff: float = 0
static var creation_damage_buff: float = 0
static var projectile_damage_buff: float = 0
static var spawn_damage_buff: float = 0 
## Size Increases for each spawn (I think this is probably percent (but out of 100))
static var summon_size_buff: float = 0
static var trap_size_buff: float = 0
static var creation_size_buff: float = 0
static var projectile_size_buff: float = 0
static var spawn_size_buff: float = 0 
## HP
static var summon_hp_buff: float = 0
static var trap_hp_buff: float = 0
static var creation_hp_buff: float = 0
static var projectile_hp_buff: float = 0
static var spawn_hp_buff: float = 0 
## Stance
static var summon_stance_buff: float = 0
static var trap_stance_buff: float = 0
static var creation_stance_buff: float = 0
static var projectile_stance_buff: float = 0
static var spawn_stance_buff: float = 0 
## Movespeed
static var summon_movespeed_buff: float = 0
static var trap_movespeed_buff: float = 0
static var creation_movespeed_buff: float = 0
static var projectile_movespeed_buff: float = 0
static var spawn_movespeed_buff: float = 0 
## XP
static var summon_xp_buff: float = 0
static var trap_xp_buff: float = 0
static var creation_xp_buff: float = 0
static var projectile_xp_buff: float = 0
static var spawn_xp_buff: float = 0 
## Mogul
static var summon_mogul_buff: float = 0
static var trap_mogul_buff: float = 0
static var creation_mogul_buff: float = 0
static var projectile_mogul_buff: float = 0
static var spawn_mogul_buff: float = 0 
## Luck
static var summon_luck_buff: float = 0
static var trap_luck_buff: float = 0
static var creation_luck_buff: float = 0
static var projectile_luck_buff: float = 0
static var spawn_luck_buff: float = 0 
## Range
static var summon_range_buff: float = 0
static var trap_range_buff: float = 0
static var creation_range_buff: float = 0
static var projectile_range_buff: float = 0
static var spawn_range_buff: float = 0 
## Weight
static var summon_weight_buff: float = 0
static var trap_weight_buff: float = 0
static var creation_weight_buff: float = 0
static var projectile_weight_buff: float = 0
static var spawn_weight_buff: float = 0 
## Attackcooldown
static var summon_attackcooldown_buff: float = 0
static var trap_attackcooldown_buff: float = 0
static var creation_attackcooldown_buff: float = 0
static var projectile_attackcooldown_buff: float = 0
static var spawn_attackcooldown_buff: float = 0 
## Attackspeed
static var summon_attackspeed_buff: float = 0
static var trap_attackspeed_buff: float = 0
static var creation_attackspeed_buff: float = 0
static var projectile_attackspeed_buff: float = 0
static var spawn_attackspeed_buff: float = 0 
## Reloadtime
static var summon_reloadtime_buff: float = 0
static var trap_reloadtime_buff: float = 0
static var creation_reloadtime_buff: float = 0
static var projectile_reloadtime_buff: float = 0
static var spawn_reloadtime_buff: float = 0 
## Velocity
static var summon_velocity_buff: float = 0
static var trap_velocity_buff: float = 0
static var creation_velocity_buff: float = 0
static var projectile_velocity_buff: float = 0
static var spawn_velocity_buff: float = 0 
## Ammo
static var summon_ammo_buff: float = 0
static var trap_ammo_buff: float = 0
static var creation_ammo_buff: float = 0
static var projectile_ammo_buff: float = 0
static var spawn_ammo_buff: float = 0 
## Piercing
static var summon_piercing_buff: float = 0
static var trap_piercing_buff: float = 0
static var creation_piercing_buff: float = 0
static var projectile_piercing_buff: float = 0
static var spawn_piercing_buff: float = 0 
## Critdamage
static var summon_critdamage_buff: float = 0
static var trap_critdamage_buff: float = 0
static var creation_critdamage_buff: float = 0
static var projectile_critdamage_buff: float = 0
static var spawn_critdamage_buff: float = 0 
## Ghostly
static var summon_ghostly_buff: float = 0
static var trap_ghostly_buff: float = 0
static var creation_ghostly_buff: float = 0
static var projectile_ghostly_buff: float = 0
static var spawn_ghostly_buff: float = 0 
## Regen
static var summon_regen_buff: float = 0
static var trap_regen_buff: float = 0
static var creation_regen_buff: float = 0
static var projectile_regen_buff: float = 0
static var spawn_regen_buff: float = 0 
## Magnetize
static var summon_magnetize_buff: float = 0
static var trap_magnetize_buff: float = 0
static var creation_magnetize_buff: float = 0
static var projectile_magnetize_buff: float = 0
static var spawn_magnetize_buff: float = 0 
## Lifesteal
static var summon_lifesteal_buff: float = 0
static var trap_lifesteal_buff: float = 0
static var creation_lifesteal_buff: float = 0
static var projectile_lifesteal_buff: float = 0
static var spawn_lifesteal_buff: float = 0 
## Shield
static var summon_shield_buff: float = 0
static var trap_shield_buff: float = 0
static var creation_shield_buff: float = 0
static var projectile_shield_buff: float = 0
static var spawn_shield_buff: float = 0 
## Difficulty
static var summon_difficulty_buff: float = 0
static var trap_difficulty_buff: float = 0
static var creation_difficulty_buff: float = 0
static var projectile_difficulty_buff: float = 0
static var spawn_difficulty_buff: float = 0 
## Revies
static var summon_revies_buff: float = 0
static var trap_revies_buff: float = 0
static var creation_revies_buff: float = 0
static var projectile_revies_buff: float = 0
static var spawn_revies_buff: float = 0 
## Thorns
static var summon_thorns_buff: float = 0
static var trap_thorns_buff: float = 0
static var creation_thorns_buff: float = 0
static var projectile_thorns_buff: float = 0
static var spawn_thorns_buff: float = 0 
## Inaccuracy
static var summon_inaccuracy_buff: float = 0
static var trap_inaccuracy_buff: float = 0
static var creation_inaccuracy_buff: float = 0
static var projectile_inaccuracy_buff: float = 0
static var spawn_inaccuracy_buff: float = 0
