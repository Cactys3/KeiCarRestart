extends CharacterBody2D
class_name Character

const POPUP_TEXT = preload("uid://brldrnbhcexcm")
var game_man: GameManager:
	get():
		return GameManager.instance
var data: CharacterData
@export var character_name: String = "Character"
@export var pickup_range: CollisionShape2D
@export var anim: AnimatedSprite2D
@export var face_towards_velocity: bool = true
@export var can_be_knockbacked: bool = true
@export var can_be_stunned: bool = true
## Stats
const default_movespeed: float = 30
@export var knockback_modifier_base: float = 1.5
@export var movespeed_base: float = default_movespeed
@export var health_base: float = 100
@export var shield_base: float = 0
@export var stance_base: float = 0
@export var size_base: float = 1
@export var xp_gain_base: float = 1
@export var mogul_base: float = 1
@export var regen_base: float = 3
@export var lifesteal_base: float = 0
@export var revives_base: float = 0
@export var thorns_base: float = 0
@export var ghostly_base: float = 0
@export var luck_base: float = 0
@export var magnetize_base: float = 0
var knockback_modifier: float = knockback_modifier_base
var movespeed: float = default_movespeed:
	get():
		return (movespeed + Statics.player_movespeed_buff)
var max_health: float = health_base:
	set(value):
		var old_maxhealth: float = max_health
		max_health = value
		var difference: float = max_health - old_maxhealth
		## If adding max hp, add health
		if difference > 0:
			game_man.curr_hp = game_man.curr_hp + difference
		GameManager.instance.ui_man.set_max_hp(max_health)
		## Emit Signal on actual max health change
		if max_health != old_maxhealth:
			game_man.PlayerMaxHealthChange.emit(max_health, old_maxhealth)
var max_shield: float = shield_base:
	set(value):
		var old_maxshield: float = max_shield
		max_shield = value
		var difference: float = max_shield - old_maxshield
		## If adding max shield, add shield
		if max_shield != old_maxshield:
			pass
		if difference > 0:
			game_man.curr_shield = game_man.curr_shield + difference
		GameManager.instance.ui_man.set_max_shield(max_shield)
		## Emit Signal on actual shield change
		if max_shield > old_maxshield:
			game_man.PlayerShieldChanged.emit(max_shield, old_maxshield)
var stance: float = 0:
	get():
		return stance + GlobalStats.get_stat(GlobalStats.STANCE)
var size: float = 1:
	get():
		return (size + Statics.player_size_buff)
var xp_gain: float = 1:
	get():
		return xp_gain + GlobalStats.get_stat(GlobalStats.XP)
var mogul: float = 1:
	get():
		return mogul + GlobalStats.get_stat(GlobalStats.MOGUL)
var regen: float = 0:
	get():
		return regen + GlobalStats.get_stat(GlobalStats.REGEN)
var lifesteal: float = 0:
	get():
		return lifesteal + GlobalStats.get_stat(GlobalStats.LIFESTEAL)
var thorns: float = 0:
	get():
		return thorns + GlobalStats.get_stat(GlobalStats.THORNS)
var revives: float = 0:
	get():
		return revives + GlobalStats.get_stat(GlobalStats.REVIES)
var luck: float = 0:
	get():
		return luck + GlobalStats.get_stat(GlobalStats.LUCK)
var ghostly: float = 0:
	get():
		return ghostly + GlobalStats.get_stat(GlobalStats.GHOSTLY)
var magnetize: float = 0:
	get():
		return magnetize + GlobalStats.get_stat(GlobalStats.MAGNETIZE)
func stats_changed():
	## Set Max Stat Values
	max_health = (health_base + Statics.player_hp_buff + GlobalStats.get_base_stat(GlobalStats.HP)) * GlobalStats.get_factor_stat(GlobalStats.HP)
	movespeed = (movespeed_base + Statics.player_movespeed_buff + GlobalStats.get_base_stat(GlobalStats.MOVESPEED)) * GlobalStats.get_factor_stat(GlobalStats.MOVESPEED)
	max_shield = (shield_base + Statics.player_shield_buff + GlobalStats.get_base_stat(GlobalStats.SHIELD)) * GlobalStats.get_factor_stat(GlobalStats.SHIELD)
	stance = (stance_base + Statics.player_stance_buff + GlobalStats.get_base_stat(GlobalStats.STANCE)) * GlobalStats.get_factor_stat(GlobalStats.STANCE)
	size = (size_base + Statics.player_size_buff + GlobalStats.get_base_stat(GlobalStats.SIZE)) * GlobalStats.get_factor_stat(GlobalStats.SIZE)
	xp_gain = (xp_gain_base + Statics.player_xp_gain_buff + GlobalStats.get_base_stat(GlobalStats.XP)) * GlobalStats.get_factor_stat(GlobalStats.XP)
	mogul = (mogul_base + Statics.player_mogul_buff + GlobalStats.get_base_stat(GlobalStats.MOGUL)) * GlobalStats.get_factor_stat(GlobalStats.MOGUL)
	regen = (regen_base + Statics.player_regen_buff + GlobalStats.get_base_stat(GlobalStats.REGEN)) * GlobalStats.get_factor_stat(GlobalStats.REGEN)
	lifesteal = (lifesteal_base + Statics.player_lifesteal_buff + GlobalStats.get_base_stat(GlobalStats.LIFESTEAL)) * GlobalStats.get_factor_stat(GlobalStats.LIFESTEAL)
	thorns = (thorns_base + Statics.player_thorns_buff + GlobalStats.get_base_stat(GlobalStats.THORNS)) * GlobalStats.get_factor_stat(GlobalStats.THORNS)
	revives = (revives_base + Statics.player_revives_buff + GlobalStats.get_base_stat(GlobalStats.REVIES)) * GlobalStats.get_factor_stat(GlobalStats.REVIES)
	
	## Change Current Values
	pickup_range.shape.radius = (default_pickup_radius + Statics.player_magnetize_buff)
	global_scale = Vector2(size, size)
	knockback_modifier = knockback_modifier_base + Statics.player_knockback_resistance_buff

## Variables
var can_be_damaged: bool = true
var damageable_object: Node2D = self
var default_pickup_radius: float = 30
var regen_stopwatch: float = 0
## Regen every x seconds
var regen_cooldown: float = 4
var time_since_taken_damage: float = 0
var shield_cooldown: float = 3
## Constants
const movespeed_delta_modifier: float = 700 # 700 feels like a good place (affects knockback)
## States
var stunning:bool = false
var stun_time_left: float = 0
## Last Known velocity (used to check where player is facing when at rest)
var last_known_velocity: Vector2 = Vector2(0, 0)
var has_ability1: bool = false
var has_ability2: bool = false
var has_ability3: bool = false
var Ability1: Ability = null
var Ability2: Ability = null
var Ability3: Ability = null

func _draw() -> void:
	if DebugManager.PlayerDistanceRadius:
		for r in DebugManager.PlayerDistances:
			## Draw circle range
			draw_arc(Vector2.ZERO, r, 0, TAU, 64, Color.RED.lerp(Color.TRANSPARENT, 0.7), 1)
			## Draw label
			if r >= 10.0:
				var font := ThemeDB.fallback_font
				var font_size := 16
				var label := str(int(r))
				var text_width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
				draw_string(
					font,
					Vector2(-text_width / 2.0, -r - 2),
					label,
					HORIZONTAL_ALIGNMENT_LEFT,
					-1,
					font_size,
					Color.RED.lerp(Color.TRANSPARENT, 0.5))

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1, false).timeout
	visible = true
## Set Character's Abilities
func set_abilities(ability1_data: AbilityData, ability2_data: AbilityData, ability3_data: AbilityData):
	if ability1_data:
		has_ability1 = true
		Ability1 = ability1_data.ability_scene.instantiate()
		## Give data manually so we can call setup later when the scene is created
		Ability1.data = ability1_data
	if ability2_data:
		has_ability2 = true
		Ability2 = ability2_data.ability_scene.instantiate()
		Ability2.data = ability2_data
	if ability3_data:
		has_ability3 = true
		Ability3 = ability3_data.ability_scene.instantiate()
		Ability3.data = ability3_data
func setup():
	## Initialize Stats
	stats_changed()
	GameManager.instance.StatsChanged.connect(stats_changed)
	## Setup Abilities
	if has_ability1:
		Ability1.setup(self, 1)
	if has_ability2:
		Ability2.setup(self, 2)
	if has_ability3:
		Ability3.setup(self, 3)

func change_max_hp(change: float):
	max_health = max_health + change
func _process(_delta: float) -> void:
	if GameInstance.is_game_over:
		return
	if DebugManager.PlayerDistanceRadius:
		queue_redraw()
	if has_ability1 && Input.is_action_just_pressed(InputManager.ABILITY_1):
		Ability1.InputPressed()
	if has_ability2 && Input.is_action_just_pressed(InputManager.ABILITY_2):
		Ability2.InputPressed()
	if has_ability3 && Input.is_action_just_pressed(InputManager.ABILITY_3):
		Ability3.InputPressed()
func _physics_process(delta: float) -> void:
	if GameInstance.is_game_over:
		move_and_slide()
		return
	if stun_time_left > 0:
		stun_time_left -= delta
	else:
		stunning = false
	handle_moving(delta)
	var oldx = position.x
	var oldy = position.y
	move_and_slide()
	## Pixel-Perfect code, tries to align diagonal movement along pixel perfect lines instead of jagged ones
	if velocity:
		if abs(oldx - position.x) > abs(oldy - position.y) && velocity.x != 0: 
			var x = round(position.x)
			var y = round(position.y + (x - position.x) * velocity.y / velocity.x)
			position.y = y
		elif abs(oldx - position.x) <= abs(oldy - position.y) && velocity.y != 0:
			var y = round(position.y)
			var x = round(position.x + (y - position.y) * velocity.x / velocity.y)
			position.x = x
	handle_regens(delta)
	time_since_taken_damage += delta
	## Don't update last_known_velocity if player isn't moving anymore
	if velocity.length_squared() > 0.0:
		last_known_velocity = velocity
func handle_regens(delta: float) -> void:
	## Regen shield if hasn't taken damage in awhile
	if time_since_taken_damage >= shield_cooldown && game_man.curr_shield < max_shield:
		game_man.curr_shield += 5 * delta
	## Regen happens once every second
	regen_stopwatch += delta
	if regen_stopwatch >= regen_cooldown:
		regen_stopwatch = 0
		if regen > 0 && game_man.curr_hp < max_health:
			game_man.heal_player(GlobalStats.calculate_regen(regen), GameManager.HealTypes.regen)
func handle_moving(delta) -> void:
	var is_moving = false
	var directionX := Input.get_axis(InputManager.LEFT, InputManager.RIGHT)
	if !stunning: ## Stun Time prevents the player from inputting movement commands, but doesn't change their current velocity
		var new_velocity: Vector2
		if directionX:
			new_velocity.x = round(directionX) * movespeed
			is_moving = true
		else:
			new_velocity.x = 0
		var directionY := Input.get_axis(InputManager.UP, InputManager.DOWN)
		if directionY:
			new_velocity.y = round(directionY) * movespeed
			is_moving = true
		else:
			new_velocity.y = 0
		velocity = velocity.move_toward(new_velocity.normalized() * movespeed, delta * movespeed_delta_modifier)
	moving(is_moving)
	if is_moving && face_towards_velocity:
		## if velocity.x = 0, don't change
		if (sign(velocity.x) > 0):
			anim.flip_h = true
		if (sign(velocity.x) < 0):
			anim.flip_h = false
## Send an attack to damage the player, returns if the player died from this attack
func damage(attack: Attack) -> Enemy.DamageReturn:
	if GameInstance.is_game_over:
		return null
	## Pass attack through upgrades
	if attack.attacker is Enemy:
		attack = GameManager.instance.handle_incoming_attack(attack, attack.attacker, self)
	## Consider Stance
	var total_damage_taken: float = attack.get_damage() - stance
	var net_damage = total_damage_taken
	#print("Reduce Due To Stance: ", attack.get_damage(), " - ", stance, " net: ", net_damage)
	if GlobalStats.calculate_avoid_damage(GlobalStats.get_stat(GlobalStats.GHOSTLY)):
		net_damage = 0
	if net_damage > 0:
		game_man.PlayerDamaged.emit(self, attack)
		time_since_taken_damage = 0
	## Consider Sheild
	if net_damage > 0 && game_man.curr_shield > 0:
		## Emit shield damaged for upgrades
		game_man.PlayerShieldDamaged.emit(self, attack, min(net_damage, game_man.curr_shield))
		if (game_man.curr_shield > net_damage):
			game_man.curr_shield -= net_damage
			net_damage = 0
		else:
			net_damage -= game_man.curr_shield
			game_man.curr_shield = 0
	## Consider HP
	if net_damage > 0:
		game_man.damage_player(net_damage)
	## Stun currently prevents the player from inputting movements, this means that the currently velocity (including knockback) will apply fully for the duration of the stun
	if can_be_stunned && attack.get_stun_duration() != 0:
		stun_time_left += attack.get_stun_duration()
		stunning = true
	## Knockback is applied fully for 1 frame as the player's own movement code then overwrites it quickly on the following frames.
	if can_be_knockbacked && attack.get_knockback() != 0:
		#print("knockback: ", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier, " vs velocity: ", velocity)
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier)
	var died: bool = false
	if game_man.curr_hp <= 0:
		die(attack)
		died = true
	## This shit doesn't work for some fucked up reason when it's preloaded
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup_color(str(int(round(total_damage_taken))), total_damage_taken + 36, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), Color.RED)
	return Enemy.DamageReturn.new(died, total_damage_taken, total_damage_taken, 0, 0)
## Handles Revives and Events on player death
func die(attack: Attack):
	if !GameInstance.is_game_over:
		if game_man.can_revive():
			game_man.use_revive()
			game_man.PlayerRevived.emit(self)
		else:
			game_man.PlayerKilled.emit(self, attack)
			GameInstance.instance.lose()
func on_level_up(new_level: float, old_level: float) -> void:
	pass
func on_gain_xp(new_xp: float, old_xp: float) -> void:
	pass
func on_gain_money(new_money: float, old_money: float) -> void:
	pass
func moving(is_moving: bool):
	if is_moving && is_instance_valid(anim) && anim.sprite_frames.has_animation("move"):
		
		anim.play("move")
	elif anim.sprite_frames.has_animation("idle"):
		anim.play("idle")
