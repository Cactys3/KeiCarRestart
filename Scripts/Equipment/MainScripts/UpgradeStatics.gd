extends Resource
class_name Statics

## Tracking Variables

## Number of currently active spawns
static var active_summons: int = 0
static var active_traps: int = 0
static var active_creations: int = 0
static var active_projectiles: int = 0

## Buff Variables

## Global Buffs
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


## Trigger based buffs (applied in places where things are spawned via specific triggers)
static var reload_spawns_count_buff: int = 0

## Number of additional spawns per spawn (I think this is probably flat, so 1 = 1)
static var summon_count_buff: int = 0
static var trap_count_buff: int = 0
static var creation_count_buff: int = 0
static var projectile_count_buff: int = 0
static var spawn_count_buff: float = 0 ## For every spawn type
## Duration Increases for each spawn (I think this is probably percent)
static var summon_duration_buff: float = 0
static var trap_duration_buff: float = 0
static var creation_duration_buff: float = 0
static var projectile_duration_buff: float = 0
static var spawn_duration_buff: float = 0 ## For every spawn type
## Damage Increases for each spawn (I think this is probably percent too)
static var summon_damage_buff: float = 0
static var trap_damage_buff: float = 0
static var creation_damage_buff: float = 0
static var projectile_damage_buff: float = 0
static var spawn_damage_buff: float = 0 ## For every spawn type
## Size Increases for each spawn (I think this is probably percent (but out of 100))
static var summon_size_buff: float = 0
static var trap_size_buff: float = 0
static var creation_size_buff: float = 0
static var projectile_size_buff: float = 0
static var spawn_size_buff: float = 0 ## For every spawn type
## 
static var summon_attackspeed_buff: float = 0
static var trap_attackspeed_buff: float = 0
static var creation_attackspeed_buff: float = 0
static var projectile_attackspeed_buff: float = 0
static var spawn_attackspeed_buff: float = 0 ## For every spawn type
## 
static var summon_hp_buff: float = 0
static var trap_hp_buff: float = 0
static var creation_hp_buff: float = 0
static var spawn_hp_buff: float = 0 ## For every spawn type
## Projectile Only Buff
static var projectile_piercing_buff: float = 0
## Summon Only Buffs
static var creation_dodge_buff: float = 0
static var creation_dodges_count_for_player: float = 0 # value > 0 means true
