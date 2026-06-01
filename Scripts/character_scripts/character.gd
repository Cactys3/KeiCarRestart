extends CharacterBody2D
class_name Character

const POPUP_TEXT = preload("uid://brldrnbhcexcm")
var game_man: GameManager:
	get():
		return GameManager.instance
@export var character_name: String = "Character"
@export var pickup_range: CollisionShape2D
@export var anim: AnimatedSprite2D
@export var face_towards_velocity: bool = true
@export var knockback_modifier: float = 1
@export var can_be_knockbacked: bool = true
@export var can_be_stunned: bool = true
## Stats
@export var movespeed: float = 30:
	get():
		return movespeed + GlobalStats.get_stat(GlobalStats.MOVESPEED)
## Max Health for the player
@export var health: float = 100:
	get():
		return health + GlobalStats.get_stat(GlobalStats.HP)
	set(value):
		health = value
		GameManager.instance.ui_man.set_max_hp(value)
@export var shield: float = 20:
	get():
		return shield + GlobalStats.get_stat(GlobalStats.SHIELD)
	set(value):
		shield = value
		GameManager.instance.ui_man.set_max_shield(value)
@export var stance: float = 0:
	get():
		return stance + GlobalStats.get_stat(GlobalStats.STANCE)
@export var size: float = 1:
	get():
		return size + GlobalStats.get_stat(GlobalStats.SIZE)
@export var xp_gain: float = 1:
	get():
		return xp_gain + GlobalStats.get_stat(GlobalStats.XP)
@export var mogul: float = 1:
	get():
		return mogul + GlobalStats.get_stat(GlobalStats.MOGUL)
@export var regen: float = 3:
	get():
		return regen + GlobalStats.get_stat(GlobalStats.REGEN)
@export var lifesteal: float = 0:
	get():
		return lifesteal + GlobalStats.get_stat(GlobalStats.LIFESTEAL)
@export var thorns: float = 0:
	get():
		return thorns + GlobalStats.get_stat(GlobalStats.THORNS)
@export var revives: float = 0:
	get():
		return revives + GlobalStats.get_stat(GlobalStats.REVIES)
## Variables
var can_be_damaged: bool = true
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
## Current Stats
var curr_speed: float
func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
func initialize_stats() -> void:
	curr_speed = movespeed
func _process(_delta: float) -> void:
	if GameInstance.is_game_over:
		return
	if Input.is_action_just_pressed(InputManager.ABILITY_1):
		character_ability(1)
	if Input.is_action_just_pressed(InputManager.ABILITY_2):
		character_ability(2)
	if Input.is_action_just_pressed(InputManager.ABILITY_3):
		character_ability(3)
func _physics_process(delta : float) -> void:
	if GameInstance.is_game_over:
		print("game over")
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
func handle_regens(delta) -> void:
	## Regen shield if hasn't taken damage in awhile
	if time_since_taken_damage >= shield_cooldown && game_man.shield < shield:
		game_man.shield += 5 * delta
	## Regen happens once every second
	regen_stopwatch += delta
	if regen_stopwatch >= regen_cooldown:
		regen_stopwatch = 0
		if regen > 0 && game_man.curr_hp < health:
			game_man.curr_hp += GlobalStats.calculate_regen(regen)
func handle_moving(delta) -> void:
	var is_moving = false
	var directionX := Input.get_axis(InputManager.LEFT, InputManager.RIGHT)
	if !stunning: ## Stun Time prevents the player from inputting movement commands, but doesn't change their current velocity
		var new_velocity: Vector2
		if directionX:
			new_velocity.x = round(directionX) * curr_speed
			is_moving = true
		else:
			new_velocity.x = 0
		var directionY := Input.get_axis(InputManager.UP, InputManager.DOWN)
		if directionY:
			new_velocity.y = round(directionY) * curr_speed
			is_moving = true
		else:
			new_velocity.y = 0
		velocity = velocity.move_toward(new_velocity.normalized() * curr_speed, delta * movespeed_delta_modifier)
	moving(is_moving)
	if is_moving && face_towards_velocity:
		## if velocity.x = 0, don't change
		if (sign(velocity.x) > 0):
			anim.flip_h = true
		if (sign(velocity.x) < 0):
			anim.flip_h = false
func damage(attack: Attack):
	if GameInstance.is_game_over:
		return
	## Consider Stance
	var net_damage = attack.get_damage() - stance
	if GlobalStats.calculate_avoid_damage(GlobalStats.get_stat(GlobalStats.GHOSTLY)):
		net_damage = 0
		print("PLAYER AVOIDED DAMAGE")
	if net_damage > 0:
		game_man.PlayerDamaged.emit(self, attack)
		time_since_taken_damage = 0
	## Consider Sheild
	if net_damage > 0 && game_man.shield > 0:
		if (game_man.shield > net_damage):
			game_man.shield -= net_damage
			net_damage = 0
		else:
			net_damage -= game_man.shield
			game_man.shield = 0
	## Consider HP
	if net_damage > 0:
		game_man.curr_hp -= net_damage
	## Stun currently prevents the player from inputting movements, this means that the currently velocity (including knockback) will apply fully for the duration of the stun
	if can_be_stunned && attack.stun != 0:
		stun_time_left += attack.get_stun()
		stunning = true
	## Knockback is applied fully for 1 frame as the player's own movement code then overwrites it quickly on the following frames.
	if can_be_knockbacked && attack.get_knockback() != 0:
		print("knockback: ", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier, " vs velocity: ", velocity)
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier)
	if game_man.curr_hp <= 0:
		die(attack)
	## This shit doesn't work for some fucked up reason when it's preloaded
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup_color(str(int(round(attack.get_damage()))), net_damage + 36, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), Color.RED)
## Handles Revives and Events on player death
func die(attack: Attack):
	if !GameInstance.is_game_over:
		if game_man.can_revive():
			game_man.use_revive()
			game_man.PlayerRevived.emit(self)
		else:
			game_man.PlayerKilled.emit(self, attack)
			GameInstance.instance.lose()
## func reapplies all affects that stats have based on newly checked values
func stat_changed_method():
	# hp, size, xp gain, money gain, magentize etc
	pickup_range.shape.radius = default_pickup_radius + GlobalStats.get_stat(GlobalStats.MAGNETIZE)
	transform.scaled(Vector2(size, size))
	game_man.curr_hp = game_man.curr_hp ## checks maxhp to setup UI properly
	game_man.shield = game_man.shield ## checks maxshield to setup UI properly
func character_ability(number: int) -> void:
	pass#print("ability " + str(number))
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
