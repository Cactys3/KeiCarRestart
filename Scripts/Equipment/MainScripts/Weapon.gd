extends Equipment
## Weapons Equippable by the player
class_name Weapon
@export_group("Weapon Settings")
@export var sound_on_melee_attack: Sound = null
@export var sound_on_projectile_spawn: Sound = null
@export var anim: AnimatedSprite2D
## Does this animation flip when facing left vs non-flipped when facing right
@export var projectile: PackedScene
@export var time_one_projectile_takes_to_create: float = 0:
	get():
		return _time_one_projectile_takes_to_create()
@export var AimType: AimTypes = AimTypes.default
@export var flip_left_right: bool = false
@export var lock_transform_while_attacking: bool = false
@export var always_ready_to_fire: bool = false
@export var MeleeDamageFactor: float = 1
@export_group("Projectile Settings")
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
@export var projectile_acceleration: float = 0
@export var mult_proj_delay_total_time: float = 2
enum multiple_projectiles_aim_types {delay, spread}
## Does it fire multiple projectiles one after another with a delay or at the same time with an angle/position spread
@export var multiple_projectiles_aim_type: multiple_projectiles_aim_types = multiple_projectiles_aim_types.spread
@export_group("Orbit Settings")
@export var orbit_distance: float = 20
## Used by weapons to offset weapon orbit forward (for use in attacks, etc)
var weapon_position_offset: float = 0
@export var rotation_speed: float = 20
@export var spinning_offset: float = 0
@export var spinning_speed: float = 3
## Can ignore the ready_to_fire variable and assume always ready to fire = true
## Offset that additional projectiles are given when firing multiple, should be different for different weapons and also scale with inaccuracy
var weapon_slot: float = 1
static var weapon_count: float = 0
var current_angle: float = 0  #Stores the angle for smooth circular motion
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, Unique}
var temp_value = 0
#TODO: Used by all handles to tell how many of each aim type there are?
# probably just keep track in player tbh
static var StaticAimCount
static var MouseAimCount
static var SpinAimCount
static var UnqiueAimCount
var projectiles_left_in_ammo: int 
var ready_to_fire: bool = false #Tells attach if it can call Attack()
var projectiles: Array[Projectile]
## Determines what attackspeed is, attacksperX = 2 means attackspeed is how many attacks every 2 seconds
const attacksperX: int = 2
var stopwatch: Timer
var between_attacks_cooldown_stopwatch: float = 0
var between_projectiles_cooldown_stopwatch: float = 0
var attacking: bool = false:
	set(value):
		attacking = value
		if value && lock_transform_while_attacking:
			while_attacking_locked_rotation = rotation
var QueuedAttacks: Array[AttackEvent] = [] #TODO: not used?, to create attack need to use stats which defeats point of queue
var while_attacking_locked_rotation: float
var while_attacking_locked_orbit: float
## Melee Attacks
@export var can_attack_enemies: bool = true
@export var can_attack_events: bool = true
@export var can_attack_player: bool = false
@export var can_attack_creations: bool = false
var attack_counter: int = 0
var AttackedObjects: Array = []

## Override
func activate(new_player: Character):
	super(new_player)
	if get_parent():
		reparent(new_player)
		## This code doesn't work (make sprite very glitchy) for some chud reason so I can't have the weapon on a different parent reparent(GameManager.instance.weapon_parent)
	else:
		new_player.add_child(self)#GameManager.instance.weapon_parent.add_child(self) 
## Override
func deactivate():
	super()
	if get_parent():
		get_parent().remove_child(self)
func _ready() -> void:
	super()
	z_index = 1
	z_as_relative = false
	between_attacks_cooldown_stopwatch = 1000
	between_projectiles_cooldown_stopwatch = 1000
	projectiles_left_in_ammo = ammo_stat
	stopwatch = Timer.new()
	add_child(stopwatch)
## Calls Process_Cooldown
func _process(delta: float) -> void:
	super(delta)
	global_position = player.global_position
	if !QueuedAttacks.is_empty():
		for event in QueuedAttacks:
			QueuedAttacks.erase(event)
			if is_instance_valid(event.attackee) && is_instance_valid(event.attacker):
				event.attacker.attack_body(event.attackee, event.clone)
	if active:
		process_cooldown(delta)
		match AimType:
			AimTypes.DynamicAtMouse:
				ProcessDynamicAtMouse(delta)
			AimTypes.AlwaysAtMouse:
				ProcessAlwaysAtMouse(delta)
			AimTypes.StaticSlot:
				ProcessStaticSlot(delta)
			AimTypes.Spinning:
				ProcessSpinning(delta)
			_:
				ProcessUnique(delta)
## Should handle cooldown and calling attack()
## this is meant to be overridden by classes that inherit it
func process_cooldown(delta: float) -> void: 
	## If attacking, simply wait
	if attacking:
		return
	## if cd between attacks -> if cd between projectiles
	if between_attacks_cooldown_stopwatch > get_cooldown_between_attacks():
		if between_projectiles_cooldown_stopwatch > get_cooldown_between_projectiles():
			if (ready_to_fire || always_ready_to_fire):
				attack()
		else:
			between_projectiles_cooldown_stopwatch += delta
	else:
		between_attacks_cooldown_stopwatch += delta
## await's create_projectiles() and resets attack cooldown
func attack(): 
	attacking = true
	## Allow Melee to hit enemies again
	AttackedObjects.clear()
	## Make sure to add custom code for weapon-specific sounds
	if sound_on_projectile_spawn:
		AudioManager.instance.play(sound_on_projectile_spawn, global_position)
	if projectiles_left_in_ammo > 1:
		await create_projectile()
		between_projectiles_cooldown_stopwatch = 0
		attacking = false
	else:
		await create_last_projectile()
		between_attacks_cooldown_stopwatch = 0
		projectiles_left_in_ammo = ammo_stat
		attacking = false
## Create any projectiles but also do any melee attacks
func create_projectile():
	projectiles_left_in_ammo -= 1
	var proj: Projectile = init_projectile(global_position, get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat))
	game_man.WeaponFired.emit(self, proj)
## Create any projectiles but also do any melee attacks, also do last ammo attacks/reloading stuff
func create_last_projectile():
	create_projectile()
	## Remember to add this line to any override functions 
	game_man.WeaponReloaded.emit(self) 
## Previous implementation of Attack(), Create and setup all the projectiles for an attack from this Weapon
func create_all_projectiles():
	## Create the first bullet by default
	## Randomize Direction Based on inaccuracy
	var direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
	var proj: Projectile = init_projectile(global_position, direction)
	## Create any extra bullets using @export values to offset them by angle and position
	var proj_offset: int = 0
	## Delay Stuff
	var time_inbetween_projectiles: float = mult_proj_delay_total_time / count_stat
	if !proj.can_spawn_multiple:
		## Add 0.5 seconds between shots if projectile normally can't shoot multiple TODO: should probably just not allow making multiple but this might be funny?
		time_inbetween_projectiles += 0.5
	stopwatch.wait_time = time_inbetween_projectiles
	proj_offset = 0
	if proj.can_spawn_multiple && count_stat > 1:
		for i:int in count_stat - 1:
			## Get Attachment Position (default projectile position)
			var projectile_position: Vector2 = global_position
			var projectile_direction: Vector2 = (Vector2(cos(rotation), sin(rotation)))
			if i % 2 == 0:
				proj_offset += 1
			MultipleProjectileOffset *= -1
			MultipleProjectileAngleOffset *= -1
			## Spread Type
			if (multiple_projectiles_aim_type == multiple_projectiles_aim_types.spread):
				## Offset it by position + [1 unit to the Left of default position] * [Positive offset to keep it left, negative to make it right] * [magnitude offset]
				projectile_position += (Vector2(-sin(rotation), cos(rotation)) * MultipleProjectileOffset * proj_offset)
				## Get Direction offset by inaccuracy
				projectile_direction = get_inaccurate_direction(Vector2(cos(rotation + deg_to_rad(proj_offset * MultipleProjectileAngleOffset)), sin(rotation + deg_to_rad(proj_offset * MultipleProjectileAngleOffset))), inaccuracy_stat)
			## Delay Type
			else:
				stopwatch.start()
				await stopwatch.timeout
				projectile_position += (Vector2(-sin(rotation), cos(rotation)))
				projectile_direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
			init_projectile(projectile_position, projectile_direction)
## Initializes and returns one projectile in the style of this attachment
func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null || !is_instance_valid(projectile):
		push_error("projectile null in attachment script")
		return null
	var new_bullet: Projectile = projectile.instantiate()
	new_bullet.visible = false
	new_bullet.setup_projectile(self, null, new_direction)
	new_bullet.setup_can_attacks(can_attack_enemies, can_attack_events, can_attack_player, can_attack_creations)
	if (AimType == AimTypes.Spinning): #handle aim types special cases
		player.add_child(new_bullet)
	else:
		GameManager.instance.projectile_parent.add_child(new_bullet)
	new_bullet.global_position = new_position
	new_bullet.rotation = new_direction.normalized().angle()
	new_bullet.died.connect(projectile_died)
	return new_bullet
## Called when projectile originating from this attachment dies
func projectile_died(pos: Vector2, is_clone: bool):
	pass
func get_cooldown_between_projectiles() -> float:
	return attackcooldown_stat#(attacksperX / max(0.1, attackspeed_stat))
## Calculate and return cooldown between attacks
func get_cooldown_between_attacks() -> float:
	## Minimum: atttack 0.1 times per X
	return reloadtime_stat

static func get_inaccurate_direction(direction: Vector2, given_inaccuracy: float) -> Vector2:
	if given_inaccuracy == 0:
		return direction
	return direction.rotated(deg_to_rad(randf_range(-given_inaccuracy / 3, given_inaccuracy / 3)))
## Sets the weapon's slot in reference to all weapons charcater has, used for calculating position
func change_slot(slot: int, _max: int) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = _max #TODO: Only Static Slot (cardinal direction) weapons should add to this thing
## Do anything that needs to be done to utilize a stat change
func apply_stats() -> void: 
	scale = Vector2(size_stat, size_stat)
## Process Aiming Methods
## Aim at any enemy in range, else aim at mouse, rotating around player towards mouse
func ProcessDynamicAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	var slot_offset_value = 0
	if false: #weapon_slot != 1: ## TODO: implement weapon slots later if needed
		var alternating_sign: float = 1
		if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
			alternating_sign = -1
		var temp_slot_variable: float = weapon_slot
		if weapon_slot > 2:
			if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
				temp_slot_variable = (weapon_slot + 1) / 2
			else:
				temp_slot_variable = (weapon_slot + 2) / 2
		slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = get_enemy_nearby(range_stat)
	if nearest_enemy != null:
		RotateTowardsPosition(nearest_enemy.global_position, delta)
		if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
			ready_to_fire = true
	else:
		RotateTowardsPosition(get_global_mouse_position(), delta)
		ready_to_fire = false
## Aim always at mouse, rotating around player towards mouse
func ProcessAlwaysAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	var slot_offset_value = 0
	if false: #weapon_slot != 1: ## TODO: implement weapon slots later if needed
		var alternating_sign: float = 1
		if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
			alternating_sign = -1
		var temp_slot_variable: float = weapon_slot
		if weapon_slot > 2:
			if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
				temp_slot_variable = (weapon_slot + 1) / 2
			else:
				temp_slot_variable = (weapon_slot + 2) / 2
		slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	global_position = GetOrbitPositionAtMouse((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = get_enemy_nearby(range_stat)
	ready_to_fire = Input.is_action_pressed(InputManager.PRIMARY)
	RotateTowardsPosition(get_global_mouse_position(), delta)
## Aim at nearest enemy from static slot
func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	var temp_count: float = weapon_count
	if (temp_count < 4):
		temp_count = 4
	global_position = GetOrbitPosition((TAU * (weapon_slot / temp_count)))#weapon_count)))
	#Rotate Towards Object
	var nearest_enemy = get_enemy_nearby(range_stat)
	if nearest_enemy != null:
		#Rotate towards Enemy if exists
		RotateTowardsPosition(nearest_enemy.global_position, delta)
		if !ready_to_fire && (IsAimingAtEnemy(nearest_enemy)):
			#Ready To Fire if aiming close enough to enemy, stays ready to fire until we attack or enemy out of range
			ready_to_fire = true
	else:
		ready_to_fire = false
## Spin around player, aiming directly outward from center
func ProcessSpinning(delta: float) -> void:
	spinning_offset += delta * spinning_speed 
	global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot)))
	rotation = spinning_offset + (TAU * (weapon_slot)) 
	ready_to_fire = true
## Overriden method to aim uniquely
func ProcessUnique(_delta: float) -> void:
	pass
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	## don't rotate if shouldn't
	if attacking && lock_transform_while_attacking:
		return
	var speed = rotation_speed * _delta * (10 / max(weight_stat, 1)) ## TODO: Stat: weight
	var angle = (new_position - global_position).normalized().angle()
	rotation = lerp_angle(rotation, angle, speed)
	if flip_left_right:
		## Looks better with angle (desired angle) instead of rotation (current angle)
		anim.flip_v = cos(angle) < 0
 #TODO: try global_position instead of player.global_position for how weapon aiming looks
## Calculates the orbit position for a weapon at given target_angle
func GetOrbitPosition(target_angle: float) -> Vector2:
	if attacking && lock_transform_while_attacking:
		return player.global_position + (Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * orbit_distance) + GetWeaponOffsetPosition(while_attacking_locked_rotation)
	return player.global_position + (Vector2(cos(target_angle), sin(target_angle)) * orbit_distance) + GetWeaponOffsetPosition(target_angle) ## TODO: Stat: Size
func GetOrbitPositionAtMouse(target_angle: float) -> Vector2:
	## Position without new rotation
	if attacking && lock_transform_while_attacking:
		if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
			return player.global_position + Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
		return player.global_position + Vector2(cos(while_attacking_locked_rotation), sin(while_attacking_locked_rotation)) * orbit_distance + GetWeaponOffsetPosition(while_attacking_locked_rotation)
	## Position Normally
	if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
		return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance + GetWeaponOffsetPosition(target_angle)
func GetWeaponOffsetPosition(target_angle: float) -> Vector2:
	return weapon_position_offset * Vector2(cos(target_angle), sin(target_angle))

## Melees

## entered body/area with melee attack, Make sure to use this instead of 'body_entered'
func _on_body_entered(body: Node2D) -> void:
	## Get the Damageable Object
	if "damageable_object" in body:
		body = body.damageable_object
	## Attempt to attack
	if can_attack(body):
		AttackedObjects.append(body)
		body.damage(make_attack(MeleeDamageFactor))
		if sound_on_melee_attack:
			AudioManager.instance.play(sound_on_melee_attack, global_position)
## Check if we can attack body using @export variables
func can_attack(body: Node2D) -> bool: 
	## Is it a valid node with required methods/variables
	if !super(body):
		return false
	## Type checks 
	if body.is_in_group("enemy") && !can_attack_enemies:
		return false
	if body.is_in_group("event") && !can_attack_events:
		return false
	if body.is_in_group("player") && !can_attack_player:
		return false
	## Have we attacked it
	return !AttackedObjects.has(body)
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.player_weapon_melee

class AttackEvent:
	var attackee: Node
	var attacker: Node
	var clone: bool
	func _init(new_attackee: Node, new_attacker: Node, is_clone: bool):
		clone = is_clone
		attackee = new_attackee
		attacker = new_attacker
## Override to calculate time_one_projectile_takes_to_create
func _time_one_projectile_takes_to_create() -> float:
	return time_one_projectile_takes_to_create
