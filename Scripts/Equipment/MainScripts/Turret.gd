extends Creation
class_name Turret
## Shoot projectiles
## Die after awile
## Take damage on enemy enter?
## Turn TopAnim towards current aim direction
## Only shoot when aiming towards an enemy within degree

## Does it fire multiple projectiles one after another with a delay or at the same time with an angle/position spread
@export var multiple_projectiles_aim_type: multiple_projectiles_aim_types = multiple_projectiles_aim_types.delay
enum multiple_projectiles_aim_types {delay, spread}
@export var AimType: AimTypes = AimTypes.NearestEnemy
@export var has_attacking_animation: bool = false
@export var lock_transform_while_attacking: bool = true
@export var must_aim_at_enemy_to_fire: bool = true
@export var aiming_degree_leniency: float = 25
var attack_cd: float:
	get():
		return attackcooldown_stat
@export var rotation_speed: float = 2.5
@export var detection_range: float = 175
@export var PROJECTILE: PackedScene
@export var base_anim:  AnimatedSprite2D
@export var top_anim:  AnimatedSprite2D
@export var flip_left_right: bool = false
@export var sound_on_spawn: Sound = null
var current_rotation: float = 0
enum AimTypes{Spinning, NearestEnemy, RandomEnemy, AtMouse}
var attacking: bool = false
var attack_on_cd: bool = false
var ready_to_fire: bool = false
var check_nearest_stopwatch: float = 0
var check_nearest_cd: float = 1 ## Check every 1 seconds
var check_aiming_stopwatch: float = 0
var check_aiming_cd: float = 0.5 ## Check every 0.5 seconds
var is_aiming_at_enemy: bool = false
var projectiles_left_in_ammo: int 
var between_attacks_cooldown_stopwatch: float = 0
var between_projectiles_cooldown_stopwatch: float = 0

func _ready() -> void:
	super()
	current_rotation = rotation
	projectiles_left_in_ammo = ammo_stat
func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = null
	## Handles duration stopwatch + movement
	super(delta)
	match(AimType):
		AimTypes.Spinning:
			process_spinning(delta)
		AimTypes.NearestEnemy:
			process_nearest_enemy(delta)
		AimTypes.RandomEnemy:
			process_random_enemy(delta)
		AimTypes.AtMouse:
			process_at_mouse(delta)
	process_cooldown(delta)
## Process cooldowns 
func process_cooldown(delta: float) -> void: 
	if attacking:
		ready_to_fire = false
	else:
		## Are we ready to fire and off attack cooldown
		if (between_attacks_cooldown_stopwatch >= reloadtime_stat) && ready_to_fire:
			## Should we do delay based projectile attacks or all at once
			if multiple_projectiles_aim_type == multiple_projectiles_aim_types.delay:
				if (between_projectiles_cooldown_stopwatch >= attackcooldown_stat):
					pass ## we can fire, leave ready_to_fire = true
				else:
					ready_to_fire = false
					between_projectiles_cooldown_stopwatch += delta
			else:
				pass ## we can fire, leave ready_to_fire = true
		else:
			ready_to_fire = false
			between_attacks_cooldown_stopwatch += delta
	## Should we not fire because we need to aim at them?
	check_aiming_stopwatch += delta
	if ready_to_fire && must_aim_at_enemy_to_fire:
		## Update 'is_aiming_at_enemy'
		if check_aiming_stopwatch > check_aiming_cd:
			check_aiming_stopwatch = 0
			is_aiming_at_enemy = IsAimingAtEnemyWithinDegree(target, aiming_degree_leniency, current_rotation)
		## Trust 'is_aiming_at_enemy' even if it isn't up to date
		ready_to_fire = is_aiming_at_enemy
	## Should we attack after all this checking?
	if ready_to_fire:
		attack()
## Spin around in a circle
func process_spinning(delta: float) -> void:
	ready_to_fire = true
	set_turret_rotation(delta * rotation_speed + current_rotation)
func process_nearest_enemy(delta: float) -> void:
	check_nearest_stopwatch += delta
	if check_nearest_stopwatch >= check_nearest_cd:
		check_nearest_enemy()
	if target:
		ready_to_fire = true
		RotateTowardsPosition(target.global_position, delta)
	else:
		ready_to_fire = false
func process_random_enemy(delta: float) -> void:
	if !target:
		ready_to_fire = false
		var group = get_tree().get_nodes_in_group("Enemy")
		if group.size() > 0:
			target = group.pick_random()
	else:
		ready_to_fire = true
		RotateTowardsPosition(target.global_position, delta)
func process_at_mouse(delta: float) -> void:
	RotateTowardsPosition(get_global_mouse_position(), delta)
func projectile_died(pos: Vector2, cloned: bool):
	pass
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	## don't rotate if shouldn't
	if attacking && lock_transform_while_attacking:
		return
	var angle = (new_position - global_position).normalized().angle()
	set_turret_rotation(lerp_angle(current_rotation, angle, rotation_speed * _delta))
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		top_anim.flip_v = cos(angle) < 0
## Set rotation properly using top_anim (turret barrel)
func set_turret_rotation(new_rotation: float):
	current_rotation = new_rotation
	top_anim.rotation = current_rotation
## Find the nearest enemy and sets 'target' to it, if exists
func check_nearest_enemy():
	check_nearest_stopwatch = 0
	var group = get_tree().get_nodes_in_group("enemy")
	if group.size() > 0:
		if !target:
			target = group[0]
		var distance = target.global_position.distance_to(global_position)
		for enemy: Node2D in group:
			var new_distance = enemy.global_position.distance_to(global_position)
			if new_distance < distance:
				distance = new_distance
				target = enemy
		## Check if the closest enemy is in range
		if target.global_position.distance_to(global_position) > detection_range:
			target = null
func create_last_projectile():
	create_projectile()
func create_projectile():
	var proj: Projectile = init_projectile(global_position, Weapon.get_inaccurate_direction(Vector2(cos(current_rotation), sin(current_rotation)), inaccuracy_stat))
func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if PROJECTILE == null || !is_instance_valid(PROJECTILE):
		push_error("projectile")
		return null
	var proj: Projectile = PROJECTILE.instantiate()
	proj.visible = false
	if !target:
		if AimType == AimTypes.NearestEnemy:
			target = get_nearest_enemy()
		elif AimType == AimTypes.RandomEnemy:
			target = get_random_enemy()
	proj.setup_projectile(self, target, new_direction)
	GameManager.instance.projectile_parent.add_child(proj)
	proj.global_position = new_position
	proj.rotation = new_direction.normalized().angle()
	proj.died.connect(projectile_died)
	return proj

func attack():
	match multiple_projectiles_aim_type:
		multiple_projectiles_aim_types.delay:
			attack_delay()
		multiple_projectiles_aim_types.spread:
			attack_spread()
func attack_spread():
	## Play the sound multiple times for spread attack? maybe louder? diff pitch based on num of projects? 
	if sound_on_spawn:
		AudioManager.instance.play(sound_on_spawn, global_position)
	attacking = true
	for i in count_stat + Statics.creation_count_buff + Statics.spawn_count_buff:	## TODO: Decide if turrets/spawns should take into account global stats? Global 'count' is just for weapons?
		create_projectile()
	between_attacks_cooldown_stopwatch = 0
	attacking = false
## await's create_projectiles() and resets attack cooldown
func attack_delay(): 
	if sound_on_spawn:
		AudioManager.instance.play(sound_on_spawn, global_position)
	attacking = true
	if projectiles_left_in_ammo > 1:
		await create_projectile()
		between_projectiles_cooldown_stopwatch = 0
		attacking = false
	else:
		await create_last_projectile()
		between_attacks_cooldown_stopwatch = 0
		projectiles_left_in_ammo = ammo_stat
		attacking = false
