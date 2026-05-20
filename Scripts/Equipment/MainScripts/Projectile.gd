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

#var damage: float = 10
#var count: float = 1
#var piercing: float = 0
#var weight: float = 5
#var duration = 10

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
@export var acceleration: float = 0
@export var homing: bool = true
@export var angular_velocity: float = 0.5
@export var can_die_from_collision: bool = true
@export var can_die_from_duration: bool = true
@export var can_spawn_multiple: bool = true
@export var face_rotation: bool = true
@export var can_knockback: bool = true
@export var can_move: bool = true
@export var die_on_anim_end: bool = false
@export var anim: AnimatedSprite2D
@export var sound_on_hit: Sound = null
var prebuilt_attack: Attack = null
var death_method: Callable
var specific_target: bool = false
var can_attack_method: Callable

func _ready() -> void:
	super()
	if die_on_anim_end && anim:
		anim.animation_finished.connect(die)
func _process(delta: float) -> void:
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
	if ((stopwatch > duration_stat) && can_die_from_duration) || ((collision_counter > piercing_stat) && can_die_from_collision):
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
		## Homing
		direction = Vector2.from_angle(move_toward(direction.angle(), (target.global_position - global_position).angle(), delta * angular_velocity))
		#direction = direction.move_toward((target.global_position - global_position).normalized(), delta * angular_velocity)
		#direction = lerp(direction, (target.global_position - global_position).normalized(), delta * angular_velocity)
	process_movement(delta)
## Setup values generic for all BasicProjectile
func setup_projectile(new_parent: StatsObject, new_target: Node2D, enemy_direction:Vector2): 
	parent = new_parent
	can_attack_method = parent.get_can_attack_callable()
	target = new_target
	initial_direction = enemy_direction.normalized()
	direction = enemy_direction.normalized()
	velocity += velocity_stat
	size += size_stat
	#piercing += piercing_stat
	#duration += duration_stat
	#damage += damage_stat
	#weight += weight_stat
	if new_parent is Weapon:
		attack_type = Attack.AttackTypes.player_weapon_projectile
	elif new_parent is Upgrade:
		attack_type = Attack.AttackTypes.upgrade_projectile
	elif new_parent is Turret:
		attack_type = Attack.AttackTypes.upgrade_creation
	elif new_parent is Summon:
		attack_type = Attack.AttackTypes.upgrade_summon
	else:
		printerr("Projectile setup normally but not from weapon or upgrade")
#func setup_add_parent_stats(stats_parent: StatsObject):
	#if parent:
		### Not parent.x_stat bc that would double up on global stats
		#size += parent._size
		#piercing += parent._piercing
		#duration += parent._duration
		#damage += parent._damage
		#velocity += parent._velocity
		#weight += parent._weight
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
func _on_body_entered(body: Node2D) -> void: 
	if dead:
		return
	## Use callable because parent might be freed while projectile still exists
	if (can_attack_method && can_attack_method.call(body)) && !have_attacked(body):
		if sound_on_hit:
			AudioManager.instance.play(sound_on_hit, global_position)
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
		edit_attack_before_sending(attack)
		body.damage(attack)
## In-case overrides want to edit the attack
func edit_attack_before_sending(attack: Attack):
	pass
func make_attack(attack_damage_multiplier: float) -> Attack:
	var new_attack: Attack
	var attack_damage: float = damage_stat
	if is_clone:
		attack_damage = attack_damage * clone_offset
	var knockback: float = 0
	new_attack = Attack.new(attack_type, self, global_position, status, null, null)
	new_attack.simple_setup(attack_damage, weight_stat * (attack_damage / 30))
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
