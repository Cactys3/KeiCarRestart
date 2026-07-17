extends SpawnObject
class_name Summon

## Orbit player/have movement
## Attacking enemy mode
# Two modes? One whilst attacking enemy one whilst not attacking
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, RandomEnemy, ClosestEnemy, OnPlayer}
@export var AimType: AimTypes = AimTypes.default
@export var anim: AnimatedSprite2D 
@export var aim_speed: float = 40
@export var spin_speed: float = 1
@export var lerp_speed: float = 40
@export var orbit_distance: float = 25
@export var max_orbit_distance: float = 50
@export var min_orbit_distance: float = 5
@export var rotate_towwards_velocity: bool = true
@export var attacks_on_cd: bool = false
@export var shoots_projectile: bool = false
@export var projectile_scene: PackedScene
@export var custom_melee_attacks: bool = false
@export var must_aim_at_enemy_to_fire: bool = true
@export var aiming_degree_leniency: float = 25
@export var lock_transform_while_attacking: bool = false
@export var while_attacking_locked_rotation: float = 0
@export var flip_left_right: bool = false
## Should the 'target' variable be updated every few seconds
@export var update_target: bool = true
var orbit_rotation: float = 0
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
			target = get_enemy_nearby(get_spawn_object_range())
	match AimType:
		AimTypes.default:
			ProcessClosestEnemy(delta)
		AimTypes.DynamicAtMouse:
			ProcessDynamicAtMouse(delta)
		AimTypes.AlwaysAtMouse:
			ProcessAlwaysAtMouse(delta)
		AimTypes.StaticSlot:
			ProcessStaticSlot(delta)
		AimTypes.Spinning:
			ProcessSpinning(delta)
		AimTypes.RandomEnemy:
			ProcessRandomEnemy(delta)
		AimTypes.ClosestEnemy:
			ProcessClosestEnemy(delta)
		AimTypes.OnPlayer:
			ProcessOnPlayer(delta)
		_:
			ProcessUnique(delta)
	if ready_to_fire && (shoots_projectile || custom_melee_attacks):
		attack()
## Aim at any enemy in range, else aim at mouse, rotating around player towards mouse
func ProcessDynamicAtMouse(delta: float) -> void:
	update_target = true
	## Get Position around player
	global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle())
	## Get Direction Towards Target
	if is_instance_valid(target):
		RotateTowardsPosition(target.global_position, delta)
		if !ready_to_fire && IsAimingAtEnemyWithinDegree(target, aiming_degree_leniency, rotation):
			ready_to_fire = true
	else:
		RotateTowardsPosition(get_global_mouse_position(), delta)
		ready_to_fire = false
## Aim always at mouse, rotating around player towards mouse
func ProcessAlwaysAtMouse(delta: float) -> void:
	## Get Position around player
	global_position = GetOrbitPositionAtMouse((get_global_mouse_position() - player.global_position).normalized().angle())
	## Get Direction Towards Target
	ready_to_fire = Input.is_action_pressed(InputManager.PRIMARY)
	RotateTowardsPosition(get_global_mouse_position(), delta)
## Aim at nearest enemy from static slot
func ProcessStaticSlot(delta: float) -> void:
	global_position = GetOrbitPosition(0)
	#Rotate Towards Object
	if is_instance_valid(target):
		#Rotate towards Enemy if exists
		RotateTowardsPosition(target.global_position, delta)
		if !ready_to_fire && (IsAimingAtEnemyWithinDegree(target, aiming_degree_leniency, rotation)):
			#Ready To Fire if aiming close enough to enemy, stays ready to fire until we attack or enemy out of range
			ready_to_fire = true
	else:
		ready_to_fire = false
## Spin around player, aiming directly outward from center
func ProcessSpinning(delta: float) -> void:
	orbit_rotation = orbit_rotation + (spin_speed * delta)
	global_position = global_position.move_toward(GetOrbitPosition(orbit_rotation), max(1, velocity_stat) * delta)
	ready_to_fire = true
	if rotate_towwards_velocity:
		rotation = orbit_rotation + deg_to_rad(90)
func ProcessOnPlayer(delta: float) -> void:
	global_position = player.global_position
	ready_to_fire = true
## Overriden method to aim uniquely
func ProcessUnique(_delta: float) -> void:
	pass
func ProcessRandomEnemy(delta: float) -> void:
	if !target || have_attacked(target):
		target = null
	## Try to find target
	if !target:
		target = get_random_enemy_in_range_except_attacked(range_stat)
	## Backup is Spinning
	if !target:
		if !falling_back_to_spinning:
			RecalculateOrbitPosition()
			falling_back_to_spinning = true
		ProcessSpinning(delta)
	else:
		MoveTowardsTarget(delta, target)
		falling_back_to_spinning = false
func ProcessClosestEnemy(delta: float) -> void:
	if !target || have_attacked(target):
		target = null
	## Try to find target
	if !target:
		target = get_enemy_nearby_except_attacked(range_stat)
	## Backup is Spinning
	if !target:
		if !falling_back_to_spinning:
			RecalculateOrbitPosition()
			falling_back_to_spinning = true
		ProcessSpinning(delta)
	else:
		MoveTowardsTarget(delta, target)
		falling_back_to_spinning = false
func MoveTowardsTarget(delta: float, target: Node2D) -> void:
	global_position = global_position.move_toward(target.global_position, max(1, velocity_stat) * delta)
	## Track rotation in case of not using real rotation (for aiming detection)
	current_rotation = position.angle_to_point(target.position)
	if rotate_towwards_velocity:
		rotation = current_rotation
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, delta: float) -> void:
	## don't rotate if shouldn't
	if attacking && lock_transform_while_attacking:
		return
	var angle = (new_position - global_position).normalized().angle()
	rotation = lerp_angle(rotation, angle, aim_speed * delta)
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		anim.flip_v = cos(angle) < 0
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
	if must_aim_at_enemy_to_fire:
		pass
	
	while_attacking_locked_rotation = rotation
	attacking = true
	if shoots_projectile:
		shoot_projectile()
	if custom_melee_attacks:
		await melee_attack()
	attacking = false
func shoot_projectile() -> Projectile:
	if projectile_scene:
		print("projectile")
		var projectile: Projectile = projectile_scene.instantiate()
		GameManager.instance.projectile_parent.add_child(projectile)
		projectile.global_position = global_position
		if target:
			projectile.setup_projectile(self, get_attack_source(), target, target.global_position - global_position)
		else:
			projectile.setup_projectile(self, get_attack_source(), null, Vector2(cos(rotation), sin(rotation)))
		return projectile
	else:
		print("no")
	return null
func melee_attack():
	pass

func get_spawn_object_range():
	return range_stat + Statics.summon_range_buff

func _on_body_entered(body: Node2D) -> void:
	super(body)

## Set Summons layer true
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(12, true)
	super(is_player_weapons, is_enemy_weapons)
