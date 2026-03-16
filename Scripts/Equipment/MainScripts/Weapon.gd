extends Equipment
## Weapons Equippable by the player
class_name Weapon



## NEW STUFF


## Frame

var QueuedAttacks: Array[AttackEvent] = [] #TODO: not used, to create attack need to use stats which defeats point of queue
## Returns nearest enemy or null
func get_nearest_enemy() -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if nearest_enemy == null:
			nearest_enemy = enemy
		elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = enemy
	return nearest_enemy
func get_enemy_nearby(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
	return nearest_enemy
## Returns all enemies within distance
func get_enemies_nearby(distance: float) -> Array[Enemy]:
	var enemies = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			enemies.append(enemy)
	return enemies
## Sets the weapon's slot in reference to all weapons charcater has, used for calculating position
func change_slot(slot: int, _max: int) -> void:#Called when Weapon is created #TODO: does the weapon only need slot number to start?
	weapon_slot = slot
	weapon_count = _max #TODO: Only Static Slot (cardinal direction) weapons should add to this thing

## Do anything that needs to be done to utilize a stat change
func apply_stats() -> void: 
	var size: float = GlobalStats.calculate_scale(get_stat(GlobalStats.SIZE))
	scale = Vector2(size, size)
class AttackEvent:
	var attackee: Node
	var attacker: Node
	var clone: bool
	func _init(new_attackee: Node, new_attacker: Node, is_clone: bool):
		clone = is_clone
		attackee = new_attackee
		attacker = new_attacker


## Handle

@export_category("Generic Settings")
@export var visual: AnimatedSprite2D
## Can ignore the ready_to_fire variable and assume always ready to fire = true
@export var always_ready_to_fire: bool = false
@export_category("Aim Settings")
@export var AimType: AimTypes = AimTypes.default
@export_category("Orbit Settings")
@export var orbit_distance: float = 55

var rotation_speed: float = 20
var weapon_slot: float = 1
var weapon_count: float = 1

var player: Character
var spinning_offset: float = 0
var spinning_speed: float = 3

var current_angle: float = 0  #Stores the angle for smooth circular motion
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, Unique}

var temp_value = 0
#TODO: Used by all handles to tell how many of each aim type there are?
# probably just keep track in player tbh
static var StaticAimCount
static var MouseAimCount
static var SpinAimCount
static var UnqiueAimCount
var ready_to_fire: bool = false #Tells attach if it can call Attack()

## Attachemnt
var bullets: Array[Projectile]
## Determines what attackspeed is, attacksperX = 2 means attackspeed is how many attacks every 2 seconds
const attacksperX: int = 10

@export var MeleeDamageFactor: float = 1
@export var projectile: Projectile
## Offset that additional projectiles are given when firing multiple, should be different for different weapons and also scale with inaccuracy
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
var cooldown_timer: float = 0
var attacking: bool = false
func _ready() -> void:
	cooldown_timer = 0
## Calls Process_Cooldown
func _process(delta: float) -> void:
	if !QueuedAttacks.is_empty():
		for event in QueuedAttacks:
			QueuedAttacks.erase(event)
			if is_instance_valid(event.attackee) && is_instance_valid(event.attacker):
				event.attacker.attack_body(event.attackee, event.clone)
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
	if attacking:
		pass
	elif cooldown_timer <= get_cooldown():
		cooldown_timer += delta
	elif ready_to_fire || always_ready_to_fire:
		attacking = true
		attack() 
## await's create_projectiles() and resets attack cooldown
func attack(): 
	await create_projectiles()
	## Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false
## Create and setup all the projectiles for an attack from this attachment
func create_projectiles():
	## Create the first bullet by default
	## Randomize Direction Based on inaccuracy
	var direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), get_stat(GlobalStats.INACCURACY))
	var proj: Projectile = init_projectile(global_position, direction)
	## Create any extra bullets using @export values to offset them by angle and position
	var proj_offset: int = 0
	if proj.can_spawn_multiple:
		for i:int in get_stat(GlobalStats.COUNT) - 1:
			if i % 2 == 0:
				proj_offset += 1
			MultipleProjectileOffset *= -1
			MultipleProjectileAngleOffset *= -1
			## Get Attachment Position (default projectile position)
			var projectile_position: Vector2 = global_position
			## Offset it by position + [1 unit to the Left of default position] * [Positive offset to keep it left, negative to make it right] * [magnitude offset]
			projectile_position += (Vector2(-sin(rotation), cos(rotation)) * MultipleProjectileOffset * proj_offset)
			## Get Direction offset by inaccuracy
			var projectile_direction: Vector2 = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), get_stat(GlobalStats.INACCURACY))
			init_projectile(projectile_position, projectile_direction)
## Initializes and returns one projectile in the style of this attachment
func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null || !is_instance_valid(projectile):
		push_error("projectile null in attachment script")
		return null
	var new_bullet:Projectile = projectile.get_instance()
	new_bullet.visible = false
	new_bullet.setup(null, new_direction)
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
## Calculate and return cooldown between attacks
func get_cooldown() -> float:
	## Minimum: atttack 0.1 times per X
	return attacksperX / max(0.1, get_stat(GlobalStats.ATTACKSPEED)) ## TODO: Stat: Attackspeed 
## Send altered values because it's a melee hitbox
func make_attack() -> Attack:
	var knockback: float = get_stat(GlobalStats.WEIGHT) * get_stat(GlobalStats.DAMAGE) ## TODO: Stat: knockback
	## MeleeDamageFactor goes inside crit calculation
	var damage: float = GlobalStats.calculate_damage(get_stat(GlobalStats.DAMAGE) * MeleeDamageFactor, get_stat(GlobalStats.CRITCHANCE), get_stat(GlobalStats.CRITDAMAGE)) ## TODO: Stat: damage, critchance, critdamage
	var new_attack: Attack = Attack.new(damage, player.global_position, get_stat(GlobalStats.BUILDUP), StatusEffects.new(), self, 0, 0, knockback)
	 #TODO: determine how to calculate knockback
	return new_attack
func get_inaccurate_direction(direction: Vector2, inaccuracy: float) -> Vector2:
	return direction.rotated(deg_to_rad(randf_range(-inaccuracy / 3, inaccuracy / 3)))

## Handle


## Process Aiming Methods
## Aim at any enemy in range, else aim at mouse, rotating around player towards mouse
func ProcessDynamicAtMouse(delta: float) -> void:
	#Orbit Player Towards Mouse
	var alternating_sign: float = 1
	if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
		alternating_sign = -1
	var temp_slot_variable: float = weapon_slot
	if weapon_slot > 2:
		if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
			temp_slot_variable = (weapon_slot + 1) / 2
		else:
			temp_slot_variable = (weapon_slot + 2) / 2
	var slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	global_position = GetOrbitPosition((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = get_enemy_nearby(get_stat(GlobalStats.RANGE))
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
	var alternating_sign: float = 1
	if (int(weapon_slot) % 2) == 0: #alternate being left of 1st weapon and right
		alternating_sign = -1
	var temp_slot_variable: float = weapon_slot
	if weapon_slot > 2:
		if (int(weapon_slot) % 2) != 0: #make distance only increase once a sword has been added on both left and right with same distance
			temp_slot_variable = (weapon_slot + 1) / 2
		else:
			temp_slot_variable = (weapon_slot + 2) / 2
	var slot_offset_value = alternating_sign * ((TAU / 30) * ((temp_slot_variable - 1)))
	global_position = GetOrbitPositionAtMouse((get_global_mouse_position() - player.global_position).normalized().angle() + slot_offset_value)
	#Rotate Towards Object
	var nearest_enemy: Node2D = get_enemy_nearby(get_stat(GlobalStats.RANGE))
	if nearest_enemy != null:
		if !ready_to_fire && IsAimingAtEnemy(nearest_enemy):
			ready_to_fire = true
	else:
		ready_to_fire = false
	RotateTowardsPosition(get_global_mouse_position(), delta)
## Aim at nearest enemy from static slot
func ProcessStaticSlot(delta: float) -> void:
	#Orbit Player In Assigned Slot
	var temp_count: float = weapon_count
	if (temp_count < 4):
		temp_count = 4
	global_position = GetOrbitPosition((TAU * (weapon_slot / temp_count)))#weapon_count)))
	#Rotate Towards Object
	var nearest_enemy = get_enemy_nearby(get_stat(GlobalStats.RANGE))
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
	spinning_offset += delta * spinning_speed #TODO: Have a static value between all handles used to know how many of each aim type there are?
	global_position = GetOrbitPosition(spinning_offset + (TAU * (weapon_slot))) #should be used if there are multiple spinning weapons
	rotation = spinning_offset + (TAU * (weapon_slot)) #face directly outward (works?)
	ready_to_fire = true
## Overriden method to aim uniquely
func ProcessUnique(_delta: float) -> void:
	pass
## rotates this weapon towards the new position, TODO: lerp calculated with weight
func RotateTowardsPosition(new_position: Vector2, _delta: float) -> void:
	var speed = rotation_speed * _delta * (10 / max(get_stat(GlobalStats.WEIGHT), 0.1)) ## TODO: Stat: weight
	var angle = (new_position - global_position).normalized().angle()
	rotation = lerp_angle(rotation, angle, speed)
 #TODO: try global_position instead of player.global_position for how weapon aiming looks
## Calculates the orbit position for a weapon at given target_angle
func GetOrbitPosition(target_angle: float) -> Vector2:
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance ## TODO: Stat: Size
func GetOrbitPositionAtMouse(target_angle: float) -> Vector2:
	if player.global_position.distance_to(get_global_mouse_position()) < orbit_distance:
		return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * (player.global_position.distance_to(get_global_mouse_position()) - 1)
	return player.global_position + Vector2(cos(target_angle), sin(target_angle)) * orbit_distance
## Returns if weapon is pointing towards the given enemy
func IsAimingAtEnemy(enemy: Node2D) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= 5
	return false
## Returns if weapon is pointing towards the given enemy, within degree of leniency
func IsAimingAtEnemyWithinDegree(enemy: Node2D, degree: float) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(global_transform.x.normalized().dot((enemy.global_position - global_position).normalized())))
		return angle <= degree
	return false
## Returns if weapon is pointing towards any enemy TODO: not setup
func IsAimingAtAnyEnemy() -> bool:
	if false: #TODO: setup with raycasts
		return true
	return false
