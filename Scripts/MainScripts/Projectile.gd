extends SpawnObject
class_name Projectile
## Given Variables
var parent: StatsObject
var attack_source: Attack.AttackSources = Attack.AttackSources.unset
var attack_type: Attack.AttackTypes = Attack.AttackTypes.projectile
var target: Node2D
var is_clone: bool 
var clone_offset: float = 0.5
var return_to_sender: bool = false
var sender: Node2D
var size: float = 0:
	set(value):
		scale = Vector2(value + 1, value + 1)
		size = value
var velocity: float = 0
var direction: Vector2 = Vector2(0, 0)
var stopwatch: float = 0.0
var initial_direction: Vector2
## Self Variables
var collision_counter: float = 0
var dead: bool = false
signal died(pos: Vector2, cloned: bool)
@export var anim: AnimatedSprite2D
@export var face_rotation: bool = true
@export var homing: bool = false
@export var keep_starting_direction_for_seconds: float = 0.5
@export var acceleration: float = 0
@export var angular_velocity: float = 0.2
@export var find_own_target: bool = false
@export var make_own_attack: bool = true
@export var sound_on_hit: Sound = null
@export var can_knockback: bool = true
@export var can_move: bool = true
@export var can_spawn_multiple: bool = true
@export var die_on_anim_end: bool = false
@export var rotate_anim_seperately: bool = false
@export_subgroup("Rotate Sprite Seperately")
@export var rotate_anim_velocity: float = 30
@export var rotate_anim_randomize_sign: bool = true
@export var rotate_anim_based_on_speed: bool = true
var prebuilt_attack: Attack = null
var death_method: Callable
var specific_target: bool = false
var keep_starting_direction_stopwatch: float = 0


func _ready() -> void:
	super()
	if die_on_anim_end && anim:
		anim.animation_finished.connect(die)
	if rotate_anim_seperately && rotate_anim_randomize_sign && randi_range(0, 1) == 1:
		rotate_anim_velocity *= -1
func _process(delta: float) -> void:
	if dead:
		return
	super(delta)
	if can_move:
		## Acceleration
		velocity += velocity * acceleration * delta
		## Process Movement
		if homing:
			process_movement_homing(delta)
		else:
			process_movement(delta)
	## Face Rotation
	if face_rotation:
		rotation = direction.angle()
	elif rotate_anim_seperately:
		var rotation_buff: float = 0
		if rotate_anim_based_on_speed:
			rotation_buff = (abs(rotation_buff) + abs(velocity)) * sign(rotation_buff)
		anim.rotate((rotate_anim_velocity + rotation_buff) * delta * TAU / 50)
	## Other stopwatch for homing thing
	keep_starting_direction_stopwatch += delta
	## Death By Old Age
	stopwatch += delta
	if ((stopwatch > duration_stat) && can_die_from_duration) || ((collision_counter > piercing_stat) && can_die_from_collision):
		die()
	if die_on_anim_end && anim && !anim.animation_finished.is_connected(die):
		anim.animation_finished.connect(die)
func process_movement(delta: float) -> void:
	## Only change direction if we've moved for the given seconds
	if keep_starting_direction_stopwatch < keep_starting_direction_for_seconds:
		global_position += (initial_direction).normalized() * velocity * delta
	else:
		global_position += (direction).normalized() * velocity * delta
var check_target_stopwatch: float = 0
var check_target_cd: float = 2
func process_movement_homing(delta: float):
	## Try to get a new target if target is gone
	check_target_stopwatch += delta
	if !target || (check_target_stopwatch >= check_target_cd && !specific_target):
		check_target_stopwatch = 0
		target = get_nearest_enemy()
	if target:
		## Homing
		direction = Vector2.from_angle(move_toward(direction.angle(), (target.global_position - global_position).angle(), delta * angular_velocity))
		#direction = direction.move_toward((target.global_position - global_position).normalized(), delta * angular_velocity)
		#direction = lerp(direction, (target.global_position - global_position).normalized(), delta * angular_velocity)
	process_movement(delta)
## Setup values generic for all BasicProjectile
func setup_projectile(projectile_parent: StatsObject, projectile_attack_source: Attack.AttackSources, projectile_target: Node2D, starting_direction:Vector2): 
	setup_collisions(true, false)
	parent = projectile_parent
	target = projectile_target
	attack_source = projectile_attack_source
	if find_own_target:
		target = get_nearest_enemy()
	initial_direction = starting_direction.normalized()
	direction = starting_direction.normalized()
	velocity += velocity_stat
	size += size_stat
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	## From Enemy or Player
	area.set_collision_layer_value(3, is_player_weapons)
	area.set_collision_layer_value(5, is_player_weapons)
	## Always Projectile
	area.set_collision_layer_value(13, is_player_weapons)
	## Always can check Mask against everything
	area.set_collision_mask_value(2, true)
	area.set_collision_mask_value(4, true)
	area.set_collision_mask_value(8, true)
	area.set_collision_mask_value(10, true)
	area.body_entered.connect(_on_body_entered)
	area.area_entered.connect(_on_body_entered)
func setup_specific_target():
	specific_target = true
## Gives the projectile a prebuilt attack to use instead of calling parent.make_attack()
func setup_projectile_prebuilt_attack(attack: Attack):
	prebuilt_attack = attack
## Setup values specific for clones
func setup_clone(value: bool, damage_offset: float):
	is_clone = value
	clone_offset = damage_offset
## Called if this projectile should return_to_sender
func setup_return_to_sender(player: Node2D):
	return_to_sender = true
	sender = player
## Calls the given method when this projectile is destroyed
func setup_death_method(method: Callable):
	death_method = method
## 
func setup_can_attacks(enemies: bool, events: bool, player: bool, creations: bool):
	can_attack_enemies = enemies
	can_attack_events = events
	can_attack_player = player
	can_attack_creations = creations
func _on_body_entered(body: Node2D) -> void: 
	if dead || !body:
		return
	## Get the Damageable Object
	if "damageable_object" in body:
		body = body.damageable_object
	## Attempt to attack
	if can_attack(body):
		if sound_on_hit:
			AudioManager.instance.play(sound_on_hit, global_position)
		attack_body(body)
		collision_counter += 1
		append_attack_element(body)
func attack_body(body: Node2D) -> void:
	append_attack_element(body)
	attack_counter += 1
	var attack: Attack = null
	## Use prebuilt attack as 1st prio
	if prebuilt_attack:
		attack = prebuilt_attack
	## Then check make_own_attack
	elif make_own_attack:
		if is_clone:
			attack = make_attack(clone_offset)
		else:
			attack = make_attack(1)
	## Then request an attack from parent
	elif is_instance_valid(parent):
		if is_clone:
			attack = make_parent_attack(clone_offset)
		else:
			attack = make_parent_attack(1)
	## Lastly fallback on making own attack
	else:
		if is_clone:
			attack = make_attack(clone_offset)
		else:
			attack = make_attack(1)
	if attack:
		edit_attack_before_sending(attack)
		body.damage(attack)
## In-case overrides want to edit the attack
func edit_attack_before_sending(attack: Attack):
	pass
## Edit attack after making
func handle_attack(attack: Attack):
	attack.can_knockback = can_knockback
	## Set Color
	attack.set_attack_color(attack_color)
	## TODO: calculate the collision point between the projectile and object? so it's not in the center of projectile but at edge
	attack.impact_location = global_position
func get_attack_type() -> Attack.AttackTypes:
	return attack_type
func get_attack_source() -> Attack.AttackSources:
	return attack_source
func make_parent_attack(attack_damage_multiplier: float) -> Attack:
	if is_instance_valid(parent):
		return parent.make_attack(attack_damage_multiplier)
	return null
func can_attack(body: Node2D) -> bool: 
	if !super(body):
		return false
	if body == parent && !can_attack_creator:
		return false
	return true
func die():
	if dead:
		return
	if death_method:
		death_method.call()
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()
