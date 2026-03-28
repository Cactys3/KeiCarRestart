extends Node2D
class_name Equipment

@export_group("Information")
@export_placeholder("Name Go Here") var item_name: String = "unset"
@export_multiline var item_description: String = "default description"
@export var item_type: item_types
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D 
@export_group("Signal Connections")
@export var connect_enemy_killed: bool = false
@export var connect_reload: bool = false
@export var connect_bleed_proc: bool = false
@export var connect_frost_proc: bool = false
@export var connect_: bool = false
var game_man: GameManager:
	get():
		return GameManager.instance
## Data Fields
var player: Character
## Generic Fields (always active)
## is this weapon or upgrade equipped
var active: bool = false
## unset, upgrade, projectile, weapon
enum item_types{unset, upgrade, projectile, weapon}
func _ready() -> void:
	flash()
func _process(delta: float) -> void:
	pass
## Flashing stuff
func flash():
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
## Returns type for the given item_types index
static func get_type(i: int) -> String:
	match(i):
		item_types.unset:
			return "unset"
		item_types.projectile:
			return "projectile"
		item_types.weapon:
			return "weapon"
		item_types.upgrade:
			return "upgrade"
	return "Type: " + str(i)
## enable and apply the functionality of this Equipment
func activate(new_player: Character):
	if connect_enemy_killed:
		game_man.EnemyKilled.connect(enemy_killed)
	if connect_reload:
		game_man.WeaponReloaded.connect(reload)
	if connect_bleed_proc:
		game_man.BleedDamage.connect(bleed_proc)
	if connect_frost_proc:
		game_man.FrostDamage.connect((frost_proc))
	player = new_player
	active = true
## disable and halt the functionality of this Equipment
func deactivate():
	if connect_enemy_killed && game_man.EnemyKilled.is_connected(enemy_killed):
		game_man.EnemyKilled.disconnect(enemy_killed)
	if connect_reload && game_man.WeaponReloaded.is_connected(reload):
		game_man.WeaponReloaded.disconnect(reload)
	if connect_bleed_proc && game_man.BleedDamage.is_connected(bleed_proc):
		game_man.BleedDamage.disconnect(bleed_proc)
	if connect_frost_proc && game_man.FrostDamage.is_connected((frost_proc)):
		game_man.FrostDamage.disconnect((frost_proc))
	active = false
## Returns if this Equipment can attack the given node (not the player, has damage() func, can_be_damaged)
func can_attack(node: Node2D) -> bool:
	print('can we attack ', node.name, "?")
	print(!node.is_in_group("player"), "can_be_damaged" in node,  node.get("can_be_damaged"),  node.has_method("damage"))
	return !node.is_in_group("player") && "can_be_damaged" in node && node.get("can_be_damaged") && node.has_method("damage")
## FIND ENEMIES
## Returns nearest enemy or null
func get_nearest_enemy() -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if nearest_enemy == null:
			nearest_enemy = enemy
		elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = enemy
	return nearest_enemy
func get_enemy_nearby(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
	return nearest_enemy
## Returns all enemies within distance
func get_enemies_nearby(distance: float) -> Array[Enemy]:
	var enemies = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			enemies.append(enemy)
	return enemies
## Returns if weapon is pointing towards the given enemy
func IsAimingAtEnemy(enemy: Node2D) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= 5
	return false
## Returns if weapon is pointing towards the given enemy, within degree of leniency
func IsAimingAtEnemyWithinDegree(enemy: Node2D, degree: float) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= degree
	return false
## Returns if weapon is pointing towards any enemy TODO: not setup
func IsAimingAtAnyEnemy() -> bool:
	if false: #TODO: setup with raycasts
		return true
	return false
## SIGNALS
## On Enemy Killed Signal
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	pass
## On Reload Signal
func reload(weapon: Weapon) -> void:
	pass
## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	pass
## On (enemy) Frost Proc Signal 
func frost_proc(frost_damage: float, enemy: Enemy):
	pass
## Stats Equipment
## Stats
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
@export_subgroup("Non-Weapon Stats")
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
