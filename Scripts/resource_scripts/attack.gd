extends Resource
class_name Attack
## General Data
var attack_type: AttackTypes = AttackTypes.unset
enum AttackTypes{
	unset, 
	player_weapon_projectile, 
	player_weapon_melee,
	player_status,
	## Thorns, etc
	player_misc,
	upgrade_projectile,
	upgrade_turret,
	upgrade_spawn,
	upgrade_melee,
	upgrade_status,
	enemy_projectile,
	enemy_melee,
	enemy_status,
	map_hazard}
var position: Vector2 # Position of Attack
## Attacker Given Data
var status: StatusEffects # Attacker's Offensive Status Effects
var attacker: Node2D # Reference to attacker
var temporary_base_stats: GlobalStats.StatsList 
var temporary_factor_stats: GlobalStats.StatsList 
## Values
var stun: float = 0
## Simple Values
var simple: bool = false
var simple_damage: float
var simple_knockback: float


func _init(type: AttackTypes, attackerNode: Node2D, pos: Vector2, attacker_status: StatusEffects, basestats: GlobalStats.StatsList, factorstats: GlobalStats.StatsList):
	attack_type = type
	attacker = attackerNode
	position = pos
	status = attacker_status
	temporary_base_stats = basestats
	temporary_factor_stats = factorstats
## Sets this Attack up as simple
func simple_setup(damage: float, knockback: float):
	simple = true
	simple_damage = damage
	simple_knockback = knockback
func get_damage() -> float:
	if simple:
		return simple_damage
	return GlobalStats.calculate_damage(get_stat(GlobalStats.DAMAGE), get_stat(GlobalStats.LUCK), get_stat(GlobalStats.CRITDAMAGE))
func get_knockback() -> float:
	if simple:
		return simple_knockback
	return GlobalStats.calculate_knockback(get_stat(GlobalStats.DAMAGE), get_stat(GlobalStats.WEIGHT))
func get_stun() -> float:
	return stun
func get_burn() -> float:
	if status.applies_burn:
		return get_stat(GlobalStats.BURN_APPLY)
	return 0
func get_frost() -> float:
	if status.applies_frost:
		return get_stat(GlobalStats.FROST_APPLY)
	return 0
func get_poison() -> float:
	if status.applies_poison:
		return get_stat(GlobalStats.POISON_APPLY)
	return 0
func get_bleed() -> float:
	if status.applies_bleed:
		return get_stat(GlobalStats.BLEED_APPLY)
	return 0
func get_shock() -> float:
	if status.applies_shock:
		return get_stat(GlobalStats.SHOCK_APPLY)
	return 0
func get_wet() -> float:
	if status.applies_wet:
		return get_stat(GlobalStats.WET_APPLY)
	return 0

func get_stat(key: String) -> float:
	if simple:
		printerr("Trying to call 'get_stat' on Attack but Attack is setup as simple: ", key)
		return 0
	if temporary_base_stats.has(key) && temporary_factor_stats.has(key):
		#print("Attack getting stat: ", key, " value: ", temporary_base_stats.get_stat(key) * temporary_factor_stats.get_stat(key))
		return temporary_base_stats.get_stat(key) * temporary_factor_stats.get_stat(key)
	else:
		printerr("Trying to get stat that doesn't exist in StatsList: ", key)
		return 0
## Returns if this attack is from the player's weapon
func is_from_weapon() -> bool:
	return (attack_type == AttackTypes.player_weapon_projectile 
		|| attack_type == AttackTypes.player_weapon_melee)
## Returns if this attack is from anything from player
func is_from_player() -> bool:
	return (attack_type == AttackTypes.player_weapon_projectile 
		|| attack_type == AttackTypes.player_weapon_melee
		|| attack_type == AttackTypes.player_status
		|| attack_type == AttackTypes.player_misc
		|| attack_type == AttackTypes.upgrade_projectile
		|| attack_type == AttackTypes.upgrade_turret
		|| attack_type == AttackTypes.upgrade_spawn
		|| attack_type == AttackTypes.upgrade_melee
		|| attack_type == AttackTypes.upgrade_status
		)
## Returns if this attack is from anything from an Upgrade
func is_from_upgrade() -> bool:
	return (attack_type == AttackTypes.upgrade_projectile
		|| attack_type == AttackTypes.upgrade_turret
		|| attack_type == AttackTypes.upgrade_spawn
		|| attack_type == AttackTypes.upgrade_melee
		|| attack_type == AttackTypes.upgrade_status
		)
