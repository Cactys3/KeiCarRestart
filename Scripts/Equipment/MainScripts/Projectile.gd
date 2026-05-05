extends SpawnObject
class_name Projectile
## Given Variables
var parent: StatsObject
var target: Node2D
var attack_type: Attack.AttackTypes = Attack.AttackTypes.unset
var is_clone: bool 
var clone_offset: float = 0.5
var return_to_sender: bool = false
var sender: Node2D
var size: float = 1:
	set(value):
		scale = Vector2(value, value)
var damage: float = 10
var count: float 
var piercing: float
var weight: float
var velocity: float = 0
var direction:Vector2
var stopwatch: float = 0.0
var lifetime = 10
var acceleration: float = 0
var initial_direction: Vector2
## Self Variables
var collision_counter: float = 0
var dead: bool = false
signal died(pos: Vector2, cloned: bool)
@export var homing: bool = true
@export var angular_velocity: float = 0.5
@export var can_spawn_multiple: bool = true
@export var face_rotation: bool = true
@export var can_knockback: bool = true
@export var can_move: bool = true
@export var die_on_anim_end: bool = false
@export var anim: AnimatedSprite2D
var prebuilt_attack: Attack = null
var death_method: Callable
var specific_target: bool = false
func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
	if die_on_anim_end && anim:
		anim.animation_finished.connect(die)
func flash():
	await get_tree().create_timer(0.1).timeout
	visible = true
func _process(delta: float) -> void:
	#print(visible)
	#print("dead: ", dead, "distance: ", GameManager.instance.player.global_position.distance_to(global_position))
	if dead:
		return
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
	## Death By Old Age
	stopwatch += delta
	if (stopwatch > lifetime) || (collision_counter > piercing):
		print("die")
		die()
	if die_on_anim_end && anim && !anim.animation_finished.is_connected(die):
		anim.animation_finished.connect(die)
func process_movement(delta: float) -> void:
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
		print("homing")
		## Homing
		direction = Vector2.from_angle(move_toward(direction.angle(), (target.global_position - global_position).angle(), delta * angular_velocity))
		#direction = direction.move_toward((target.global_position - global_position).normalized(), delta * angular_velocity)
		#direction = lerp(direction, (target.global_position - global_position).normalized(), delta * angular_velocity)
	process_movement(delta)
## Setup values generic for all BasicProjectile
func setup_projectile(new_parent: StatsObject, new_target: Node2D, enemy_direction:Vector2, new_is_clone: bool, new_acceleration: float): #, new_piercing: float, new_lifetime: float, new_damage: float, new_velocity: float, new_weight: float, new_size: float):
	parent = new_parent
	target = new_target
	initial_direction = enemy_direction.normalized()
	direction = enemy_direction.normalized()
	is_clone = new_is_clone
	acceleration = new_acceleration
	size += size_stat
	piercing += piercing_stat
	lifetime += duration_stat
	damage += damage_stat
	velocity += velocity_stat
	weight += weight_stat
	if new_parent is Weapon:
		attack_type = Attack.AttackTypes.player_weapon_projectile
	elif new_parent is Upgrade:
		attack_type = Attack.AttackTypes.upgrade_projectile
	else:
		printerr("Projectile setup normally but not from weapon or upgrade")
	if parent:
		## Not x_stat bc that would double up on global stats
		size += parent._size
		piercing += parent._piercing
		lifetime += parent._duration
		damage += parent._damage
		velocity += parent._velocity
		weight += parent._weight
func setup_specific_target():
	specific_target = true
## Gives the projectile a prebuilt attack to use instead of calling parent.make_attack()
func setup_projectile_prebuilt_attack(attack: Attack):
	prebuilt_attack = attack
## Setup values specific for clones
func setup_clone(damage_offset: float):
	clone_offset = damage_offset
## Called if this projectile should return_to_sender
func setup_return_to_sender(player: Node2D):
	return_to_sender = true
	sender = player
## Calls the given method when this projectile is destroyed
func setup_death_method(method: Callable):
	death_method = method
func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	if parent.can_attack(body) && !have_attacked(body):
		attack_body(body, is_clone)
		collision_counter += 1
		append_attack_element(body)
func attack_body(body: Node2D, clone: bool) -> void:
	var attack: Attack = null
	## Use prebuilt attack as 1st prio
	if prebuilt_attack:
		attack = prebuilt_attack
	## Then request an attack from parent
	elif is_instance_valid(parent):
		if is_clone:
			attack = parent.make_attack(clone_offset)
		else:
			attack = parent.make_attack(1)
	## Lastly try making own attack
	else:
		attack = make_attack(clone)
	if attack:
		body.damage(attack)
func make_attack(attack_damage_multiplier: float) -> Attack:
	var new_attack: Attack
	var attack_damage: float = damage
	if is_clone:
		attack_damage = damage * clone_offset
	var knockback: float = 0
	new_attack = Attack.new(attack_type, self, global_position, status, null, null)
	new_attack.simple_setup(attack_damage, weight * (attack_damage / 30))
	if !can_knockback:
		## Only set false on !can_knockback (don't set true here incase disabled elsewhere)
		new_attack.can_knockback = false
	return new_attack
func die():
	if dead:
		return
	if death_method:
		death_method.call()
	visible = false
	dead = true
	died.emit(global_position, is_clone)
	queue_free()
