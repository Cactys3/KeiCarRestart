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
@export var anim: AnimatedSprite2D
@export var face_rotation: bool = true
@export var homing: bool = false
@export var acceleration: float = 0
@export var angular_velocity: float = 0.5
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
func setup_projectile(new_parent: StatsObject, new_target: Node2D, target_direction:Vector2): 
	setup_collisions(true, false)
	parent = new_parent
	target = new_target
	if find_own_target:
		target = get_nearest_enemy()
	initial_direction = target_direction.normalized()
	direction = target_direction.normalized()
	velocity += velocity_stat
	size += size_stat
	if new_parent is Weapon:
		attack_type = Attack.AttackTypes.player_weapon_projectile
	elif new_parent is Upgrade:
		attack_type = Attack.AttackTypes.upgrade_projectile
	elif new_parent is Turret:
		attack_type = Attack.AttackTypes.upgrade_creation
	elif new_parent is Projectile:
		attack_type = Attack.AttackTypes.upgrade_projectile
	elif new_parent is Summon:
		attack_type = Attack.AttackTypes.upgrade_summon
	else:
		printerr("Projectile setup normally but not from weapon or upgrade")
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
func make_attack(attack_damage_multiplier: float) -> Attack:
	var attack: Attack = super(attack_damage_multiplier)
	attack.attack_type = attack_type
	attack.can_knockback = can_knockback
	## Set Color
	attack.set_attack_color(attack_color)
	attack.impact_location = global_position
	return attack
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


func _get_hp_stat():
	return (super() + Statics.projectile_hp_buff) * Statics.projectile_hp_factor
func _get_stance_stat():
	return (super() + Statics.projectile_stance_buff) * Statics.projectile_stance_factor
func _get_movespeed_stat():
	return (super() + Statics.projectile_movespeed_buff) * Statics.projectile_movespeed_factor
func _get_xp_stat():
	return (super() + Statics.projectile_xp_buff) * Statics.projectile_xp_factor
func _get_mogul_stat():
	return (super() + Statics.projectile_mogul_buff) * Statics.projectile_mogul_factor
func _get_luck_stat():
	return (super() + Statics.projectile_luck_buff) * Statics.projectile_luck_factor
func _get_damage_stat():
	return (super() + Statics.projectile_damage_buff) * Statics.projectile_damage_factor
func _get_range_stat():
	return (super() + Statics.projectile_range_buff) * Statics.projectile_range_factor
func _get_weight_stat():
	return (super() + Statics.projectile_weight_buff) * Statics.projectile_weight_factor
func _get_attackcooldown_stat():
	return (super() + Statics.projectile_attackcooldown_buff) * Statics.projectile_attackcooldown_factor
func _get_reloadtime_stat():
	return (super() + Statics.projectile_reloadtime_buff) * Statics.projectile_reloadtime_factor
func _get_velocity_stat():
	return (super() + Statics.projectile_velocity_buff) * Statics.projectile_velocity_factor
func _get_ammo_stat():
	return (super() + Statics.projectile_ammo_buff) * Statics.projectile_ammo_factor
func _get_count_stat():
	return (super() + Statics.projectile_count_buff) * Statics.projectile_count_factor
func _get_piercing_stat():
	return (super() + Statics.projectile_piercing_buff) * Statics.projectile_piercing_factor
func _get_duration_stat():
	return (super() + Statics.projectile_duration_buff) * Statics.projectile_duration_factor
func _get_size_stat():
	return (super() + Statics.projectile_size_buff) * Statics.projectile_size_factor
func _get_critdamage_stat():
	return (super() + Statics.projectile_critdamage_buff) * Statics.projectile_critdamage_factor
func _get_ghostly_stat():
	return (super() + Statics.projectile_ghostly_buff) * Statics.projectile_ghostly_factor
func _get_regen_stat():
	return (super() + Statics.projectile_regen_buff) * Statics.projectile_regen_factor
func _get_magnetize_stat():
	return (super() + Statics.projectile_magnetize_buff) * Statics.projectile_magnetize_factor
func _get_lifesteal_stat():
	return (super() + Statics.projectile_lifesteal_buff) * Statics.projectile_lifesteal_factor
func _get_shield_stat():
	return (super() + Statics.projectile_shield_buff) * Statics.projectile_shield_factor
func _get_difficulty_stat():
	return (super() + Statics.projectile_difficulty_buff) * Statics.projectile_difficulty_factor
func _get_revies_stat():
	return (super() + Statics.projectile_revies_buff) * Statics.projectile_revies_factor
func _get_thorns_stat():
	return (super() + Statics.projectile_thorns_buff) * Statics.projectile_thorns_factor
func _get_inaccuracy_stat():
	return (super() + Statics.projectile_inaccuracy_buff) * Statics.projectile_inaccuracy_factor
