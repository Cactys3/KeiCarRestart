extends SpawnObject
class_name Projectile
## Given Variables
var parent: Equipment
var target: Node2D
var attack_type: Attack.AttackTypes = Attack.AttackTypes.unset
var homing: bool
var homing_speed: float
var is_clone: bool 
var clone_offset: float = 0.5
var return_to_sender: bool = false
var sender: Node2D
var size: float = 1
var damage: float = 10
var count: float 
var piercing: float
var weight: float
var velocity: float = 20
var direction:Vector2
var AttackedObjects: Array[Node2D] = []
var stopwatch: float = 0.0
var lifetime = 10
var acceleration: float = 0
var initial_direction: Vector2
## Self Variables
var collision_counter: float = 0
var dead: bool = false
signal died(pos: Vector2, cloned: bool)
@export var can_spawn_multiple: bool = true
@export var face_rotation: bool = true
@export var can_knockback: bool = true
@export var can_move: bool = true
@export var die_on_anim_end: bool = false
@export var anim: AnimatedSprite2D
var status: StatusEffects
var prebuilt_attack: Attack = null
var death_method: Callable
func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
	gravity = 0
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
		die()
	if die_on_anim_end && anim && !anim.animation_finished.is_connected(die):
		anim.animation_finished.connect(die)
func process_movement(delta: float) -> void:
	global_position += (direction).normalized() * velocity * delta
var homing_stopwatch: float = 0
func process_movement_homing(delta: float):
	## Homing on a cooldown:
	homing_stopwatch += delta
	if homing_stopwatch >= 30:
		homing_stopwatch = 0
		## Try to get a new target if target is gone
		if !target:
			print("no target")
			target = get_nearest_enemy()
		if target:
			## Homing
			#move_toward(rotation, (target.global_position - global_position).angle(), delta * homing_speed)	
			direction = direction.move_toward((target.global_position - global_position).normalized(), delta * homing_speed)
			global_position += (direction).normalized() * velocity * delta
	else:
		## No Homing
		process_movement(delta)
## Setup values generic for all BasicProjectile
func setup_projectile(new_parent: Equipment, new_target: Node2D, enemy_direction:Vector2, is_homing: bool, new_homing_speed: float, new_is_clone: bool, new_acceleration: float): #, new_piercing: float, new_lifetime: float, new_damage: float, new_velocity: float, new_weight: float, new_size: float):
	parent = new_parent
	self.scale = Vector2(size, size) #TODO: size calculation
	target = new_target
	initial_direction = enemy_direction.normalized()
	direction = enemy_direction.normalized()
	homing = is_homing
	homing_speed = new_homing_speed
	is_clone = new_is_clone
	acceleration = new_acceleration
	if new_parent is Weapon:
		attack_type = Attack.AttackTypes.player_weapon_projectile
	elif new_parent is Upgrade:
		attack_type = Attack.AttackTypes.upgrade_projectile
	else:
		printerr("Projectile setup normally but not from weapon or upgrade")
	if parent:
		size = parent.size_stat#size = new_size
		piercing = parent.piercing_stat#piercing = new_piercing
		lifetime = parent.duration_stat#lifetime = new_lifetime
		damage = parent.damage_stat#damage = new_damage
		velocity = parent.velocity_stat#velocity = new_velocity
		weight = parent.weight_stat#weight = new_weight
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
	if parent.can_attack(body) && !AttackedObjects.has(body):
		attack_body(body, is_clone)
		collision_counter += 1
		AttackedObjects.append(body)
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
func make_attack(clone: bool) -> Attack:
	var new_attack: Attack
	var attack_damage: float = damage
	if clone:
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
