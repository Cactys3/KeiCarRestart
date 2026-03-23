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
var damage: float # Damage of attack
var position: Vector2 # Position of Attack
var buildup: float # Multiply to Status Buildups
## armor shred?
## Attacker Given Data
var attacking_status: StatusEffects # Attacker's Offensive Status Effects
var attacker: Node2D # Reference to attacker

## IDK if used Data, This can be hidden stats because attacks should slow or stun enemies to feel 'weighty'
## but these aren't the stuns or slows that the status effects make happen
## Currently:
	## Enemy send values based on enemy type to Player 
	## Projectiles send only 'knockback' values to Enemy, calculated based on stats
var stun: float
var slow: float
var knockback: float

func _init(type: AttackTypes, dmg: float, pos: Vector2, buildupStat: float, attacker_status: StatusEffects, attackerNode: Node2D, stunValue: float, slowValue: float, knockbackValue: float):
	attack_type = type
	damage = dmg
	position = pos
	buildup = buildupStat
	attacking_status = attacker_status
	attacker = attackerNode
	stun = stunValue
	slow = slowValue
	knockback = knockbackValue
