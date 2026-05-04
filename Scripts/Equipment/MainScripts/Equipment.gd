extends StatsObject
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
@export var connect_boss_killed: bool = false
@export var connect_reload: bool = false
@export var connect_bleed_proc: bool = false
@export var connect_frost_proc: bool = false
@export var connect_dodge: bool = false
@export var connect_player_damaged: bool = false
@export var connect_enemy_trapped: bool = false
@export var connect_creation_died: bool = false
@export var connect_projectile_spawned: bool = false
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
	if connect_creation_died:
		game_man.CreationDied.connect(creation_died)
	if connect_projectile_spawned:
		game_man.ProjectileSpawned.connect(projectile_spawned)
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
	return !node.is_in_group("player") && "can_be_damaged" in node && node.get("can_be_damaged") && node.has_method("damage")
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
## On player dodges damage
func dodge(character: Character, attack: Attack):
	pass
func player_damaged(character: Character, attack: Attack):
	pass
func enemy_trapped(enemy: Enemy, trap: Trap):
	pass
func creation_died(creation: Creation, attack: Attack):
	pass
func projectile_spawned(projectile: Projectile):
	pass
## Calculate and return an attack with damage multiplier
func make_attack(attack_damage_multiplier: float) -> Attack:
	## Make Two Stats Lists
	var base: GlobalStats.StatsList = GlobalStats.get_statslist_base()
	var factor: GlobalStats.StatsList = GlobalStats.get_statslist_factor()
	## Add Self's Base Stats to Base StatList
	base = add_to_stats_list(base)
	factor.add_to_stat(GlobalStats.DAMAGE, attack_damage_multiplier - 1) # -1 to make it a multiplier
	## Make Attack Values
	var attack_type: Attack.AttackTypes
	if item_type == item_types.upgrade:
		attack_type = Attack.AttackTypes.upgrade_melee
	elif item_type == item_types.weapon:
		attack_type = Attack.AttackTypes.player_weapon_melee 
	## Make attack and Pass attack through each active upgrade
	var attack: Attack = Attack.new(attack_type, self, player.global_position, status, base, factor)
	game_man.handle_attack(attack)
	return attack
func get_attack_type() -> Attack.AttackTypes:
	if item_type == item_types.upgrade:
		return Attack.AttackTypes.upgrade_melee
	else:# item_type == item_types.weapon:
		return Attack.AttackTypes.player_weapon_melee 
func get_attack_position() -> Vector2:
	return global_position
