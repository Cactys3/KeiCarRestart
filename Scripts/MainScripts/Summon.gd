extends SpawnObject
class_name Summon

## Orbit player/have movement
## Attacking enemy mode
# Two modes? One whilst attacking enemy one whilst not attacking
enum AimTypes{default, Unique, AtMouse, StaticRotation, Spinning, RandomEnemy, ClosestEnemy}
enum MovementTypes{default, Unique, TowardsTarget, TowardsAim, Spinning, StaticSlot, OnPlayer}
enum AttackTypes{AlwaysReady, PrimaryFire, TargetInRange}
@export var AimType: AimTypes = AimTypes.default
@export var MovementType: MovementTypes = MovementTypes.default
@export var AttackType: AttackTypes = AttackTypes.AlwaysReady
@export var anim: AnimatedSprite2D 
@export var aim_speed: float = 10
@export var spin_speed: float = 1
@export var lerp_speed: float = 40
@export var orbit_distance: float = 25
@export var max_orbit_distance: float = 50
@export var min_orbit_distance: float = 5
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
## If false, can't go closer to player than orbit distance even if mouse is closer
@export var dynamic_at_mouse: bool = true
@export var static_rotation: float = 0
@export var static_slot_rotation: float = 0
@export var rotate_towards_velocity: bool = true
@export var attacks_on_cd: bool = false
@export var shoots_projectile: bool = false
@export var projectile_scene: PackedScene
@export var custom_melee_attacks: bool = false
@export var fire_towards_rotation: bool = true
@export var must_aim_at_enemy_to_fire: bool = true
@export var must_aim_at_enemy_to_melee: bool = false
@export var aiming_degree_leniency: float = 25
@export var lock_transform_while_attacking: bool = false
@export var while_attacking_locked_rotation: float = 0
@export var use_attackcooldown_stat: bool = true
@export var flip_left_right: bool = false


## Should the 'target' variable be updated every few seconds
@export var update_target: bool = true
var orbit_rotation: float = 0
var aim_spin_rotation: float = 0
var current_rotation: float = 0
var weapon_slot: float = 0
var attacking: bool = false
## Used by weapons to offset weapon orbit forward (for use in attacks, etc)
var summon_position_offset: float = 0
var player: Character
var source: Attack.AttackSources = Attack.AttackSources.unset
var ready_to_fire: bool = false
var target: Node2D
var update_target_stopwatch: float = 0
var falling_back_to_spinning: bool = false
## cooldown
var cooldown_timer: float = 0
## Update once a second
var update_target_cooldown: float = 1
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.summon
func get_attack_source() -> Attack.AttackSources:
	return source
func _ready() -> void:
	super()
func setup(new_player: Character, attack_source: Attack.AttackSources):
	player = new_player
	source = attack_source
	setup_collisions(true, false)
func _process(delta: float) -> void:
	super(delta)
	if update_target:
		update_target_stopwatch += delta
		if update_target_stopwatch >= update_target_cooldown:
			update_target_stopwatch = 0
			set_target(get_enemy_nearby_avoid_attacked(get_spawn_object_range()))
	## Handle Base 'ready to fire' logic
	match AttackType:
		AttackTypes.AlwaysReady:
			ready_to_fire = true
		AttackTypes.PrimaryFire:
			if Input.is_action_just_pressed("M1"):
				ready_to_fire = true
		AttackTypes.TargetInRange:
			if target && !attacking && target.global_position.distance_to(global_position) < get_spawn_object_range():
				ready_to_fire = true
			else:
				ready_to_fire = false
	## Handle Movement 
	match MovementType:
		MovementTypes.default:
			pass
		MovementTypes.Spinning:
			ProcessMovementSpinning(delta)
		MovementTypes.StaticSlot:
			ProcessMovementStaticSlot(delta)
		MovementTypes.OnPlayer:
			ProcessMovementOnPlayer(delta)
		MovementTypes.TowardsTarget:
			ProcessMovementTowardsTarget(delta)
		MovementTypes.TowardsAim:
			pass ## Handle Movement in the Aim methods
		_:
			ProcessMovementUnique(delta)
	## Handle ReadyToFire Variable and Rotation
	match AimType:
		AimTypes.default:
			ProcessAimClosestEnemy(delta)
		AimTypes.AtMouse:
			ProcessAimAtMouse(delta)
		AimTypes.StaticRotation:
			ProcessAimStaticRotation(delta)
		AimTypes.Spinning:
			ProcessAimSpinning(delta)
		AimTypes.RandomEnemy:
			ProcessAimRandomEnemy(delta)
		AimTypes.ClosestEnemy:
			ProcessAimClosestEnemy(delta)
		_:
			ProcessAimUnique(delta)
	var off_cooldown: bool = true
	if use_attackcooldown_stat:
		cooldown_timer -= delta
		off_cooldown = cooldown_timer <= 0
	if ready_to_fire && off_cooldown && (shoots_projectile || custom_melee_attacks):
		attack()
## Rotate Towards Mouse
func ProcessAimAtMouse(delta: float) -> void:
	## If Move Towards Aim
	if MovementType == MovementTypes.TowardsAim:
		## Get Position around player
		if dynamic_at_mouse:
			global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle())
		else:
			global_position = GetOrbitPositionAtMouse((get_global_mouse_position() - player.global_position).normalized().angle())
	## Get Direction Towards Mouse
	RotateTowardsPosition(get_global_mouse_position(), delta)
## Aim at nearest enemy from static slot
func ProcessAimSpinning(delta: float) -> void:
	## If Move Towards Aim
	if MovementType == MovementTypes.TowardsAim:
		pass
	aim_spin_rotation = aim_spin_rotation + (spin_speed * delta)
	rotation = aim_spin_rotation + deg_to_rad(90)
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		anim.flip_v = sin(aim_spin_rotation) > 0
## Aims towards a random enemy we have not attacked yet
func ProcessAimRandomEnemy(delta: float) -> void:
	if !target || have_attacked(target):
		target = null
	## Try to find target
	if !target:
		set_target(get_random_enemy_in_range_except_attacked(get_spawn_object_range()))
	## Finish
	if target:
		## If Move Towards Aim
		if MovementType == MovementTypes.TowardsAim:
			MoveTowardsTarget(delta, target)
		RotateTowardsTarget(delta, target)
		falling_back_to_spinning = false
	else:
		## If Move Towards Aim, Backup
		if MovementType == MovementTypes.TowardsAim:
			MoveTowardsAimBackupProcess(delta)
## Aims towards the closest enemy we have not attacked yet
func ProcessAimClosestEnemy(delta: float) -> void:
	if !target || have_attacked(target):
		target = null
	## Try to find target
	if !target:
		set_target(get_enemy_nearby_avoid_attacked(get_spawn_object_range()))
	## Finish
	if target:
		## If Move Towards Aim
		if MovementType == MovementTypes.TowardsAim:
			MoveTowardsTarget(delta, target)
		RotateTowardsTarget(delta, target)
		falling_back_to_spinning = false
	else:
		## If Move Towards Aim, Backup
		if MovementType == MovementTypes.TowardsAim:
			MoveTowardsAimBackupProcess(delta)
func ProcessAimStaticRotation(delta: float) -> void:
	rotation = static_rotation
	## If Move Towards Aim
	if MovementType == MovementTypes.TowardsAim:
		global_position = GetOrbitPosition(static_rotation)
## Overriden method to aim uniquely
func ProcessAimUnique(_delta: float) -> void:
	pass

## Stay Offset from the Player at a given Static Rotation
func ProcessMovementStaticSlot(delta: float) -> void:
	global_position = GetOrbitPosition(static_slot_rotation)
## Lerp-Spin around player, Uses Velocity_Stat as Lerp Speed
func ProcessMovementSpinning(delta: float) -> void:
	orbit_rotation = orbit_rotation + (spin_speed * delta)
	global_position = global_position.move_toward(GetOrbitPosition(orbit_rotation), max(10, velocity_stat) * delta)
func ProcessMovementOnPlayer(delta: float) -> void:
	global_position = player.global_position
## Moves Towards the Node in var Target, Constrained by Orbit
func ProcessMovementTowardsTarget(delta: float) -> void:
	## Check if no Target
	if !target || have_attacked(target):
		target = null
	## Try to find target
	if !target:
		set_target(get_enemy_nearby_avoid_attacked(get_spawn_object_range()))
	## Backup is Spinning
	if !target:
		if !falling_back_to_spinning:
			RecalculateOrbitPosition()
			falling_back_to_spinning = true
		ProcessMovementSpinning(delta)
	else:
		MoveTowardsTarget(delta, target)
		falling_back_to_spinning = false
## Overriden method to aim uniquely
func ProcessMovementUnique(_delta: float) -> void:
	pass
func MoveTowardsAimBackupProcess(delta: float) -> void:
	ProcessMovementSpinning(delta)

func RotateTowardsTarget(delta: float, target: Node2D) -> void:
	## Track rotation in case of not using real rotation (for aiming detection)
	#current_rotation = move_toward(current_rotation, position.angle_to_point(target.position), aim_speed * delta)
	move_to_rotation(delta, position.angle_to_point(target.position))
	if rotate_towards_velocity:
		rotation = current_rotation
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		anim.flip_v = cos(rotation) < 0
func MoveTowardsTarget(delta: float, target: Node2D) -> void:
	var target_angle: Vector2 = target.global_position - global_position
	if player.global_position.distance_to(target.global_position) < orbit_distance:
		## Orbit Below Max Orbit Distance
		global_position = global_position.move_toward(target.global_position - target_angle.normalized() * 10, max(1, velocity_stat) * delta )
	else:
		## Orbit At Max Orbit Distance
		global_position = global_position.move_toward(GetOrbitPosition(target_angle.angle()), max(1, velocity_stat) * delta)
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, delta: float) -> void:
	## don't rotate if shouldn't
	if attacking && lock_transform_while_attacking:
		return
	var angle = (new_position - global_position).normalized().angle()
	#rotation = lerp_angle(rotation, angle, aim_speed * delta)
	#rotation = move_toward(rotation, angle, aim_speed * delta)
	move_to_rotation(delta, angle)
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		anim.flip_v = cos(angle) < 0
func move_to_rotation(delta: float, new_rotation: float):
	# If the difference is more than 180°, go the other way around
	if new_rotation - current_rotation > PI:
		new_rotation -= TAU
	elif new_rotation - current_rotation < -PI:
		new_rotation += TAU
	current_rotation = move_toward(current_rotation, new_rotation, aim_speed * delta) 
#TODO: try global_position instead of player.global_position for how weapon aiming looks
## Reset orbit_rotation to be the closest orbit to where we are 
func RecalculateOrbitPosition():
	var center: Vector2 = global_position  # or your stored orbit origin, if different
	orbit_rotation = center.angle_to_point(player.global_position)
## Calculates the orbit position for a weapon at given target_angle
func GetOrbitPosition(target_angle: float) -> Vector2:
	var ret: Vector2 
	if player:
		if attacking && lock_transform_while_attacking:
			ret = player.global_position + (Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * clamp(orbit_distance, min_orbit_distance, max_orbit_distance)) + GetSummonOffsetPosition(while_attacking_locked_rotation)
		else:
			ret = player.global_position + (Vector2(cos(target_angle), sin(target_angle)) * clamp(orbit_distance, min_orbit_distance, max_orbit_distance)) + GetSummonOffsetPosition(target_angle)
	else:
		printerr("No player for this summon")
	return ret
func GetOrbitPositionAtMouse(target_angle: float) -> Vector2:
	## Position without new rotation
	if attacking && lock_transform_while_attacking:
		if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
			return player.global_position + Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
		return player.global_position + Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * orbit_distance + GetSummonOffsetPosition(while_attacking_locked_rotation)
	## Position Normally
	if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
		return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance + GetSummonOffsetPosition(target_angle)
func GetSummonOffsetPosition(target_angle: float) -> Vector2:
	return summon_position_offset * Vector2(cos(target_angle), sin(target_angle))

func attack():
	## Lock Rotation (if needed)
	while_attacking_locked_rotation = rotation
	attacking = true
	## Reset Attack Timer
	if use_attackcooldown_stat:
		cooldown_timer = attackcooldown_stat
	## Attack (ready_to_fire = false if at least one attack goes through)
	if shoots_projectile && !must_aim_at_enemy_to_fire || IsAimingAtEnemyWithinDegree(target, aiming_degree_leniency, rotation):
		ready_to_fire = false
		shoot_projectiles()
	if custom_melee_attacks && !must_aim_at_enemy_to_melee || IsAimingAtEnemyWithinDegree(target, aiming_degree_leniency, rotation):
		ready_to_fire = false
		await melee_attack()
	## Finish Attacking
	attacking = false
func shoot_projectiles() -> Array[Projectile]:
	var projectile_target = target
	var projectile_count = count_stat + 1
	if fire_towards_rotation:
		projectile_target = null
	if projectile_scene.instantiate().can_spawn_multiple:
		projectile_count = 1
	return create_num_projectiles(projectile_count, projectile_target)
func melee_attack():
	pass

func post_damage_return(damage_return: Enemy.DamageReturn):
	if lifesteal_stat > 0:
		print("Heal: ", (lifesteal_stat / 100) * damage_return.attack_damage_dealt)
		game_man.heal_player((lifesteal_stat / 100) * damage_return.attack_damage_dealt)
	super(damage_return)
## Create and setup all the projectiles for an attack from this Weapon
func create_num_projectiles(count: int, projectile_target: Node2D) -> Array[Projectile]:
	var ret: Array[Projectile]
	var proj_offset: int = 0
	## Create projectiles based on count with offset angles and position
	for i in count:
		var projectile_position: Vector2 = global_position
		var projectile_direction: Vector2 
		if !projectile_target:
			## Fire towards current rotation of the summon
			projectile_direction = Weapon.get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
		else:
			## Fire towards the target of the attack
			projectile_direction = Weapon.get_inaccurate_direction(projectile_target.global_position - global_position, inaccuracy_stat)
		## Make two projectiles with each offset value at -1 and +1 signs, then increase offset
		if i % 2  == 0:
			proj_offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		## Offset projectile by position + [1 unit to the Left of default position] * [Positive offset to keep it left, negative to make it right] * [magnitude offset]
		projectile_position += (Vector2(-sin(rotation), cos(rotation)) * MultipleProjectileOffset * proj_offset)
		## Get Direction offset by inaccuracy
		var x = cos(projectile_direction.angle() + deg_to_rad(proj_offset * MultipleProjectileAngleOffset))
		var y = sin(projectile_direction.angle() + deg_to_rad(proj_offset * MultipleProjectileAngleOffset))
		#print("(" , snapped(x, 0.01), ", ", snapped(y, 0.01), "), Rot: ", snapped(rotation, 0.01))
		projectile_direction = Vector2(x, y)
		## Signal + init projectile
		ret.append(init_projectile(projectile_position, projectile_direction, projectile_target))
	return ret
## Initializes and returns one projectile in the style of this attachment
func init_projectile(new_position: Vector2, new_direction: Vector2, projectile_target: Node2D) -> Projectile:
	if projectile_scene == null || !is_instance_valid(projectile_scene):
		push_error("projectile null in attachment script")
		return null
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.setup_projectile(self, get_attack_source(), projectile_target, new_direction)
	projectile.setup_can_attacks(can_attack_enemies, can_attack_events, can_attack_player, can_attack_creations)
	GameManager.instance.projectile_parent.add_child(projectile)
	projectile.global_position = new_position
	projectile.rotation = new_direction.normalized().angle()
	projectile.died.connect(projectile_died)
	game_man.ProjectileShot.emit(self, projectile)
	## After Setting Up
	edit_projectile(projectile)
	return projectile
## Override to edit projectile after being made
func edit_projectile(projectile: Projectile) -> void:
	pass
## Called when projectile originating from this attachment dies
func projectile_died(pos: Vector2, is_clone: bool):
	pass
func get_spawn_object_range():
	return range_stat + Statics.summon_range_buff


func set_target(new_target: Node2D):
	target = new_target
	if target != null:
		if target.has_signal("death"):
			target.death.connect(_on_target_died)

func _on_target_died(target_position: Vector2):
	if update_target:
		set_target(get_enemy_nearby_avoid_attacked(get_spawn_object_range()))
func _on_body_entered(body: Node2D) -> void:
	super(body)

## Set Summons layer true
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(12, true)
	super(is_player_weapons, is_enemy_weapons)
