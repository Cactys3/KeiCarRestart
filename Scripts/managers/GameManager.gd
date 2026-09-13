extends Node
class_name GameManager

const LEVEL_UP_UI = preload("uid://cykl0goweao0i")
## Heal Types
enum HealTypes {regen, heal, lifesteal}

## Single Instance Object
static var instance: GameManager
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var player: Character
@export var camera: Camera2D
## Parents
@export var xp_parent: Node2D
@export var enemy_parent: Node2D
@export var weapon_parent: Node2D
@export var projectile_parent: Node2D
@export var trap_parent: Node2D
@export var audio_parent: Node2D
# Weapons
var weapon_list: Array[Weapon]
var weapon_count: int = 0
var static_slot_count: int = 0
var dynamic_at_mouse_count: int = 0
var always_at_mouse_count: int = 0
var spin_aim_count: int = 0

var weapon_limit: int = 10
var upgrade_count: int:
	get():
		return active_upgrades.size()
var upgrade_limit: int = 10
var weapon_limit_reached: bool:
	get():
		return has_weapon_room()
var upgrade_limit_reached: bool:
	get():
		return has_upgrade_room()
var active_upgrades: Array[Upgrade]
var upgrades_affecting_stats: Array[Upgrade]

var xp_to_next_level: float = 100
var xp_gained_since_last_level: float = 0
var xp_modifier_per_level: float = 1.1
var xp_from_past_levels: float = 0
var starting_money: float = 15
var xp_gain_modifier: float:
	get():
		print(max(0.1, 1 + (player.xp_gain - 1) / 100))
		return max(0.1, 1 + (player.xp_gain - 1) / 100)
var money_gain_modifier: float:
	get():
		return max(0.1, 1 + (player.mogul - 1) / 100)

var revives_used: int = 0
var curr_shield: float = 0:
	set(value):
		curr_shield = value
		ui_man.set_shield(value)
var max_hp: float = 100:
	set(value):
		max_hp = value
		ui_man.set_max_hp(value)
var curr_hp: float = 0:
	set(value):
		if value > max_hp:
			max_hp = value
		curr_hp = value
		ui_man.set_hp(value)
var level: float = 1: ## level
	set(value): #TODO: maybe send to instancemanager and make game harder by level
		level = value
		ui_man.set_level(str(int(value)))
var xp: float = 0: ## Current (total?) XP Gained
	set(value):
		var xp_just_added: float = 0
		if (value > xp): ## Factor in xp_gain only when adding xp, not subtracting xp
			xp_just_added = (value - xp) * xp_gain_modifier
		else:
			xp_just_added = (value - xp) 
		xp_gained_since_last_level += (xp_just_added)
		xp = xp + xp_just_added
		ui_man.set_xp(str(int(xp)), xp_gained_since_last_level / xp_to_next_level)
		while xp_gained_since_last_level > xp_to_next_level:
			xp_from_past_levels += xp_to_next_level
			xp_gained_since_last_level -= xp_to_next_level
			xp_to_next_level *= xp_modifier_per_level
			level += 1
			emit_signal("level_up")
			#print("Gained Level Costing: " + str(int(xp_to_next_level)) + " XP Leftover: " + str(int(xp_gained_since_last_level) - int(xp_to_next_level)))
var money: float = 0: ## Current Money Held
	set(value):
		if value > money: ## Factor in money_gain when adding money
			money = money + (value - money) * money_gain_modifier
		else:
			money = value
		ui_man.set_money(money)
var difficulty: float:
	get():
		return GlobalStats.get_stat(GlobalStats.DIFFICULTY)
var luck: float:
	get():
		return GlobalStats.get_stat(GlobalStats.LUCK)
## Enabled when typing so keybinds should be disabled
var typing_disable_keybinds: bool = false
var paused: bool = false ## Is Game Instance Paused or Not
var level_up_queue: int = 0
var leveling_up: bool = false
## Signals
## For GameManager Systems
signal pause_game(value: bool)
signal level_up()
signal RoundEnded(round_number: int)
## UI Methods
signal toggle_inventory() #TODO: add bool value to keep track of toggle state?
signal toggle_esc()
signal set_xp(value: float)
signal set_money(value: float)
signal set_level(value: float)
signal set_hp(value: float)
## Enemies
signal EnemyDamaged(enemy: Enemy, attack: Attack)
signal EnemyKilled(enemy: Enemy, attack: Attack)
signal EnemyTrapped(enemy: Enemy, trap: Trap, attack: Attack) 
signal BossKilled(boss: Boss, attack: Attack)
## Player
signal PlayerDamaged(player: Character, attack: Attack)
signal PlayerShieldDamaged(player: Character, attack: Attack, shield_damage_amount: float)
signal PlayerDodged(player: Character, attack: Attack)
signal PlayerRevived(player: Character)
signal PlayerKilled(player: Character, attack: Attack)
signal PlayerHeal(heal_amount: float, heal_type: HealTypes)
signal PlayerMaxHealthChange(new_maxhp: float, old_maxhp: float)
signal PlayerShieldChanged(new_shield: float, old_shield: float)
signal EventKilled(event: Event, attack: Attack)
## Stats
signal StatsChanged
## Spawns:
signal ProjectileSpawned(projectile: Projectile)
signal CreationSpawned(creation: Creation)
signal TrapSpawned(trap: Trap)
signal SummonSpawned(summon: Summon)
signal CreationDamaged(creation: Creation, attack: Attack)
signal CreationKilled(creation: Creation, attack: Attack)
signal CreationDodged(creation: Creation, attack: Attack)
## Upgrades:
signal UpgradeCooldownFinished(upgrade: Upgrade)
## Main Weapon:
signal WeaponReloaded(weapon: Weapon)
signal ProjectileShot(weapon: Weapon, projectile: Projectile)
## Status on Enemies
signal BurnDamage(damage: float, enemy: Enemy)
signal FrostDamage(damage: float, enemy: Enemy)
signal PoisonDamage(damage: float, enemy: Enemy)
signal BleedDamage(damage: float, enemy: Enemy)
signal ShockDamage(damage: float, enemy: Enemy)
signal WetDamage(damage: float, enemy: Enemy)
signal BurnApplied(enemy: Enemy)
signal FrostApplied(enemy: Enemy)
signal PoisonApplied(enemy: Enemy)
signal BleedApplied(enemy: Enemy)
signal ShockApplied(enemy: Enemy)
signal WetApplied(enemy: Enemy)

#  ProjectileSpawned

func setup(new_player: Character, starting_weapon: String, new_camera: Camera2D):
	player = new_player
	camera = new_camera
	call_deferred("defer_once", starting_weapon)
	connect("level_up", create_level_up_instance)
	process_mode = Node.PROCESS_MODE_ALWAYS
	EnemyKilled.connect(enemy_killed)
	PlayerDamaged.connect(player_damaged)
	StatsChanged.connect(player.stats_changed)
func defer_once(starting_weapon: String):
	call_deferred("defer_twice", starting_weapon)
## It's Necessary to deferr this twice as it relies on stuff that is deferred once to happen (i don't know what exactly it relies on)
func defer_twice(starting_weapon: String):
	player.setup()
	revives_used = 0
	curr_hp = player.max_health
	curr_shield = player.max_shield
	level = 1
	xp = 0
	money = starting_money
	get_tree().paused = false
	var weapon: Weapon = ShopManager.get_weapon(starting_weapon)
	add_weapon(weapon)
func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
	CreationDodged.connect(creation_dodged)
func _process(_delta: float) -> void:
	if GameInstance.is_game_over:
		return
	if !leveling_up && level_up_queue > 0:
		create_level_up_instance()
## Weapons/Upgrades
func add_upgrade(data: UpgradeData) -> void:
	var upgrade: Upgrade = data.get_upgrade()
	if !is_instance_valid(upgrade):
		## We already error'd before
		printerr("UpgradeData.get_upgrade() is null for \"", data.upgrade_name, "\", Path: ", data.resource_path)
		return
	
	for active_upgrade in active_upgrades:
		## Can't use active_upgrades.has() because it's a typed array with resources?
		if active_upgrade.data == data:
			printerr("Trying to add upgrade that already exists in active upgrades: ", upgrade.item_name)
			return
	player.add_child(upgrade)
	active_upgrades.append(upgrade)
	ui_man.add_upgrade(upgrade)
	upgrade.activate(player)
	Statics.changed_stats()
func add_weapon(weapon: Weapon) -> void:
	weapon_list.append(weapon)
	var temp_count: int = weapon_count
	match weapon.AimType:
		Weapon.AimTypes.StaticSlot:
			static_slot_count += 1
			temp_count = static_slot_count
		Weapon.AimTypes.DynamicAtMouse:
			dynamic_at_mouse_count += 1
			temp_count = dynamic_at_mouse_count
		Weapon.AimTypes.AlwaysAtMouse:
			always_at_mouse_count += 1
			temp_count = always_at_mouse_count
		Weapon.AimTypes.Unique:
			spin_aim_count += 1
			temp_count = spin_aim_count
		_:
			weapon_count += 1
			temp_count = weapon_count
	var index: int = 0
	for equipped_weapon in weapon_list:
		if (equipped_weapon.AimType == weapon.AimType):
			index += 1
			equipped_weapon.change_slot(index, temp_count)
	ui_man.add_weapon(weapon)
	weapon.activate(player)
func add_equipment(equipment: Equipment) -> void:
	pass
func remove_upgrade(upgrade: Upgrade) -> void:
	upgrade.deactivate()
	active_upgrades.erase(upgrade)
	player.remove_child(upgrade)
func remove_weapon(weapon: Weapon) -> bool:
	if weapon && weapon_list.has(weapon):
		weapon_list.erase(weapon)
		var temp_count: int = weapon_count
		match weapon.AimType:
			Weapon.AimTypes.StaticSlot:
				static_slot_count -= 1
				temp_count = static_slot_count
			Weapon.AimTypes.DynamicAtMouse:
				dynamic_at_mouse_count -= 1
				temp_count = dynamic_at_mouse_count
			Weapon.AimTypes.AlwaysAtMouse:
				always_at_mouse_count -= 1
				temp_count = always_at_mouse_count
			Weapon.AimTypes.Unique:
				spin_aim_count -= 1
				temp_count = spin_aim_count
			_:
				weapon_count -= 1
				temp_count = weapon_count
		var index: int = 0
		for equipped_weapon in weapon_list:
			if (equipped_weapon.AimType == weapon.AimType):
				index += 1
				equipped_weapon.change_slot(index, temp_count)
		weapon.deactivate()
		return true
	return false
func remove_equipment(equipment: Equipment) -> void:
	pass
signal whatup ## TODO: simple input system
## Returns an unused keybind avaliable for use by an upgrade
func get_avaliable_combat_keybind() -> Signal:
	return whatup

## Pass a player's attack through each active upgrade 
func handle_attack(attack: Attack) -> Attack:
	for upgrade in active_upgrades:
		if upgrade.edits_attack:
			attack = upgrade.edit_attack(attack)
	return attack
## Pass a player's attack through each active upgrade - called right before applying to enemy
func handle_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	for upgrade in active_upgrades:
		if upgrade.edits_attack:
			attack = upgrade.edit_attack_enemy(attack, enemy)
	return attack
## Pass an enemy's attack through each active upgrade 
func handle_incoming_attack(attack: Attack, enemy: Enemy, character: Character) -> Attack:
	for upgrade in active_upgrades:
		if upgrade.edits_incoming_attack:
			attack = upgrade.edit_incoming_attack(attack, enemy, character)
	return attack

 
func create_level_up_instance():
	if leveling_up:
		level_up_queue += 1
		return
	leveling_up = true
	var level_pause: UIManager.PauseItem = UIManager.PauseItem.new(Callable(), UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.level_up_parent)
	ui_man.pause(level_pause)
	## get 3 random things w/ variable references
	var array: Array[LevelUpData] = LevelUpData.get_level_up_options(3)
	## setup LevelUpInstance with those random things and their details (color, name, etc)
	var level_instance = LEVEL_UP_UI.instantiate()
	level_instance.set_pause(level_pause)
	#level_instance.position = Vector2(0, 0)
	ui_man.level_up_parent.add_child(level_instance)
	for option in array:
		level_instance.add_choice(option)
	var choice: LevelUpData = await level_instance.get_choice()
	choice.carryout_level_up()
	level_instance.free_instance()
	level_up_queue -= 1
	leveling_up = false
func add_xp(added_xp: float):
	xp += added_xp
func heal_player(value: float, type: HealTypes): 
	var heal: float = curr_hp
	## Between 0 and missing health
	curr_hp += clamp(value, 0, max_hp - curr_hp)
	heal = curr_hp - heal
	if heal > 0:
		PlayerHeal.emit(heal, type)
func damage_player(damage: float):
	curr_hp -= damage
func can_revive() -> int:
	return (player.revives - revives_used) > 1
func use_revive():
	revives_used += 1
func pause(value: bool):
	if paused != value:
		paused = value
		emit_signal("pause_game", value)
		if paused:
			#Engine.time_scale = 1.0
			get_tree().paused = true
		else:
			#Engine.time_scale = 0.0
			get_tree().paused = false
## Signal Connections
func enemy_killed(enemy: Enemy, attack: Attack):
	if player.lifesteal > 0 && curr_hp < player.max_health:
		heal_player(player.lifesteal, HealTypes.lifesteal)
func player_damaged(playah: Character, attack: Attack):
	if attack.attacker != null && player.thorns > 0 && attack.attacker.has_method("damage") && "can_be_damaged" in attack.attacker && attack.attacker.get("can_be_damaged"):
		## Apply Thorns Damage to Attacker
		var new_status: StatusEffects = StatusEffects.new()
		new_status.applies_bleed = true
		#var new_attack = Attack.new(Attack.AttackTypes.player_misc, player, player.position, null, null, null)
		var new_attack: Attack = Attack.new(Attack.AttackSources.player, Attack.AttackTypes.thorns, player, player.global_position, new_status, null, null)
		new_attack.simple_setup(player.thorns, 0)
		attack.attacker.damage(new_attack)
## Shop
func has_upgrade_room():
	return upgrade_count <= upgrade_limit
func has_weapon_room():
	return weapon_count <= weapon_limit
func get_random_equipped_weapon() -> Weapon:
	if weapon_list.size() > 0:
		return weapon_list.get(randi_range(0, weapon_list.size() - 1))
	else:
		return null
func get_random_equipped_upgrade() -> Upgrade:
	if active_upgrades.size() > 0:
		return active_upgrades.get(randi_range(0, active_upgrades.size() - 1))
	else:
		return null
func get_random_equipped_upgrade_except(avoided_upgrades: Array[Upgrade]) -> Upgrade:
	var upgrades: Array[Upgrade] = active_upgrades.duplicate()
	upgrades.shuffle()
	for upgrade in upgrades:
		if !avoided_upgrades.has(upgrade):
			return upgrade
	return null

func creation_dodged(creation: Creation, attack: Attack):
	if Statics.creation_dodges_count_for_player > 0:
		PlayerDodged.emit(player, attack)
