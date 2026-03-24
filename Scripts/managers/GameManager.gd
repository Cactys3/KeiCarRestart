extends Node
class_name GameManager

const LEVEL_UP_UI = preload("uid://cykl0goweao0i")

## Single Instance Object
static var instance: GameManager
## Managers
@export var ui_man: UIManager 
@export var shop_man: ShopManager
@export var player: Character
## Parents
@export var xp_parent: Node2D
@export var enemy_parent: Node2D
@export var weapon_parent: Node2D
@export var projectile_parent: Node2D

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
var shield: float = 0:
	set(value):
		shield = value
		ui_man.set_shield(value)
var curr_hp: float = 0:
	set(value):
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

var paused: bool = false ## Is Game Instance Paused or Not
var level_up_queue: int = 0
var leveling_up: bool = false
## Signals
## For GameManager Systems
signal pause_game(value: bool)
signal level_up()
## For UI Methods
signal toggle_inventory() #TODO: add bool value to keep track of toggle state?
signal toggle_esc()
signal set_xp(value: float)
signal set_money(value: float)
signal set_level(value: float)
signal set_hp(value: float)
## For Upgrade Mechanics
signal EnemyDamaged(enemy: Enemy, attack: Attack)
signal EnemyKilled(enemy: Enemy, attack: Attack)
signal BossKilled(boss: Boss, attack: Attack)
signal PlayerDamaged(player: Character, attack: Attack)
signal PlayerRevived(player: Character)
signal PlayerKilled(player: Character, attack: Attack)
signal WeaponReloaded(weapon: Weapon)
signal WeaponFired(weapon: Weapon, projectile: Projectile)
signal RoundEnded(round_number: int)
signal BurnProc(damage: float, enemy: Enemy)
signal ForstProc(damage: float, enemy: Enemy)
signal PoisonProc(damage: float, enemy: Enemy)
signal BleedProc(damage: float, enemy: Enemy)
signal ShockProc(damage: float, enemy: Enemy)
signal WetProc(damage: float, enemy: Enemy)
func setup(new_player: Character, starting_weapon: String):
	player = new_player
	call_deferred("defer_once", starting_weapon)
	connect("level_up", create_level_up_instance)
	process_mode = Node.PROCESS_MODE_ALWAYS
	EnemyKilled.connect(enemy_killed)
	PlayerDamaged.connect(player_damaged)
func defer_once(starting_weapon: String):
	call_deferred("defer_twice", starting_weapon)
## It's Necessary to deferr this twice as it relies on stuff that is deferred once to happen (i don't know what exactly it relies on)
func defer_twice(starting_weapon: String):
	player.initialize_stats()
	revives_used = 0
	
	curr_hp = player.health
	shield = player.shield
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
func _process(_delta: float) -> void:
	if GameInstance.is_game_over:
		return
	if !leveling_up && level_up_queue > 0:
		create_level_up_instance()

func add_upgrade(data: UpgradeData) -> void:
	var upgrade: Upgrade = data.get_upgrade()
	if active_upgrades.has(data):
		printerr("Trying to add upgrade that already exists in active upgrades: ", upgrade.item_name)
		return
	upgrade.activate(player)
	active_upgrades.append(upgrade)
	ui_man.add_upgrade(upgrade)
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
## Pass a player's attack through each active upgrade 
func handle_player_attack(attack: Attack) -> Attack:
	for upgrade in active_upgrades:
		if upgrade.edits_attack:
			attack = upgrade.edit_attack(attack)
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
	if player.lifesteal > 0 && curr_hp < player.health:
		curr_hp += player.lifesteal
func player_damaged(playah: Character, attack: Attack):
	if attack.attacker != null && player.thorns > 0 && attack.attacker.has_method("damage"):
		## Apply Thorns Damage to Attacker
		var new_status: StatusEffects = StatusEffects.new()
		new_status.applies_bleed = true
		var new_attack = Attack.new(Attack.AttackTypes.player_misc, player, player.position, null, null, null)
		new_attack.simple_setup(player.thorns, 0)
		attack.attacker.damage(new_attack)
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
## Returns all upgrades that are valid to obtain given prereqs
