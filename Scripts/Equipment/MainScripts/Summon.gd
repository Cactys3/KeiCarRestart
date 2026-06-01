extends SpawnObject
class_name Summon

## Orbit player/have movement
## Attacking enemy mode
# Two modes? One whilst attacking enemy one whilst not attacking
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, RandomEnemy, ClosestEnemy}
@export var AimType: AimTypes = AimTypes.default
@export var anim: AnimatedSprite2D 
@export var aim_speed: float = 40
@export var orbit_distance: float = 25
@export var max_orbit_distance: float = 50
@export var min_orbit_distance: float = 5
@export var attacks_on_cd: bool = false
@export var shoots_projectile: bool = false
@export var melee_attacks: bool = false
@export var must_aim_at_enemy_to_fire: bool = true
@export var aiming_degree_leniency: float = 25
@export var lock_transform_while_attacking: bool = false
@export var while_attacking_locked_rotation: float = 0
@export var flip_left_right: bool = false
## Should the 'target' variable be updated every few seconds
@export var update_target: bool = true
var weapon_slot: float = 0
var attacking: bool = false
## Used by weapons to offset weapon orbit forward (for use in attacks, etc)
var summon_position_offset: float = 0
var player: Character
var ready_to_fire: bool = false
var target: Node2D
var update_target_stopwatch: float = 0
## Update once a second
var update_target_cooldown: float = 1
func _ready() -> void:
	super()
func setup(new_player: Character):
	player = new_player
func _process(delta: float) -> void:
	super(delta)
	if update_target:
		update_target_stopwatch += delta
		if update_target_stopwatch >= update_target_cooldown:
			update_target_stopwatch = 0
			target = get_enemy_nearby(get_spawn_object_range())
	match AimType:
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
		_:
			ProcessUnique(delta)
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
	var new_angle = rotation + (aim_speed * delta)
	global_position = GetOrbitPosition(new_angle)
	rotation = new_angle
	ready_to_fire = true
## Overriden method to aim uniquely
func ProcessUnique(_delta: float) -> void:
	pass
func ProcessRandomEnemy(delta: float) -> void:
	pass
func ProcessClosestEnemy(delta: float) -> void:
	pass
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
## Calculates the orbit position for a weapon at given target_angle
func GetOrbitPosition(target_angle: float) -> Vector2:
	var ret: Vector2 
	if attacking && lock_transform_while_attacking:
		ret = player.global_position + (Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * clamp(orbit_distance, min_orbit_distance, max_orbit_distance)) + GetSummonOffsetPosition(while_attacking_locked_rotation)
	else:
		ret = player.global_position + (Vector2(cos(target_angle), sin(target_angle)) * clamp(orbit_distance, min_orbit_distance, max_orbit_distance)) + GetSummonOffsetPosition(target_angle)
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
	attacking = true
	if shoots_projectile:
		await shoot_projectile()
	if melee_attacks:
		await melee_attack()
	attacking = false
func shoot_projectile():
	pass
func melee_attack():
	pass

func get_spawn_object_range():
	return range_stat + Statics.summon_range_buff

func _on_body_entered(body: Node2D) -> void:
	super(body)

func _get_hp_stat():
	return (super() + Statics.summon_hp_buff) * Statics.summon_hp_factor
func _get_stance_stat():
	return (super() + Statics.summon_stance_buff) * Statics.summon_stance_factor
func _get_movespeed_stat():
	return (super() + Statics.summon_movespeed_buff) * Statics.summon_movespeed_factor
func _get_xp_stat():
	return (super() + Statics.summon_xp_buff) * Statics.summon_xp_factor
func _get_mogul_stat():
	return (super() + Statics.summon_mogul_buff) * Statics.summon_mogul_factor
func _get_luck_stat():
	return (super() + Statics.summon_luck_buff) * Statics.summon_luck_factor
func _get_damage_stat():
	return (super() + Statics.summon_damage_buff) * Statics.summon_damage_factor
func _get_range_stat():
	return (super() + Statics.summon_range_buff) * Statics.summon_range_factor
func _get_weight_stat():
	return (super() + Statics.summon_weight_buff) * Statics.summon_weight_factor
func _get_attackcooldown_stat():
	return (super() + Statics.summon_attackcooldown_buff) * Statics.summon_attackcooldown_factor
func _get_reloadtime_stat():
	return (super() + Statics.summon_reloadtime_buff) * Statics.summon_reloadtime_factor
func _get_velocity_stat():
	return (super() + Statics.summon_velocity_buff) * Statics.summon_velocity_factor
func _get_ammo_stat():
	return (super() + Statics.summon_ammo_buff) * Statics.summon_ammo_factor
func _get_count_stat():
	return (super() + Statics.summon_count_buff) * Statics.summon_count_factor
func _get_piercing_stat():
	return (super() + Statics.summon_piercing_buff) * Statics.summon_piercing_factor
func _get_duration_stat():
	return (super() + Statics.summon_duration_buff) * Statics.summon_duration_factor
func _get_size_stat():
	return (super() + Statics.summon_size_buff) * Statics.summon_size_factor
func _get_critdamage_stat():
	return (super() + Statics.summon_critdamage_buff) * Statics.summon_critdamage_factor
func _get_ghostly_stat():
	return (super() + Statics.summon_ghostly_buff) * Statics.summon_ghostly_factor
func _get_regen_stat():
	return (super() + Statics.summon_regen_buff) * Statics.summon_regen_factor
func _get_magnetize_stat():
	return (super() + Statics.summon_magnetize_buff) * Statics.summon_magnetize_factor
func _get_lifesteal_stat():
	return (super() + Statics.summon_lifesteal_buff) * Statics.summon_lifesteal_factor
func _get_shield_stat():
	return (super() + Statics.summon_shield_buff) * Statics.summon_shield_factor
func _get_difficulty_stat():
	return (super() + Statics.summon_difficulty_buff) * Statics.summon_difficulty_factor
func _get_revies_stat():
	return (super() + Statics.summon_revies_buff) * Statics.summon_revies_factor
func _get_thorns_stat():
	return (super() + Statics.summon_thorns_buff) * Statics.summon_thorns_factor
func _get_inaccuracy_stat():
	return (super() + Statics.summon_inaccuracy_buff) * Statics.summon_inaccuracy_factor
