extends StatsObject
class_name Equipment
## Does this Equipment require its own input?
@export var has_custom_input: bool = false
@export_group("Information")
@export_placeholder("Name Go Here") var item_name: String = "unset"
@export_multiline var item_description: String = "default description"
@export var item_type: item_types
@export var item_color: Color = Color.TRANSPARENT
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D = preload("uid://d0wip1h85ishb")
@export_group("Signal Connections")
@export var connect_enemy_killed: bool = false
@export var connect_boss_killed: bool = false
@export var connect_reload: bool = false
@export var connect_bleed_proc: bool = false
@export var connect_frost_proc: bool = false
@export var connect_shock_proc: bool = false
@export var connect_wet_proc: bool = false
@export var connect_burn_proc: bool = false
@export var connect_poison_proc: bool = false
@export var connect_dodge: bool = false
@export var connect_player_damaged: bool = false
@export var connect_player_shield_damaged: bool = false
@export var connect_player_heal: bool = false
@export var connect_player_maxhp_changed: bool = false
@export var connect_enemy_trapped: bool = false
@export var connect_creation_killed: bool = false
@export var connect_creation_damaged: bool = false
@export var connect_projectile_spawned: bool = false
@export var connect_upgrade_cooldown_finished: bool = false
@export var connect_: bool = false
## Data Fields
var player: Character
var assigned_input: String = ""
## Generic Fields (always active)
## is this weapon or upgrade equipped
var active: bool = false
var total_damage: float = 0
var units_killed: int = 0
## unset, upgrade, projectile, weapon
enum item_types{unset, upgrade, projectile, weapon}
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
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
	if has_custom_input:
		InputManager.assign_input(self)
	if connect_enemy_killed:
		game_man.EnemyKilled.connect(enemy_killed)
	if connect_boss_killed:
		game_man.BossKilled.connect(boss_killed)
	if connect_reload:
		game_man.WeaponReloaded.connect(reload)
	if connect_bleed_proc:
		game_man.BleedDamage.connect(bleed_proc)
	if connect_frost_proc:
		game_man.FrostDamage.connect(frost_proc)
	if connect_dodge:
		game_man.PlayerDodged.connect(dodge)
	if connect_player_damaged:
		game_man.PlayerDamaged.connect(player_damaged)
	if connect_enemy_trapped:
		game_man.EnemyTrapped.connect(enemy_trapped)
	if connect_creation_killed:
		game_man.CreationKilled.connect(creation_killed)
	if connect_projectile_spawned:
		game_man.ProjectileSpawned.connect(projectile_spawned)
	if connect_upgrade_cooldown_finished:
		game_man.UpgradeCooldownFinished.connect(upgrade_cooldown_finished)
	if connect_player_maxhp_changed:
		game_man.PlayerMaxHealthChange.connect(player_maxhp_changed)
	if connect_player_shield_damaged:
		game_man.PlayerShieldDamaged.connect(player_shield_damaged)
	if connect_player_heal:
		game_man.PlayerHeal.connect(player_heal)
	if connect_creation_damaged:
		game_man.CreationDamaged.connect(creation_damaged)
	if connect_shock_proc:
		game_man.ShockDamage.connect(shock_proc)
	player = new_player
	active = true
## disable and halt the functionality of this Equipment
func deactivate():
	if has_custom_input:
		InputManager.free_input(assigned_input)
	if connect_enemy_killed && game_man.EnemyKilled.is_connected(enemy_killed):
		game_man.EnemyKilled.disconnect(enemy_killed)
	if connect_boss_killed && game_man.BossKilled.is_connected(boss_killed):
		game_man.BossKilled.disconnect(boss_killed)
	if connect_reload && game_man.WeaponReloaded.is_connected(reload):
		game_man.WeaponReloaded.disconnect(reload)
	if connect_bleed_proc && game_man.BleedDamage.is_connected(bleed_proc):
		game_man.BleedDamage.disconnect(bleed_proc)
	if connect_frost_proc && game_man.FrostDamage.is_connected(frost_proc):
		game_man.FrostDamage.disconnect(frost_proc)
	if connect_dodge && game_man.PlayerDodged.is_connected(dodge):
		game_man.PlayerDodged.disconnect(dodge)
	if connect_player_damaged && game_man.PlayerDamaged.is_connected(player_damaged):
		game_man.PlayerDamaged.disconnect(player_damaged)
	if connect_enemy_trapped && game_man.EnemyTrapped.is_connected(enemy_trapped):
		game_man.EnemyTrapped.disconnect(enemy_trapped)
	if connect_creation_killed && game_man.CreationKilled.is_connected(creation_killed):
		game_man.CreationKilled.disconnect(creation_killed)
	if connect_projectile_spawned && game_man.ProjectileSpawned.is_connected(projectile_spawned):
		game_man.ProjectileSpawned.disconnect(projectile_spawned)
	if connect_upgrade_cooldown_finished && game_man.UpgradeCooldownFinished.is_connected(upgrade_cooldown_finished):
		game_man.UpgradeCooldownFinished.disconnect(upgrade_cooldown_finished)
	active = false
## Returns if this Equipment can attack the given node (not the player, has damage() func, can_be_damaged)
func get_can_attack_callable() -> Callable:
	return func(body: Node2D) -> bool:
		return !body.is_in_group("player") && body.has_method("damage") && "can_be_damaged" in body && body.get("can_be_damaged")
## FIND ENEMIES
## Returns nearest enemy or null
func get_nearest_enemy() -> Variant:
	if get_tree() == null:
		return null
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

## Input
## Attempt to assign input to this Equipment
func assign_input(input: String) -> void:
	assigned_input = input
## Remove input, override if there are conditions where you don't want to allow remove input
func remove_input() -> bool:
	assigned_input = ""
	return true

## SIGNALS
## On Enemy Killed Signal
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	pass
## On Boss Killed Signal
func boss_killed(boss: Boss, attack: Attack) -> void:
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
## On (enemy) Poison Proc Signal 
func poison_proc(poison_damage: float, enemy: Enemy):
	pass
## On (enemy) Wet Proc Signal 
func wet_proc(wet_damage: float, enemy: Enemy):
	pass
## On (enemy) Shock Proc Signal 
func shock_proc(shock_damage: float, enemy: Enemy):
	pass
## On (enemy) Burn Proc Signal 
func burn_proc(burn_damage: float, enemy: Enemy):
	pass
## On player dodges damage
func dodge(character: Character, attack: Attack):
	pass
func player_damaged(character: Character, attack: Attack):
	pass
func player_shield_damaged(character: Character, attack: Attack, shield_damage_amount: float):
	pass
func player_maxhp_changed(new_maxhp: float, old_maxhp: float):
	pass
func player_heal(heal_amount: float, heal_type: GameManager.HealTypes):
	pass
func enemy_trapped(enemy: Enemy, trap: Trap):
	pass
func creation_killed(creation: Creation, attack: Attack):
	pass
func creation_damaged(creation: Creation, attack: Attack):
	pass

func projectile_spawned(projectile: Projectile):
	pass
func upgrade_cooldown_finished(upgrade: Upgrade):
	pass
## Calculate and return an attack with damage multiplier
func make_attack(attack_damage_multiplier: float) -> Attack:
	## Get attack
	var attack: Attack = super(attack_damage_multiplier)
	## Set Color
	attack.set_attack_color(item_color)
	return attack
func get_attack_position() -> Vector2:
	return global_position

func post_damage_return(damage_return: Enemy.DamageReturn):
	if lifesteal_stat > 0:
		game_man.heal_player((lifesteal_stat / 100) * damage_return.attack_damage_dealt, GameManager.HealTypes.lifesteal)
		
## Creations send back their damage returns
func creation_damage_return(damage_return: Enemy.DamageReturn):
	total_damage += damage_return.total_damage_dealt
	if damage_return.killed:
		units_killed += 1
	print("Damage: ", total_damage)
