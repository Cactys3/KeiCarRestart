extends SpawnObject
class_name Creation

enum MovementTypes{GivenDirection, NonMoving, NearestEnemy, RandomEnemy, RandomDirection}
@export var movement_type: MovementTypes = MovementTypes.NonMoving
@export var angular_velocity: float = 0.5
@export var acceleration: float = 0
## Does this creation damage enemies on collision
@export var damage_on_collision: bool = true
## 0 for no knockback
@export var self_knockback_onhit: float = 0
@export var can_be_damaged: bool = true
var damageable_object: Node2D = self
@export var can_be_stunned: bool = true
@export var can_be_knockedback: bool = true
## Flat Damage Reduction
@export var knockback_modifier: float = 1
@export var max_knockback_time: float = 0.15
## Only recieve half velocity as creations should move slower than projectiles, but numbers on buffs can be same
const creation_velocity_modifier: float = 0.5
var hp: float = 1000
var velocity: float = 0.5
var temporary_velocity: float = 0
var creation_range: float:
	get():
		return range_stat + Statics.creation_range_buff
var stun_time_left: float = 0
var stunning: bool = false
var applying_knockback: bool = false
var knockback_stopwatch: float = 0

var direction: Vector2 = Vector2(0, 0)
var knockback_direction := Vector2(0, 0)
var knockback_strength := 0.0
var creation_duration: float = 0
var duration_stopwatch: float = 0
var parent: CreationUpgrade
var source: Attack.AttackSources = Attack.AttackSources.unset
var is_ready: bool = false
var switch_targets_stopwatch: float = 3
## Can swap targets MAX once every 2 seconds (unless target dies)
var switch_targets_cooldown: float = 2
var update_target_stopwatch: float = 10
var update_target: bool = true
## Update once a second
var update_target_cooldown: float = 0.5
var target: Node2D 
var set_random_direction: bool = false
var clockwise: float = -1
func _ready() -> void:
	super()
	if randf() > 0.5:
		clockwise = 1
func setup(new_parent: Equipment, attack_source: Attack.AttackSources):
	## Setup main variables
	parent = new_parent
	source = attack_source
	## Handle stats after setup
	velocity = velocity_stat * creation_velocity_modifier
	temporary_velocity = velocity
	hp = hp_stat
	creation_duration = 2 + duration_stat
	is_ready = true
	setup_collisions(true, false)
func set_direction(new_direction: Vector2):
	direction = new_direction
func _process(delta: float) -> void:
	## Stun
	if stun_time_left > 0:
		stun_time_left -= delta
		stunning = true
		## Knockback
		if applying_knockback && knockback_stopwatch <= max_knockback_time:
			knockback_stopwatch += delta
			## Apply knockback
			position += knockback_direction * knockback_strength * delta
			## Lose 10% knockback speed a second
			knockback_direction -= knockback_direction * 0.1 * delta
	elif stunning || applying_knockback:
		stunning = false
		applying_knockback = false
	## Normal Movement
	if !stunning:
		if update_target:
			switch_targets_stopwatch += delta
			update_target_stopwatch += delta
			## If both cooldowns are reached or there is no target (or have attacked target) and update cd is reached, then update
			if (update_target_stopwatch >= update_target_cooldown) && (switch_targets_stopwatch >= switch_targets_cooldown || (!target || have_attacked(target))):
				update_target_stopwatch = 0
				switch_targets_stopwatch = 0
				get_new_target()
		match movement_type:
			MovementTypes.GivenDirection:
				ProcessDirection(delta)
			MovementTypes.NearestEnemy:
				ProcessTarget(delta)
			MovementTypes.RandomEnemy:
				ProcessTarget(delta)
			MovementTypes.RandomDirection:
				if !set_random_direction:
					direction = (Vector2(randf_range(-1, 1), randf_range(-1, 1)))
				ProcessDirection(delta)
			MovementTypes.NonMoving:
				pass
		## Apply movement here?
		velocity += velocity * acceleration * delta
		temporary_velocity = move_toward(temporary_velocity, velocity, delta * 10)
		position += direction.normalized() * temporary_velocity * delta
	duration_stopwatch += delta
	if duration_stopwatch > creation_duration:
		die()
func get_new_target():
	match movement_type:
		MovementTypes.NearestEnemy:
			target = get_enemy_nearby_except_attacked(creation_range)
		MovementTypes.RandomEnemy:
			target = get_random_enemy_in_range_except_attacked(creation_range)
func die():
	parent.active_creations.erase(self)
	queue_free()
func damage(attack: Attack) -> Enemy.DamageReturn:
	if GameInstance.is_game_over || !can_be_damaged:
		return null
	## Consider Stance
	var net_damage = attack.get_damage() - stance_stat
	if GlobalStats.calculate_avoid_damage(Statics.creation_dodge_buff):
		net_damage = 0
		game_man.CreationDodged.emit(self, attack)
	if net_damage > 0:
		game_man.CreationDamaged.emit(self, attack)
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
		game_man.damage_player(net_damage)
	## Stun currently prevents the player from inputting movements, this means that the currently velocity (including knockback) will apply fully for the duration of the stun
	if can_be_stunned && attack.stun_duration != 0:
		stun_time_left += attack.get_stun()
		stunning = true
	## Knockback is applied fully for 1 frame as the player's own movement code then overwrites it quickly on the following frames.
	if can_be_knockedback && attack.get_knockback() != 0:
		apply_knockback(attack.get_knockback() * knockback_modifier, attack.position)
	var died: bool = false
	if game_man.curr_hp <= 0:
		game_man.CreationKilled.emit(self, attack)
		die()
		died = true
	## This shit doesn't work for some fucked up reason when it's preloaded
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup_color(str(int(round(attack.get_damage()))), net_damage + 36, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), Color.RED)
	return Enemy.DamageReturn.new(died, net_damage, net_damage, 0, 0)
func ProcessDirection(delta: float):
	## Setup
	direction = direction.normalized() 
	## Move
	#position += direction * velocity * delta
func ProcessTarget(delta: float):
	## Setup
	var target_direction: Vector2 = direction.normalized() 
	direction = direction.normalized() 
	## Move
	if target:
		target_direction = lerp(direction, target.global_position - global_position, delta * angular_velocity)
	else:
		## Don't lerp if oribiting player
		target_direction = (game_man.player.global_position - global_position).rotated(PI / 2 * clockwise)
	direction = target_direction
	#position += direction * velocity * delta
var damage_multiplier: float = 1
func _on_body_entered(body: Node2D) -> void:
	super(body)
## Use this for projectiles?? idk
func get_can_attack_callable() -> Callable:
	return can_attack
	#return func(body: Node2D) -> bool:
		#return !body.is_in_group("player") && "can_be_damaged" in body && body.get("can_be_damaged") && body.has_method("damage")
func attack_body(body: Node2D):
	append_attack_element(body)
	attack_counter += 1
	body.damage(make_attack(damage_multiplier))
	if self_knockback_onhit > 0 && can_be_knockedback:
		apply_knockback(self_knockback_onhit * knockback_modifier, body.global_position)
	if target == body:
		var old_target = target
		get_new_target()
	if attack_counter > piercing_stat && can_die_from_collision:
		die()
func post_damage_return(damage_return: Enemy.DamageReturn):
	if lifesteal_stat > 0:
		heal_creation((lifesteal_stat / 100) * damage_return.attack_damage_dealt)
	super(damage_return)
func heal_creation(heal: float):
	hp += min(hp_stat, heal)
func apply_knockback(knockback: float, location: Vector2):
	## Max 0.5 seconds of knockback
	stun_time_left += min(0.1 + knockback / 100, max_knockback_time)
	knockback_stopwatch = 0
	applying_knockback = true
	stunning = true
	knockback_strength = knockback
	knockback_direction = (global_position - location).normalized()
	## decreased ms until it builds back up
	temporary_velocity = temporary_velocity * 0.2
	direction = knockback_direction
## Edit attack after making
func handle_attack(attack: Attack):
	## Set Color
	attack.set_attack_color(attack_color)
	## TODO: i want to set impact location if it's a melee attack
	attack.impact_location = global_position
	super(attack)
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.creation
func get_attack_source() -> Attack.AttackSources:
	return source
## Set Creation layer true
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(10, true)
	super(is_player_weapons, is_enemy_weapons)
