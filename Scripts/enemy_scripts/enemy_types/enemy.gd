extends RigidBody2D
class_name Enemy
@export_placeholder("Write an Enemy Name!") var enemy_name: String = ""
@export_placeholder("lil description action?") var enemy_description: String = ""
@export var enemy_type: EnemyTypes = EnemyTypes.unset
enum EnemyTypes {unset}
@export_group("Visuals")
@export var turns_towards_player: bool = false
@export var turns_towards_movement: bool = false
@export var rotate_towards_movement: bool = false
## -1 Means instant, else lerp
@export var rotation_speed: float = -1
@export var rotation_offset: float = 0
@export_group("Data")
@export var multiply_hp_by_minute: bool = true
@export var melee_attacks: bool = true
@export var stop_distance_from_player: float = -1
@export var can_be_knockbacked: bool = true
@export var can_be_stunned: bool = true
@export var can_be_slowed: bool = true
@export var can_be_frozen: bool = true
## -1 for infininte, any other number for die after attacking for that count
@export var die_after_attack_count: float = -1
var attack_count: float = 0
## Percent damage this enemy deals to other enemies
@export var friendly_fire_damage_reduction: float = 0.5
## The delta value used in movement's MoveTo()
@export var movespeed_delta_modifier: float = 15
## Should the Hitbox attack things
@export var xp_on_death: int = 10
@export var money_on_death: int = 3
@export var self_knockback_onhit: float = 100.0
## Added directly to movespeed
@export var movespeed_modifier: float = 0
@export var percent_damage_taken: float = 1
@export_group("Stats")
@export var base_damage: float = 10
@export var base_health: float = 50
@export var base_movespeed: float = 20
## 0:Light, 1:Medium, 2:Big, 3:Huge, 4:Boss
@export var base_weight: float = 0
@export var base_regen: float = 0
@export var base_knockback_modifier: float = 1.0
@export var base_damage_reduction: float = 5
@export var base_cooldown: float = 1
@export var base_critchance: float = 0
@export var base_critdamage: float = 0
@export_group("Projectile")
@export var shoots_projectiles: bool = false
@export var shoot_enemy_in_range: bool = false
@export var projectile: PackedScene
@export var projectile_attack_cooldown: float = 5
@export var base_range: float = 100

@export_group("Status Effects")
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
@export_group("Custom Visuals")
## Enemy will randomly choose one of the variations (animation names) on ready
@export var animation_variations: Array[String] = []
var my_variation: String = "default"
@export var play_animation_before_ready: String = NO_ANIMATION_NAME
const NO_ANIMATION_NAME: String = "no animation"
@export var spawn_on_death: PackedScene = null
@export var sound_on_death: Sound
@export var play_animation_on_death: String = NO_ANIMATION_NAME
@export var is_dead_during_animation: bool = true
@export_group("Export Nodes (Only If Custom Layout)")
@export var anim: AnimatedSprite2D
@export var particles: EntityParticles
@export var damage_hitbox: Area2D 
@export var health_hitbox: Area2D 
@export var minion_block: CollisionShape2D
const stun_on_knockback: float = 0.5
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
var frozen: bool = false
var movespeed_frozen_time_left: float = 0
var frost_movespeed_reduction: float = 0
var shock_defense_reduction: float = 0

const XP = preload("res://Scenes/Misc/xp_blip.tscn")
const ITEM_DROP = preload("uid://d3v2pdpqpmvpe")
var player: Character
var attack_on_cd: bool = true
var slow_time_left: float = 0
var slow_strength: float = 0
var slowed: bool = false
var stun_time_left: float = 0
var stunned: bool = false
var curr_health: float
var curr_weight: float:
	set(value):
		curr_weight = value
		## Can't be negative, but mass is based on weight
		if value + 1 >= 0:
			mass = (value + 1) * 5
var curr_movespeed: float
var curr_regen: float 
var curr_knockback_modifier: float
var curr_damage_reduction: float
var curr_cooldown_max: float
var cooldown_stopwatch: float = 0
var time_since_knockedback: float = 0
## Projectile Stats:
var projectile_attack_stopwatch: float = 0
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
var stored_linear_velocity: Vector2 
var stored_angular_velocity: float 
var facing_left: bool = true
var ImReady: bool = false
var can_drop_stuff: bool = true
## Can values
var hitbox_disabled: bool = false
var can_be_damaged: bool = true
var can_move: bool = true
## Can attack variables updated by other things dynamically
var can_attack_enemies: bool = false
var can_attack_events: bool = false
var can_attack_player: bool = true
var can_attack_creations: bool = true
## Called on death with position of death
signal death(position: Vector2)
## Player Level at time Enemy was spawned
var minute: float
var level: float 
var difficulty: float 
##
var dead: bool = false

func _ready() -> void:
	## OnReady + Export Vars
	if !anim && $EnemySprite:
		anim = $EnemySprite
	if !particles && $StatusEffects:
		particles = $StatusEffects
	if !damage_hitbox && $Damage_Hitbox:
		damage_hitbox = $Damage_Hitbox
	if !minion_block && $MinionBlock:
		minion_block = $MinionBlock
	if !health_hitbox && $Health_Hitbox:
		health_hitbox = $Health_Hitbox
	## Flash Fix
	anim.visible = false
	## Health Hitbox: Layer = Enemy
	health_hitbox.setup(self)
	health_hitbox.set_collision_layer_value(4, true)
	health_hitbox.set_collision_layer_value(1, false)
	health_hitbox.set_collision_mask_value(1, false)
	## Damage Hitbox: Layer = Enemy_Weapon, Mask = Enemy, Player, Creation, Event
	damage_hitbox.set_collision_layer_value(5, true)
	damage_hitbox.set_collision_mask_value(2, true)
	damage_hitbox.set_collision_mask_value(8, true)
	damage_hitbox.set_collision_mask_value(4, true)
	damage_hitbox.set_collision_mask_value(10, true)
	damage_hitbox.set_collision_layer_value(1, false)
	damage_hitbox.set_collision_mask_value(1, false)
	## Detect Attack Signal
	if !damage_hitbox.body_entered.is_connected(_on_damage_hitbox_body_entered):
		damage_hitbox.body_entered.connect(_on_damage_hitbox_body_entered)
	if !damage_hitbox.area_entered.is_connected(_on_damage_hitbox_body_entered):
		damage_hitbox.area_entered.connect(_on_damage_hitbox_body_entered)
	## Self: Both = Enemy Minion Block
	set_collision_layer_value(6, true)
	set_collision_mask_value(6, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	gravity_scale = 0
	lock_rotation = true
	flash()
	call_deferred("set_stats")
	call_deferred("setup")
	add_to_group("enemy")
func flash():
	await get_tree().create_timer(0.1, false).timeout
	anim.visible = true
## called whever stats change
func set_stats():
	curr_weight = base_weight
	curr_regen = base_regen
	curr_movespeed = base_movespeed + movespeed_modifier
	curr_knockback_modifier = base_knockback_modifier
	curr_damage_reduction = base_damage_reduction
	curr_cooldown_max = base_cooldown ##TODO: setup based on stats
	curr_range = base_range
	curr_damage = calculate_enemy_damage(base_damage, level, difficulty)
	## Recalcuate base_health given minute/difficulty/etc
	base_health = calculate_enemy_hp(base_health, minute + 1, difficulty, multiply_hp_by_minute)
	curr_health = base_health
	curr_critchance = base_critchance
	curr_critdamage = base_critdamage
## Check for Intro Animations and Animation Variations
func setup():
	if animation_variations.size() > 0:
		my_variation = animation_variations.pick_random()
		anim.play(my_variation)
	player = get_tree().get_first_node_in_group("player")
	## Check if we play an animation before ready
	if !anim || play_animation_before_ready == NO_ANIMATION_NAME:
		ImReady = true
	else:
		if !anim.sprite_frames.has_animation(play_animation_before_ready):
			printerr("Trying to play animation for enemy, but doesn't have: ", play_animation_before_ready)
		else:
			anim.play(play_animation_before_ready)
			await anim.animation_finished
			anim.play(my_variation)
			if anim.animation != my_variation:
				printerr("Tried and fail to play enemy animation variation: ", my_variation, ", on enemy: ", enemy_name)
		ImReady = true
	#stats.connect_changed_signal(set_stats)
## Calculate HP with given Character Level
func initialize(new_minute: float, new_level: float, new_difficulty: float):
	level = new_level
	difficulty = new_difficulty
	minute = new_minute
func _process(delta: float) -> void:
	if !ImReady:
		return
	if !can_move && abs(linear_velocity.length()) > 0:
		linear_velocity = Vector2.ZERO
	if dead:
		return
	## Too far
	if GameInstance.instance && global_position.distance_to(player.global_position) > GameInstance.instance.enemy_max_distance_to_player:
		GameInstance.instance.remove_enemy(self)
		dead = true
		return
	time_since_knockedback += delta
	## Slow
	if slow_time_left > 0:
		slow_time_left -= delta
	elif slowed:
		slowed = false
	## Stun
	if stun_time_left > 0:
		stun_time_left -= delta
	elif stunned:
		stunned = false
	## Frozen
	if movespeed_frozen_time_left > 0:
		particles.toggle_frozen(true)
		frozen = true
		movespeed_frozen_time_left -= delta
	elif frozen:
		particles.toggle_frozen(false)
		frozen = false
		movespeed_frozen_time_left = 0
	## attack cooldown
	if cooldown_stopwatch < curr_cooldown_max:
		cooldown_stopwatch += delta
		attack_on_cd = true
	else:
		attack_on_cd = false
		if melee_attacks:
			if damage_hitbox.monitoring == false && !hitbox_disabled:
				damage_hitbox.set_deferred("monitoring", true) #handles the hitbox turning off for a CD after hitting the player
	## Projectile Shoot
	if shoots_projectiles:
		if projectile_attack_stopwatch < projectile_attack_cooldown:
			projectile_attack_stopwatch += delta
		else:
			if shoot_enemy_in_range:
				if is_player_nearby(curr_range):
					shoot_projectile(player)
					projectile_attack_stopwatch = 0
			else:
				shoot_projectile(player)
				projectile_attack_stopwatch = 0
func _physics_process(delta: float) -> void:
	if !ImReady || dead:
		return
	if !stunned:
		movement_process(delta)
	else:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 500 * delta)
	status_process(delta)
## Overriden by extender for custom enemy movement
func movement_process(_delta: float) -> void:
	if can_move:
		var target_position: Vector2 = player.global_position
		if stop_distance_from_player > 0:
			target_position += (global_position - target_position).normalized() * stop_distance_from_player
		move_towards(target_position, max(0, get_movespeed()), _delta)
## Stops the current velocity and stores it for later
func stop_movement() -> void:
	can_move = false
	stored_linear_velocity = linear_velocity
	stored_angular_velocity = angular_velocity
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	freeze = true
## Restarts movement based on the stored velocity, if stored
func restart_movement(retain_movement: bool) -> void:
	can_move = true
	if retain_movement:
		linear_velocity = stored_linear_velocity
		angular_velocity = stored_angular_velocity
	stored_linear_velocity = Vector2.ZERO
	stored_angular_velocity = 0
	freeze = false

var half_second_cd: float = 0
var second_cd: float = 0
var two_second_cd: float = 0
var check_status_now: bool = false
## Handles Processing Status Effect defense and effects
func status_process(delta: float) -> void:
	
	## TODO: Rework so that killing enemies with an attack also proc's status effects (it currently skips status)
	## Also make it so killing enemies with a particular status, still goes on to checking the rest of status
	
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
		particles.toggle_burn(false)
	elif !immune_to_burn:
		if second:
			most_recent_attack = proc_burn()
			## Death
			if check_death(most_recent_attack):
				return
	## FROST: Lower Movespeed based on frost
	if !immune_to_frost:
		if (frost / frost_threshhold) >= (applied_frost + 1):
			most_recent_attack = proc_frost()
			## Death
			if check_death(most_recent_attack):
				return
	if !is_frosted:
		particles.toggle_frost(false)
		frost_movespeed_reduction = 0
	## POISON: Take damage every 2 seconds
	if !is_poisoned:
		applied_poison = 0
		particles.toggle_poison(false)
	elif !immune_to_poison:
		if two_second:
			most_recent_attack = proc_poison()
			## Death
			if check_death(most_recent_attack):
				return
	## BLEED: do nothing until bleed threshold reached, then big damage, then raise bleed threshold
	if !immune_to_bleed:
		if (bleed / bleed_threshhold) >= (applied_bleed + 1):
			most_recent_attack = proc_bleed()
			## Death
			if check_death(most_recent_attack):
				return
	if !is_bleeding:
		particles.toggle_bleed(false)
	## SHOCK:
	if !is_shocked:
		applied_shock = 0
		shock_defense_reduction = 0
		particles.toggle_shock(false)
	elif !immune_to_shock:
		if applied_shock != floor(shock / shock_threshhold):
			proc_shock()
	## WET:
	if !is_wet:
		applied_wet = 0
		particles.toggle_wet(false)
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
	if particles:
		particles.toggle_burn(true)
	## Do the math
	var current_burn_damage: float = get_burn_damage()
	var attack: Attack = make_status_attack(current_burn_damage, StatusEffects.StatusTypes.burn)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BurnDamage.emit(current_burn_damage, self)
	applied_burn += 1
	curr_health -= current_burn_damage
	## Do the display dmg
	display_damage(current_burn_damage, Color.RED, false)
	if DebugManager.StatusProc:
		print("Burn Proc, Dmg: ", current_burn_damage, ", Enemy: ", enemy_name)
	return attack
func proc_frost() -> Attack:
	if particles:
		particles.toggle_frost(true)
	applied_frost = floor(frost / frost_threshhold)
	movespeed_frozen_time_left += Statics.enemy_frost_frozen_duration
	frost_movespeed_reduction = get_frost_movespeed_reduction()
	## Do the math
	var current_frost_damage: float = get_frost_damage()
	var attack: Attack = make_status_attack(current_frost_damage, StatusEffects.StatusTypes.frost)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.FrostDamage.emit(current_frost_damage, self)
	applied_frost += 1
	curr_health -= current_frost_damage
	## Do the display dmg
	display_damage(current_frost_damage, Color.LIGHT_CYAN, false)
	## Raise the threshold
	frost_threshhold *= Statics.enemy_frost_threshold_multiplier
	if DebugManager.StatusProc:
		print("Frost Proc, Dmg: ", current_frost_damage, ", Slow: ", frost_movespeed_reduction, ", Enemy: ", enemy_name)
	return attack
func proc_poison() -> Attack:
	if particles:
		particles.toggle_poison(true)
	## Do the math
	var current_poison_damage: float = get_poison_damage()
	var attack: Attack = make_status_attack(current_poison_damage, StatusEffects.StatusTypes.poison)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.PoisonDamage.emit(current_poison_damage, self)
	applied_poison += 1
	curr_health -= current_poison_damage
	## Do the display dmg
	display_damage(current_poison_damage, Color.GREEN, false)
	if DebugManager.StatusProc:
		print("Poison Proc, Dmg: ", current_poison_damage, ", Enemy: ", enemy_name)
	return attack
func proc_bleed() -> Attack:
	if particles:
		particles.toggle_bleed(true)
	## Do the math
	# does x percent of health each bleed proc
	var current_bleed_damage: float = get_bleed_damage()
	var attack: Attack = make_status_attack(current_bleed_damage, StatusEffects.StatusTypes.bleed)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BleedDamage.emit(current_bleed_damage, self)
	applied_bleed += 1
	curr_health -= current_bleed_damage
	## Do the display dmg
	display_damage(current_bleed_damage, Color.ORANGE_RED, false)
	## Raise bleed threshold
	bleed_threshhold *= Statics.enemy_bleed_threshold_multiplier
	if DebugManager.StatusProc:
		print("Bleed Proc, Dmg: ", current_bleed_damage, ", Enemy: ", enemy_name)
	return attack
func proc_shock():
	if particles:
		particles.toggle_shock(true)
	applied_shock = floor(shock / shock_threshhold)
	shock_defense_reduction = get_shock_defense_reduction()
	if DebugManager.StatusProc:
		print("Shock Proc, Defense Reduction: ", shock_defense_reduction, ", Enemy: ", enemy_name)
func proc_wet():
	if particles:
		particles.toggle_wet(true)
	applied_wet = floor(wet / wet_threshhold)
	if DebugManager.StatusProc:
		print("Wet Proc, Applied Wet: ", applied_wet, ", Enemy: ", enemy_name)

func get_movespeed() -> float:
	## Include Frost
	var movespeed = curr_movespeed + frost_movespeed_reduction
	if slowed:
		## Include Slow (can't be lower than 0)
		return max(0, movespeed - slow_strength)
	return movespeed
func get_burn_damage() -> float:
	return get_damage_reduced_value((GlobalStats.get_stat(GlobalStats.BURN_DAMAGE) + Statics.burn_buff_base) * Statics.burn_buff_factor)
func get_frost_movespeed_reduction() -> float:
	## -base * number of times threshold has been reached / 3
	return -Statics.enemy_frost_movespeed_reduction * (frost / frost_threshhold) / 3
func get_frost_damage() -> float:
	return get_damage_reduced_value(curr_health * (GlobalStats.get_stat(GlobalStats.FROST_DAMAGE) / 100))
func get_shock_defense_reduction() -> float:
	## base * number of times threshold has been reached
	return (shock / shock_threshhold) * Statics.enemy_shock_defense_reduction
func get_bleed_damage() -> float:
	var value: float = base_health * (GlobalStats.get_stat(GlobalStats.BLEED_DAMAGE) / 100)
	if Statics.bleeds_crit_on_enemy > 0:
		value *= Statics.global_crit_damage_factor
	return get_damage_reduced_value(value)
func get_poison_damage() -> float:
	# 1/4 of max health for each time above threshold
	var mulitplier: float = floor(poison / poison_threshhold)
	return get_damage_reduced_value(base_health * GlobalStats.get_stat(GlobalStats.POISON_DAMAGE) * mulitplier)
func get_shock_damage() -> float:
	## Don't calculate in damage reduction as that is done in damage()
	return GlobalStats.get_stat(GlobalStats.SHOCK_DAMAGE)
func get_wet_damage() -> float:
	## Don't calculate in damage reduction as that is done in damage()
	return GlobalStats.get_stat(GlobalStats.WET_DAMAGE)
func get_damage_reduced_value(value: float) -> float:
	return (value - (curr_damage_reduction + shock_defense_reduction)) * percent_damage_taken
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
	var attack: Attack = Attack.new(Attack.AttackSources.status, Attack.AttackTypes.status, null, global_position, status_effects, null, null)
	attack.simple_setup(status_damage, 0)
	return attack

func shoot_projectile(target: Node2D) -> void:
	var proj: EnemyProjectile = projectile.instantiate()
	proj.setup_enemy(self, target, (target.global_position - global_position).normalized(), false, 0)
	proj.setup_can_attacks(can_attack_enemies, can_attack_events, can_attack_player, can_attack_creations)
	GameManager.instance.projectile_parent.add_child(proj)
	#proj.modulate = self.modulate
	proj.global_position = global_position
	proj.rotation = rotation
	print(proj.global_position)

var playing_die: bool = false
func die():
	if !playing_die:
		playing_die = true
		dead = true
		stop_movement()
		if play_animation_on_death != NO_ANIMATION_NAME:
			dead = is_dead_during_animation
			await play_animation(play_animation_on_death)
			dead = true
		if sound_on_death:
			AudioManager.instance.play(sound_on_death, global_position)
		if spawn_on_death:
			var spawn = spawn_on_death.instantiate()
			GameManager.instance.enemy_parent.add_child(spawn)
			spawn.global_position = global_position
		var game_man: GameManager = GameManager.instance
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
func play_animation(animation: String):
	anim.play(animation)
	return await anim.animation_finished
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
func display_damage(damage_value: float, color: Color, crit: bool):
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	var text: String = str(int(round(damage_value)))
	if crit:
		text += "!"
	var size: float = damage_value + randi_range(-5, 5)
	var location: Vector2 = WindowManager.instance.convert_small_position(global_position)
	var lifetime: float = 1.5
	var random_location_range: Vector2 = Vector2(10, 10)
	if color == Color.TRANSPARENT:
		dmg_text.setup(text, size, location, lifetime, random_location_range)
	else:
		dmg_text.setup_color(text, size, location, lifetime, random_location_range, color)
func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if !ImReady || dead || hitbox_disabled:
		return
	## Get the Damageable Object
	if "damageable_object" in body:
		body = body.damageable_object
	## Attempt to attack
	if can_attack(body):
		attack_body(body)
		## Handles self knockback on attack player
		if self_knockback_onhit != 0:
			apply_knockback(body.global_position, self_knockback_onhit)
		if die_after_attack_count != -1:
			attack_count += 1
			if attack_count >= die_after_attack_count:
				die()
func attack_body(target: Node2D):
	var damage_percent: float = 1
	## Deal less damage to fellow enemies
	if target.is_in_group("Enemy"):
		damage_percent *= friendly_fire_damage_reduction
	var attack: Attack = make_attack(damage_percent)
	target.damage(attack)
	## Melee Stuff
	cooldown_stopwatch = 0;
	damage_hitbox.set_deferred("monitoring", false)
func make_attack(damage_percent: float) -> Attack:
	## Make Two Stats Lists
	var base: GlobalStats.StatsList = GlobalStats.get_statslist_base()
	var factor: GlobalStats.StatsList = GlobalStats.get_statslist_factor()
	## Add Self's Base Stats to Base StatList
	add_to_stats_list(base)
	factor.add_to_stat(GlobalStats.DAMAGE, damage_percent - 1) # -1 to make it a multiplier
	var attack: Attack = Attack.new(Attack.AttackSources.enemy, Attack.AttackTypes.melee, self, global_position, status, base, factor)
	return attack
func move_towards(new_position: Vector2, movespeed: float, _delta:float):
	var direction: Vector2 = (new_position - global_position).normalized()
	if can_be_frozen && frozen:
		movespeed = 0
	linear_velocity = linear_velocity.move_toward(Vector2(direction.x * movespeed, direction.y * movespeed), movespeed_delta_modifier)
	
	## Don't change direction for 1 second after knockback
	if anim && time_since_knockedback > 1:
		## Either towards player
		if turns_towards_player:
			anim.flip_h = player.global_position.x > global_position.x
		## Or towards movement (or neither)
		else:
			var new_facing_left: bool = linear_velocity.x < 0
			if turns_towards_movement:
				if facing_left != new_facing_left:
					facing_left = new_facing_left
					anim.flip_h = !facing_left
			if rotate_towards_movement:
				var target: float 
				if facing_left:
					target = linear_velocity.angle() + deg_to_rad(180) + deg_to_rad(rotation_offset)
				else:
					target = linear_velocity.angle() - deg_to_rad(rotation_offset)
				## Do we rotate at a speed or instant
				if rotation_speed < 0:
					global_rotation = target
				else:
					var angle_diff = angle_difference(global_rotation, target)
					global_rotation += clampf(angle_diff, -_delta * rotation_speed, _delta * rotation_speed)

func is_player_nearby(distance: float) -> bool:
	if global_position.distance_to(player.global_position) <= distance:
		return true
	return false
## Pass an attack to damage the enemy, returns if the attack killed the enemy
func damage(attack: Attack) -> bool:
	if GameInstance.is_game_over || !ImReady:
		return false
	## Pass attack through upgrades
	attack = GameManager.instance.handle_attack_enemy(attack, self)
	## Apply Status Effect Changes (doesn't apply status effect effects yet)
	burn += attack.get_burn()
	frost += attack.get_frost()
	poison += attack.get_poison()
	bleed += attack.get_bleed()
	shock += attack.get_shock()
	wet += attack.get_wet()
	
	## Flat Damage Reduction, can be negative (take bonus damage)
	## Calculate Damag
	var attack_true_damage: float = attack.get_damage()
	var shock_true_damage: float = 0
	var wet_true_damage: float = 0
	## Apply Crit
	var is_crit: bool = attack.get_crit()
	if is_crit:
		pass
	## Shock
	if attack.status.applies_shock:
		shock_true_damage = get_shock_damage()
	## Wet
	if attack.status.applies_wet:
		wet_true_damage = get_wet_damage()
	var pre_reduction_damage: float = attack_true_damage + wet_true_damage + shock_true_damage
	## Calculate the percents that each damage type are of total attack
	var wet_percent: float = wet_true_damage / pre_reduction_damage
	var shock_percent: float = shock_true_damage / pre_reduction_damage
	var attack_percent: float = attack_true_damage / pre_reduction_damage
	## Sum all attack damage values (Include flat and percent damage reductions)
	var total_damage: float = get_damage_reduced_value(attack_true_damage + wet_true_damage + shock_true_damage)
	if total_damage > 0:
		GameManager.instance.EnemyDamaged.emit(self, attack)
		curr_health -= total_damage
	## Calculate real damages
	var wet_damage: float = wet_percent * total_damage
	var shock_damage: float = shock_percent * total_damage
	var attack_damage: float = attack_percent * total_damage
	if DebugManager.StatusApplied:
		if attack.status.applies_burn && attack.get_burn() > 0:
			print("Add Burn: ", attack.get_burn(), " Applied: ", attack.status.applies_burn)
		if attack.status.applies_frost && attack.get_frost() > 0:
			print("Add Frost: ", attack.get_frost(), " Applied: ", attack.status.applies_frost)
		if attack.status.applies_poison && attack.get_poison() > 0:
			print("Add Poison: ", attack.get_poison(), " Applied: ", attack.status.applies_poison)
		if attack.status.applies_bleed && attack.get_bleed() > 0:
			print("Add Bleed: ", attack.get_bleed(), " Applied: ", attack.status.applies_bleed)
		if attack.status.applies_shock && attack.get_shock() > 0:
			print("Add Shock: ", attack.get_shock(), " Applied: ", attack.status.applies_shock)
		if attack.status.applies_wet && attack.get_wet() > 0:
			print("Add Wet: ", attack.get_wet(), " Applied: ", attack.status.applies_wet)
	## Apply Stun and Knockback and Slow
	if attack.get_slow_duration() > 0 && can_be_slowed:
		slow_time_left = attack.get_slow_duration()
		slow_strength = attack.get_slow_strength()
		slowed = true
	if attack.get_stun_duration() > 0 && can_be_stunned:
			stun_time_left = attack.get_stun_duration()
			stunned = true
			linear_velocity = Vector2.ZERO
	if can_move && can_be_knockbacked && attack.get_knockback() != 0:
		stun_time_left = stun_on_knockback ## TODO: stun?
		stunned = true
		apply_knockback(attack.position, attack.get_knockback())
	if attack_damage > 0:
		display_damage(attack_damage, attack.attack_color, attack.get_crit())
	if shock_damage > 0:
		display_damage(shock_damage, Color.GOLD, attack.get_crit())
	if wet_damage > 0:
		display_damage(wet_damage, Color.BLUE, attack.get_crit())
	## Die.
	return check_death(attack)

func death_signal(attack: Attack):
	GameManager.instance.EnemyKilled.emit(self, attack)
func apply_knockback(attack_pos: Vector2, knockback: float):
	time_since_knockedback = 0
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
## Returns if this can attack the node
func can_attack(body: Node2D) -> bool:
	var ret: bool = true
	## Damagable bodies have this variable and function pair, and have can_be_damaged == true
	if !"can_be_damaged" in body || !body.has_method("damage") || ("can_be_damaged" in body && !body.get("can_be_damaged")):
		ret = false
	## if enemy, only attack if can attack enemies
	if body.is_in_group("enemy") && !can_attack_enemies:
		ret = false
	## if player, only attack if can attack player
	if body.is_in_group("player") && !can_attack_player:
		ret = false
	## if creation, only attack if can attack creations
	if body.is_in_group("creation") && !can_attack_creations:
		ret = false
	## if event, only attack if can attack events
	if body.is_in_group("event") && !can_attack_events:
		ret = false
	return ret
## Makes a StatsList based on the Enemy Stats
func add_to_stats_list(list: GlobalStats.StatsList):
	list.add_to_stat(GlobalStats.DAMAGE, curr_damage)
	list.add_to_stat(GlobalStats.HP, curr_health)
	list.add_to_stat(GlobalStats.MOVESPEED, curr_movespeed)
	list.add_to_stat(GlobalStats.REGEN, curr_regen)
	list.add_to_stat(GlobalStats.STANCE, curr_damage_reduction)
	list.add_to_stat(GlobalStats.ATTACKCOOLDOWN, curr_cooldown_max)
	list.add_to_stat(GlobalStats.RANGE, curr_range)
	list.add_to_stat(GlobalStats.VELOCITY, curr_speed)
	list.add_to_stat(GlobalStats.DURATION, curr_lifetime)
	list.add_to_stat(GlobalStats.PIERCING, curr_piercing)
	list.add_to_stat(GlobalStats.LUCK, curr_critchance)
	list.add_to_stat(GlobalStats.CRITDAMAGE, curr_critdamage)
