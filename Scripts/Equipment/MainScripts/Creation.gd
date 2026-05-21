extends SpawnObject
class_name Creation

enum MovementTypes{GivenDirection, NonMoving, NearestEnemy, RandomEnemy, RandomDirection}
@export var movement_type: MovementTypes = MovementTypes.NonMoving
@export var hp: float = 30
@export var velocity: float = 0.5
@export var angular_velocity: float = 0.5
@export var acceleration: float = 0
## Does this creation damage enemies on collision
@export var damage_on_collision: bool = true
@export var can_be_damaged: bool = true
@export var can_be_stunned: bool = true
@export var can_be_knockbacked: bool = true
## Flat Damage Reduction
@export var knockback_modifier: float = 0
var stun_time_left: float = 0
var stunning: bool = false
var direction: Vector2 = Vector2(0, 0)
var creation_duration: float = 0
var duration_stopwatch: float = 0
var parent: CreationUpgrade
var is_ready: bool = false
var switch_targets_stopwatch: float = 3
## Can swap targets MAX once every 2 seconds (unless target dies)
var switch_targets_cooldown: float = 2
var update_target_stopwatch: float = 10
var update_target: bool = true
## Update once a second
var update_target_cooldown: float = 1
var target: Node2D 
var set_random_direction: bool = false
var clockwise: float = -1
func _ready() -> void:
	super()
	if randf() > 0.5:
		clockwise = 1
func setup(new_parent: Equipment, new_duration: float):
	parent = new_parent
	creation_duration = new_duration
	is_ready = true
func set_direction(new_direction: Vector2):
	direction = new_direction
func _process(delta: float) -> void:
	if stun_time_left > 0:
		stun_time_left -= delta
		stunning = true
	elif stunning:
		stunning = false
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
		velocity += velocity * acceleration
		position += direction.normalized() * velocity
	duration_stopwatch += delta
	if duration_stopwatch > creation_duration:
		die()
func get_new_target():
	match movement_type:
		MovementTypes.NearestEnemy:
			target = get_enemy_nearby_except_attacked(get_detection_radius())
		MovementTypes.RandomEnemy:
			target = get_random_enemy_in_range_except_attacked(get_detection_radius())
func _on_area_entered(area: Area2D) -> void:
	pass
func die():
	parent.active_creations.erase(self)
	queue_free()
func damage(attack: Attack):
	if GameInstance.is_game_over || !can_be_damaged:
		return
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
		game_man.curr_hp -= net_damage
	## Stun currently prevents the player from inputting movements, this means that the currently velocity (including knockback) will apply fully for the duration of the stun
	if can_be_stunned && attack.stun != 0:
		stun_time_left += attack.get_stun()
		stunning = true
	## Knockback is applied fully for 1 frame as the player's own movement code then overwrites it quickly on the following frames.
	if can_be_knockbacked && attack.get_knockback() != 0:
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier)
	if game_man.curr_hp <= 0:
		game_man.CreationKilled.emit(self, attack)
		die()
	## This shit doesn't work for some fucked up reason when it's preloaded
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup_color(str(int(round(attack.get_damage()))), net_damage + 36, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), Color.RED)
func ProcessDirection(delta: float):
	## Setup
	direction = direction.normalized() 
	## Move
	position += direction * velocity * delta
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
	position += direction * velocity * delta
var damage_multiplier: float = 1
var attack_counter: float = 0
func _on_body_entered(body: Node2D) -> void:
	if can_attack(body):
		attack_body(body)
		attack_counter += 1
		append_attack_element(body)
## Use 'can_attack' instead of callable get attack because only melee attacks, no projectiles?
func can_attack(body: Node2D) -> bool: 
	return damage_on_collision && body.is_in_group("enemy") && !have_attacked(body)
## Use this for projectiles?? idk
func get_can_attack_callable() -> Callable:
	return func(body: Node2D) -> bool:
		return !body.is_in_group("player") && "can_be_damaged" in body && body.get("can_be_damaged") && body.has_method("damage")
func attack_body(body: Node2D):
	body.damage(make_attack(damage_multiplier))
	if target == body:
		var old_target = target
		get_new_target()
		#print("New = ", target != old_target)
## Calculate and return an attack with damage multiplier
func make_attack(attack_damage_multiplier: float) -> Attack:
	## Make Two Stats Lists
	var base: GlobalStats.StatsList = GlobalStats.get_statslist_base()
	var factor: GlobalStats.StatsList = GlobalStats.get_statslist_factor()
	## Add Self's Base Stats to Base StatList
	base = add_to_stats_list(base)
	factor.add_to_stat(GlobalStats.DAMAGE, attack_damage_multiplier - 1) # -1 to make it a multiplier
	## Make Attack Values
	var attack_type: Attack.AttackTypes = get_attack_type()
	## Make attack and Pass attack through each active upgrade
	var attack: Attack = Attack.new(attack_type, self, global_position, status, base, factor)
	game_man.handle_attack(attack)
	return attack
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.upgrade_creation
func get_attack_position() -> Vector2:
	return global_position
