extends RigidBody2D
class_name Enemy
@export_category("Enemy Information")
@export_placeholder("Write an Enemy Name!") var enemy_name: String = ""
@export_placeholder("lil description action?") var enemy_description: String = ""
@export var enemy_type: EnemyTypes = EnemyTypes.unset
enum EnemyTypes {unset}
@export_category("Enemy Stats")
@export var multiply_hp_by_minute: bool = true
@export var melee_attacks: bool = true
@export var damage_hitbox: Area2D
@export var can_be_knockbacked:bool = true
@export var can_be_stunned:bool = true
@export var xp_on_death: int = 10
@export var money_on_death: int = 3
@export var weapon_knockback: float = 50
@export var weapon_stun: float = 0
@export var self_knockback_onhit: float = 100.0
@export var base_damage: float = 10
@export var base_critchance: float = 0
@export var base_critdamage: float = 0
@export var base_movespeed: float = 20
## Added directly to movespeed
@export var movespeed_modifier: float = 0
@export var base_health: float = 10
@export var base_regen: float = 0
@export var base_knockback_modifier: float = 1
@export var base_damage_reduction: float = 0
@export var base_cooldown: float = 1
@export_category("Enemy Projectile Stats")
@export var projectile: PackedScene
@export var shoots_projectiles: bool = false
@export var homing: bool = false
@export var base_range: float = 100
@export var base_speed: float = 100
@export var base_acceleration: float = 2
@export var base_lifetime: float = 15
@export var base_piercing: float = 0
@export_category("Status Effects")
# enemy's attacking status buildups (for if we charm enemies? to apply status on each other?)
@export var status: StatusEffects = StatusEffects.new()
# enemy's attacking buildup value
@export var buildup: float = 1
# ignore status buildup booleans
@export var immune_to_burn: bool = false
@export var immune_to_frost: bool = false
@export var immune_to_poison: bool = false
@export var immune_to_bleed: bool = false
@export var immune_to_shock: bool = false
@export var immune_to_wet: bool = false
# values to reach to activate status effect state
@export var burn_threshhold: float = 1
@export var frost_threshhold: float = 1
@export var poison_threshhold: float = 1
@export var bleed_threshhold: float = 1
@export var shock_threshhold: float = 1
@export var wet_threshhold: float = 1
## Current values of each status that have been damaged into this enemy
var burn: float = 0
var frost: float = 0
var poison: float = 0
var bleed: float = 0
var shock: float = 0
var wet: float = 0
## Bool values that are calculated on the fly saying if these status effects are applied right now (or have been applied for some of them)
var is_burning: bool = false:
	get():
		return burn >= burn_threshhold
var is_frosted: bool = false:
	get():
		return applied_frost > 0
var is_poisoned: bool = false:
	get():
		return poison >= poison_threshhold
## is_bleeding means that this enemy has has a blood proc in the past (and it hasn't been removed)
var is_bleeding: bool = false:
	get():
		## Has applied bleed
		return applied_bleed > 0
var is_shocked: bool = false:
	get():
		return shock >= shock_threshhold
var is_wet: bool = false:
	get():
		return wet >= wet_threshhold
# count for how many times status have been applied
var applied_burn: int = 0
var applied_frost: int = 0
var applied_poison: int = 0
var applied_bleed: int = 0
var applied_shock: int = 0
var applied_wet: int = 0
# Values
var frost_movespeed_reduction: float = 0
var shock_defense_reduction: float = 0
@export_category("Misc")
@export var turns_towards_movement: bool = false
@onready var anim: AnimatedSprite2D = $EnemySprite
@onready var burn_anim: AnimatedSprite2D = $StatusEffectAnims/Burn
@onready var frost_anim: AnimatedSprite2D = $StatusEffectAnims/Frost
@onready var poison_anim: AnimatedSprite2D = $StatusEffectAnims/Poison
@onready var bleed_anim: AnimatedSprite2D = $StatusEffectAnims/Bleed
@onready var shock_anim: AnimatedSprite2D = $StatusEffectAnims/Shock
@onready var wet_anim: AnimatedSprite2D = $StatusEffectAnims/Wet
const XP = preload("res://Scenes/Misc/xp_blip.tscn")
const ITEM_DROP = preload("uid://d3v2pdpqpmvpe")
var player: Character
var attack_on_cd: bool = true
var stun_time_left: float = 0
var stunned: bool = false
var curr_health: float
var curr_movespeed: float
var curr_regen: float 
var curr_knockback_modifier: float
var curr_damage_reduction: float
var curr_cooldown_max: float
var cooldown_stopwatch: float = 0
## Projectile Stats:
var projectile_cooldown_stopwatch: float = 0
var curr_range: float
var curr_speed: float
var curr_acceleration: float
var curr_lifetime: float
var curr_piercing: float
var curr_damage: float:
	get():
		return calculate_enemy_damage(base_damage, level, difficulty)
var curr_critchance: float
var curr_critdamage: float
## Misc:
var facing_left: bool = true
var ImReady: bool = false
var can_drop_stuff: bool = true
## Called on death with position of death
signal death(position: Vector2)
## Player Level at time Enemy was spawned
var minute: float
var level: float 
var difficulty: float 
##
var dead: bool = false

func _ready() -> void:
	anim.visible = false
	flash()
	call_deferred("set_stats")
	call_deferred("setup") 
	add_to_group("enemy")
func flash():
	await get_tree().create_timer(0.1).timeout
	anim.visible = true
## called whever stats change
func set_stats():
	curr_regen = base_regen
	curr_movespeed = base_movespeed + movespeed_modifier
	curr_knockback_modifier = base_knockback_modifier
	curr_damage_reduction = base_damage_reduction
	curr_cooldown_max = base_cooldown ##TODO: setup based on stats
	curr_range = base_range
	curr_speed = base_speed
	curr_acceleration = base_acceleration
	curr_lifetime = base_lifetime
	curr_piercing = base_piercing
	curr_damage = calculate_enemy_damage(base_damage, level, difficulty)
	## Recalcuate base_health given minute/difficulty/etc
	base_health = calculate_enemy_hp(base_health, minute + 1, difficulty, multiply_hp_by_minute)
	curr_health = base_health
	curr_critchance = base_critchance
	curr_critdamage = base_critdamage
##
func setup():
	player = get_tree().get_first_node_in_group("player")
	ImReady = true
	#stats.connect_changed_signal(set_stats)
## Calculate HP with given Character Level
func initialize(new_minute: float, new_level: float, new_difficulty: float):
	level = new_level
	difficulty = new_difficulty
	minute = new_minute
	#call_deferred("set_stats")
	#call_deferred("setup")
	#add_to_group("enemy")
func _process(delta: float) -> void:
	if !ImReady || dead:
		return
	
	if GameInstance.instance && global_position.distance_to(player.global_position) > GameInstance.instance.enemy_max_distance_to_player:
		GameInstance.instance.remove_enemy(self)
		dead = true
		return
	
	if stun_time_left > 0:
		stun_time_left -= delta
	elif stunned:
		stunned = false
	
	if cooldown_stopwatch < curr_cooldown_max:
		cooldown_stopwatch += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		if melee_attacks:
			if damage_hitbox.monitoring == false:
				damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player
	
	if shoots_projectiles:
		if projectile_cooldown_stopwatch < curr_cooldown_max:
			projectile_cooldown_stopwatch += delta
		else:
			if is_player_nearby(curr_range):
				projectile_cooldown_stopwatch = 0
				var proj: EnemyProjectile = projectile.instantiate()
				GameManager.instance.projectile_parent.add_child(proj)
				proj.modulate = self.modulate
				proj.global_position = global_position
				## 1 damage at minimum
				proj.setup_enemy(self, player, global_position - player.global_position, homing, 20, false, 0) #curr_piercing, curr_lifetime, max(1, curr_damage + frost_damage_reduction), curr_speed, 1, 1, scale.length(), curr_acceleration)
func _physics_process(delta: float) -> void:
	if !ImReady:
		return
	if !stunned:
		movement_process(delta)
		
	status_process(delta)
## Overriden by extender for custom enemy movement
func movement_process(_delta: float) ->void:
	move_towards(player.global_position, curr_movespeed + frost_movespeed_reduction, _delta)
var half_second_cd: float = 0
var second_cd: float = 0
var two_second_cd: float = 0
## Handles Processing Status Effect defense and effects
func status_process(delta: float) -> void:
	## Only process status effects every half second
	if half_second_cd >= 0.5:
		half_second_cd = 0
	else:
		half_second_cd += delta
		return
	var second: bool = false
	var two_second: bool = false
	var most_recent_attack: Attack 
	second_cd += 0.5 # half a second has passed
	if second_cd >= 1:
		second_cd = 0
		second = true
	two_second_cd += 0.5 # half a second has passed
	if two_second_cd >= 2:
		two_second_cd = 0
		two_second = true
	## BURN: Burn every 1 second, damage based on how many times over threshold
	if !is_burning:
		applied_burn = 0
	elif !immune_to_burn:
		if second:
			most_recent_attack = proc_burn()
			## Death
			if check_death(most_recent_attack):
				return
	## FROST: Lower Movespeed based on frost
	if !immune_to_frost:
		if (frost / frost_threshhold) > (applied_frost + 1):
			most_recent_attack = proc_frost()
			## Death
			if check_death(most_recent_attack):
				return
		if !is_frosted:
			frost_movespeed_reduction = 0
	## POISON: Take damage every 2 seconds
	if !is_poisoned:
		applied_poison = 0
	elif !immune_to_poison:
		if two_second:
			most_recent_attack = proc_poison()
			## Death
			if check_death(most_recent_attack):
				return
	## BLEED: do nothing until bleed threshold reached, then big damage, then raise bleed threshold
	if !immune_to_bleed:
		if (bleed / bleed_threshhold) > (applied_bleed + 1):
			print("bleed proc: ",(bleed / bleed_threshhold), " > " , applied_bleed + 1)
			most_recent_attack = proc_bleed()
			## Death
			if check_death(most_recent_attack):
				return
	## SHOCK:
	if !is_shocked:
		applied_shock = 0
		shock_defense_reduction = 0
	elif !immune_to_shock:
		if applied_shock != floor(shock / shock_threshhold):
			proc_shock()
	## WET:
	if !is_wet:
		applied_wet = 0
	elif !immune_to_wet:
		if applied_wet != floor(wet / wet_threshhold):
			proc_wet()

func check_death(attack: Attack) -> bool:
	if curr_health <= 0:
		death_signal(attack)
		die()
		return true
	return false

func proc_burn() -> Attack:
	if burn_anim:
		burn_anim.play("default")
	## Do the math
	var current_burn_damage: float = get_burn_damage()
	var attack: Attack = make_status_attack(current_burn_damage, StatusEffects.StatusTypes.burn)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BurnDamage.emit(current_burn_damage, self)
	applied_burn += 1
	curr_health -= current_burn_damage
	## Do the display dmg
	display_damage(current_burn_damage, Color.RED)
	return attack
func proc_frost() -> Attack:
	if frost_anim:
		frost_anim.play("default")
	applied_frost = floor(frost / frost_threshhold)
	frost_movespeed_reduction = get_frost_movespeed_reduction()
	## Do the math
	var current_frost_damage: float = get_frost_damage()
	var attack: Attack = make_status_attack(current_frost_damage, StatusEffects.StatusTypes.frost)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.FrostDamage.emit(current_frost_damage, self)
	applied_frost += 1
	curr_health -= current_frost_damage
	## Do the display dmg
	display_damage(current_frost_damage, Color.LIGHT_SKY_BLUE)
	## Raise the threshold
	frost_threshhold *= GlobalStats.enemy_frost_threshold_multiplier
	return attack
func proc_poison() -> Attack:
	if poison_anim:
		poison_anim.play("default")
	## Do the math
	var current_poison_damage: float = get_poison_damage()
	var attack: Attack = make_status_attack(current_poison_damage, StatusEffects.StatusTypes.poison)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.PoisonDamage.emit(current_poison_damage, self)
	applied_poison += 1
	curr_health -= current_poison_damage
	## Do the display dmg
	display_damage(current_poison_damage, Color.GREEN)
	return attack
func proc_bleed() -> Attack:
	if bleed_anim:
		bleed_anim.play("default")
	## Do the math
	# does x percent of health each bleed proc
	var current_bleed_damage: float = get_bleed_damage()
	var attack: Attack = make_status_attack(current_bleed_damage, StatusEffects.StatusTypes.bleed)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BleedDamage.emit(current_bleed_damage, self)
	applied_bleed += 1
	curr_health -= current_bleed_damage
	## Do the display dmg
	display_damage(current_bleed_damage, Color.DARK_RED)
	## Raise bleed threshold
	bleed_threshhold *= GlobalStats.enemy_bleed_threshold_multiplier
	return attack
func proc_shock():
	if shock_anim:
		shock_anim.play("default")
	applied_shock = floor(shock / shock_threshhold)
	shock_defense_reduction = get_shock_defense_reduction()
func proc_wet():
	if wet_anim:
		wet_anim.play("default")
	applied_wet = floor(wet / wet_threshhold)

func get_burn_damage() -> float:
	return GlobalStats.get_stat(GlobalStats.BURN_DAMAGE)
func get_frost_movespeed_reduction() -> float:
	## -base * number of times threshold has been reached
	return -1 * (frost / frost_threshhold) * GlobalStats.enemy_frost_movespeed_reduction
func get_frost_damage() -> float:
	return curr_health * (GlobalStats.get_stat(GlobalStats.FROST_DAMAGE) / 100)
func get_shock_defense_reduction() -> float:
	## base * number of times threshold has been reached
	return (shock / shock_threshhold) * GlobalStats.enemy_shock_defense_reduction
func get_bleed_damage() -> float:
	return base_health * (GlobalStats.get_stat(GlobalStats.BLEED_DAMAGE) / 100)
func get_poison_damage() -> float:
	# 1/4 of max health for each time above threshold
	var mulitplier: float = floor(poison / poison_threshhold)
	return base_health * GlobalStats.get_stat(GlobalStats.POISON_DAMAGE) * mulitplier
## Makes a status effect attack to attack self (when a status effect damages this enemy)
func make_status_attack(status_damage: float, type: StatusEffects.StatusTypes) -> Attack:
	## Report what type of status effect it was
	var status_effects: StatusEffects
	if type == StatusEffects.StatusTypes.burn:
		status_effects = StatusEffects.new()
		status_effects.applies_burn = true
	if type == StatusEffects.StatusTypes.frost:
		status_effects = StatusEffects.new()
		status_effects.applies_frost = true
	if type == StatusEffects.StatusTypes.poison:
		status_effects = StatusEffects.new()
		status_effects.applies_poison = true
	if type == StatusEffects.StatusTypes.bleed:
		status_effects = StatusEffects.new()
		status_effects.applies_bleed = true
	if type == StatusEffects.StatusTypes.shock:
		status_effects = StatusEffects.new()
		status_effects.applies_shock = true
	if type == StatusEffects.StatusTypes.wet:
		status_effects = StatusEffects.new()
		status_effects.applies_wet = true
	## Make attack
	var attack: Attack = Attack.new(Attack.AttackTypes.enemy_status, null, global_position, status_effects, null, null)
	attack.simple_setup(status_damage, 0)
	return attack
## Overriden by enemies who want different projectile vs melee damage
func damage_player_projectile(_damage_player: Node2D):
	damage_player(_damage_player, true)
func shoot_projectile():
	pass
func die():
	if !dead:
		var game_man: GameManager = GameManager.instance
		dead = true
		death.emit(position)
		visible = false
		## Give money
		game_man.money += money_on_death + level + minute
		## Drop XP
		var new_xp = XP.instantiate()
		game_man.xp_parent.add_child(new_xp)
		new_xp.global_position = global_position
		new_xp.set_xp(xp_on_death)
		if can_drop_stuff:
			## Chance to drop random component
			if randf() < GameInstance.drop_chance_component:
				drop_item()
			elif GameInstance.next_enemy_drops_component:
				drop_item()
				GameInstance.next_enemy_drops_component = false
			## Drop Forge Check
			if GameInstance.next_enemy_drops_forge:
				GameInstance.next_enemy_drops_forge = false
				drop_forge()
			## Chance to drop powerups (magnet, fire, 2x money, etc)
			if randf() < GameInstance.drop_chance_powerup:
				drop_powerup()
		queue_free()
## Drops a forge (drops when GameInstance says so)
func drop_forge():
	pass#GameInstance.drop_item(GameInstance.FORGE_DROP.duplicate(), global_position)
## Drops a random component (enemies have a chance)
func drop_item():
	pass#GameInstance.drop_item(ShopManager.get_rand_upgrade().get_upgrade(), global_position)
## Drops a chest (currenlty simple enemies don't have a chance to drop chests)
func drop_chest():
	GameInstance.drop_chest("Random Weapon!", -1, -1, -1, global_position)
## Drops a Powerup
func drop_powerup():
	GameInstance.drop_powerup(global_position)
## Makes a PopupText for the given damage and color, Color.TRANSPARENT for random color
func display_damage(damage_value: float, color: Color):
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	if color == Color.TRANSPARENT:
		dmg_text.setup(str(int(round(damage_value))), damage_value + randi_range(-5, 5), WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10))
	else:
		dmg_text.setup_color(str(int(round(damage_value))), damage_value + randi_range(-5, 5), WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), color)

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") && body.is_in_group("player"):
		damage_player(body, false)
		## Handles self knockback on attack player
		if self_knockback_onhit != 0:
			apply_knockback(body.global_position, self_knockback_onhit)
func damage_player(_damage_player: Node2D, from_projectile: bool):
	cooldown_stopwatch = 0;
	var attack: Attack
	if from_projectile:
		attack = Attack.new(Attack.AttackTypes.enemy_projectile, self, global_position, status, null, null)
	else:
		attack = Attack.new(Attack.AttackTypes.enemy_melee, self, global_position, status, null, null)
	## Simple Setup for Attack
	attack.simple_setup(GlobalStats.calculate_damage(curr_damage, curr_critchance, curr_critdamage), weapon_knockback)
	_damage_player.damage(attack) #TODO: put into game manager?
	if melee_attacks:
		damage_hitbox.set_deferred("monitoring", false)
func move_towards(new_position: Vector2, movespeed: float, _delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	linear_velocity = linear_velocity.move_toward(Vector2(direction.x * movespeed, direction.y * movespeed), 9)
	
	var new_facing_left: bool = linear_velocity.x < 0
	if anim && turns_towards_movement && facing_left != new_facing_left:
		facing_left = new_facing_left
		anim.flip_h = !facing_left
func is_player_nearby(distance: float) -> bool:
	if global_position.distance_to(player.global_position) <= distance:
		return true
	return false
func damage(attack: Attack):
	if GameInstance.is_game_over:
		return
	## Apply Damage
	var damage_taken = attack.get_damage() - curr_damage_reduction 
	if damage_taken > 0:
		GameManager.instance.EnemyDamaged.emit(self, attack)
		curr_health -= damage_taken
	## Apply Status Effect Changes (doesn't apply status effect effects yet)
	burn += attack.get_burn()
	frost += attack.get_frost()
	poison += attack.get_poison()
	bleed += attack.get_bleed()
	shock += attack.get_shock()
	wet += attack.get_wet()
	print("Add Burn: ", attack.get_burn(), " Applied: ", attack.status.applies_burn)
	print("Add Frost: ", attack.get_frost(), " Applied: ", attack.status.applies_frost)
	print("Add Poison: ", attack.get_poison(), " Applied: ", attack.status.applies_poison)
	print("Add Bleed: ", attack.get_bleed(), " Applied: ", attack.status.applies_bleed)
	print("Add Shock: ", attack.get_shock(), " Applied: ", attack.status.applies_shock)
	print("Add Wet: ", attack.get_wet(), " Applied: ", attack.status.applies_wet)
	## Apply Stun and Knockback
	if attack.get_stun() > 0 && can_be_stunned:
			stun_time_left = attack.get_stun()
			stunned = true
			linear_velocity = Vector2.ZERO
	if can_be_knockbacked && attack.get_knockback() != 0:
		if stun_time_left < 1 && can_be_stunned:
			stun_time_left = 0.2
			stunned = true
		apply_knockback(attack.position, attack.get_knockback())
	display_damage(attack.get_damage(), Color.TRANSPARENT)
	## Die.
	check_death(attack)
func death_signal(attack: Attack):
	GameManager.instance.EnemyKilled.emit(self, attack)
func apply_knockback(attack_pos: Vector2, knockback: float):
	call_deferred("set_linear_velocity", (global_position - attack_pos).normalized() * knockback * curr_knockback_modifier)
static func calculate_enemy_hp(base_hp: float, hp_mult: float, game_difficulty: float, multiply_hp: bool) -> float:
	var ret: float = base_hp
	if multiply_hp:
		ret *= hp_mult
	ret *= 1 + (game_difficulty / 50)
	return ret
static func calculate_enemy_damage(base_dmg: float, game_level: float, game_difficulty: float) -> float:
	var ret: float = base_dmg
	ret *= 1 + (game_difficulty / 50)
	return ret
