extends Resource
class_name Attack
## General Data
#var attack_type: AttackTypes = AttackTypes.unset
#enum AttackTypes{
	#unset, 
	#player_weapon_projectile, 
	#player_weapon_melee,
	#player_status,
	### Thorns, etc
	#player_misc,
	#upgrade_projectile,
	#upgrade_creation,
	#upgrade_trap,
	#upgrade_summon,
	#upgrade_melee,
	#upgrade_status,
	#enemy_projectile,
	#enemy_melee,
	#enemy_status,
	#map_hazard,
	#player_ability}
var attack_type: AttackTypes = AttackTypes.unset
enum AttackTypes{
	unset, 
	projectile,
	melee,
	trap,
	creation,
	summon,
	status,
	hazard,
	thorns,
	misc}
## TODO: have attack_source that tells all about 'who' is doing the damaging, and then 'attack_type' that tells what type (projectile, creation, melee, etc)
var attack_source: AttackSources = AttackSources.unset
enum AttackSources{
	unset,
	player,
	weapon,
	ability,
	enemy,
	upgrade,
	status,
	hazard}
## Is this attack from something friendly to the player
var position: Vector2 # Position of Attack
var impact_location: Vector2
## Attacker Given Data
var status: StatusEffects # Attacker's Offensive Status Effects
var attacker: Node2D # Reference to attacker
var temporary_base_stats: GlobalStats.StatsList 
var temporary_factor_stats: GlobalStats.StatsList 
var attack_color: Color = Color.TRANSPARENT
## Values
var calculated_crit: bool = false
var is_crit: bool = false
var stun_duration: float = 0
var slow_duration: float = 0
## Enemy Default Movespeed = 20
var slow_strength: float = 0
var can_knockback: bool = true
## Simple Values
var simple: bool = false
var simple_damage: float
var simple_knockback: float

func _init(source_of_attack: AttackSources, type_of_attack: AttackTypes, attacker_node: Node2D, attack_position: Vector2, attacker_status: StatusEffects, basestats: GlobalStats.StatsList, factorstats: GlobalStats.StatsList):
	attack_source = source_of_attack
	attack_type = type_of_attack
	attacker = attacker_node
	position = attack_position
	status = attacker_status
	temporary_base_stats = basestats
	temporary_factor_stats = factorstats
func set_attack_color(color: Color):
	attack_color = color
## Sets this Attack up as simple
func simple_setup(damage: float, knockback: float):
	## TODO: replace simple setup with just giving the key stats and then creating two stat lists for them and working normally from there
	
	## TODO: Remove simple setup and just allow variables to be null/check for nulls (everything will setup a base/factor stats when attacking)
	simple = true
	simple_damage = damage
	simple_knockback = knockback
	temporary_base_stats = GlobalStats.StatsList.new(0)
	temporary_factor_stats = GlobalStats.StatsList.new(1)
func get_damage() -> float:
	if simple:
		return simple_damage
	calculate_crit()
	return GlobalStats.calculate_damage(get_stat(GlobalStats.DAMAGE), is_crit, get_stat(GlobalStats.CRITDAMAGE))
func get_knockback() -> float:
	if can_knockback:
		if simple:
			return simple_knockback
		return GlobalStats.calculate_knockback(get_stat(GlobalStats.DAMAGE), get_stat(GlobalStats.WEIGHT))
	else:
		return 0
func get_stun_duration() -> float:
	return stun_duration
func get_slow_duration() -> float:
	return slow_duration
func get_slow_strength() -> float:
	return slow_strength
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
func has_color() -> bool:
	return attack_color != Color.TRANSPARENT
## Returns if this attack is a critical strike
func get_crit() -> bool:
	if !calculated_crit:
		calculate_crit()
	return is_crit
## Decides the value for crit
func calculate_crit() -> void:
	if temporary_base_stats && temporary_factor_stats:
		calculated_crit = true
		is_crit = GlobalStats.calculate_crit(get_stat(GlobalStats.LUCK))
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
func is_from_weapon() -> bool:
	return attack_source == AttackSources.weapon
func is_from_player() -> bool:
	return attack_source == AttackSources.player
func is_from_enemy() -> bool:
	return attack_source == AttackSources.enemy
func is_from_upgrade() -> bool:
	return attack_source == AttackSources.upgrade
## Returns if this attack is from a player projectile (does not care about enemy projectiles)
func is_projectile() -> bool:
	return attack_type == AttackTypes.projectile && is_friendly_to_player()
func is_melee() -> bool:
	return attack_type == AttackTypes.melee
func is_trap() -> bool:
	return attack_type == AttackTypes.trap
func is_summon() -> bool:
	return attack_type == AttackTypes.summon
func is_creation() -> bool:
	return attack_type == AttackTypes.creation
func is_status() -> bool:
	return attack_type == AttackTypes.status || attack_source == AttackSources.status

func is_friendly_to_player() -> bool:
	return (attack_source == AttackSources.player
		|| attack_source == AttackSources.weapon
		|| attack_source == AttackSources.ability
		|| attack_source == AttackSources.upgrade
		|| attack_source == AttackSources.status)
