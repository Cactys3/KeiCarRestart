extends Summon

## Send out the swords as spinning projectiles each time we attack
## Alternate sending the left and right projectile
## Attack each time a cooldown from an upgrade happens

## Two swords are independent, they can attack different enemies at the same time, same enemies, etc
## recieve attack call -> check if a sword is avaliable -> check if an enemy is in range -> send that sword out to attack

var check_attack_stopwatch: float = 0

func _ready() -> void:
	queued_attacks = 10
	super()
	## Attack on Upgrade Cooldown Finished
	GameManager.instance.UpgradeCooldownFinished.connect(attack)
func _process(delta: float) -> void:
	super(delta)
	process_swords(delta)
	orbit_angle += delta
	
	if queued_attacks > 0:
		check_attack_stopwatch += delta
		if check_attack_stopwatch > 1:
			queued_attacks -= 1
			attack()
			check_attack_stopwatch = 0
func attack():
	super()
@onready var right_collision: CollisionShape2D = $RightSword/RightCollision
@onready var left_collision: CollisionShape2D = $LeftSword/LeftCollision
@onready var right_sword: Area2D = $RightSword
@onready var left_sword: Area2D = $LeftSword
var left_sword_angular_velocity: float
var right_sword_angular_velocity: float
var left_sword_target: Node2D = null
var right_sword_target: Node2D = null
var left_sword_attacking: bool = false
var right_sword_attacking: bool = false
var right_attacked_list: Array[Node2D]
var left_attacked_list: Array[Node2D]
var right_attacking_stopwatch: float = 0
var left_attacking_stopwatch: float = 0
var right_attacking_cooldown_stopwatch: float = 0
var left_attacking_cooldown_stopwatch: float = 0
## Attack for a max of 5 seconds before stopping
var max_attacking_time: float = 5
## Wait for x second(s) before attacking again
var attack_cooldown_time: float = 1
var orbit_position: Vector2 = Vector2(0, 0)
var angular_drag: float = 0.25

var orbit_angle: float = 0
var max_velocity: float:
	get():
		return velocity_stat
var max_angular_velocity: float = 10
var queued_attacks: int = 0
var checked_right_last: bool = false

func shoot_projectile() -> Projectile:
	return super()
func melee_attack():
	## Find an enemy
	var avoided_list: Array[Enemy] = []
	if right_sword_target:
		avoided_list.append(right_sword_target)
	if left_sword_target:
		avoided_list.append(left_sword_target)
	var enemy: Enemy = get_random_enemy_in_range_avoid_list(range_stat, avoided_list)
	print("Find an enemy:", enemy)
	if !enemy:
		queued_attacks += 1
		return
	## Try to attack
	if checked_right_last:
		if !check_left(enemy) && !check_right(enemy):
			queued_attacks += 1
	else:
		if !check_right(enemy) && !check_left(enemy):
			queued_attacks += 1
	checked_right_last = !checked_right_last

func check_right(enemy: Enemy) -> bool:
	if !right_sword_attacking && right_attacking_cooldown_stopwatch >= attack_cooldown_time:
		right_sword_attacking = true
		right_sword_target = enemy
		right_collision.call_deferred("set_disabled", false)
		## Rotation
		right_sword_angular_velocity = max_angular_velocity
		return true
	return false
func check_left(enemy: Enemy) -> bool:
	if !left_sword_attacking && left_attacking_cooldown_stopwatch >= attack_cooldown_time:
		left_sword_attacking = true
		left_sword_target = enemy
		left_collision.call_deferred("set_disabled", false)
		## Rotation
		left_sword_angular_velocity = -max_angular_velocity
		return true
	return false
## Manage swords attacking
func process_swords(delta: float) -> void:
	## Wait between attacks
	if right_attacking_cooldown_stopwatch <= attack_cooldown_time:
		right_attacking_cooldown_stopwatch += delta
	if left_attacking_cooldown_stopwatch <= attack_cooldown_time:
		left_attacking_cooldown_stopwatch += delta
	process_right(delta)
	process_left(delta)
func process_right(delta: float):
	## Position
	var target_position: = Vector2(0, 0)
	var velocity = max_velocity
	if right_sword_attacking:
		## Stop Attacking - Have attacked for too long
		if right_attacking_stopwatch >= max_attacking_time:
			end_right_attack()
		else: 
			## Move Towards Enemy
			if right_sword_target != null:
				target_position = right_sword_target.global_position
			## Stop Attacking - No Target
			else:
				end_right_attack()
	## Can't use 'else' as we may have called 'end_right_attack()'
	if !right_sword_attacking:
		## Move Towards Player Orbiting Position
		orbit_position = GetOrbitPosition(orbit_angle)
		target_position = orbit_position
		velocity = velocity * 0.6
	## Rotation
	if abs(right_sword_angular_velocity) > 0.05:
		right_sword_angular_velocity -= (right_sword_angular_velocity * angular_drag * delta)
	else:
		right_sword_angular_velocity = 0
	## Execute
	right_sword.global_position = right_sword.global_position.move_toward(target_position, delta * velocity) 
	right_sword.rotation += right_sword_angular_velocity * delta
func process_left(delta: float):
	## Position
	var target_position: = Vector2(0, 0)
	var velocity = max_velocity
	if left_sword_attacking:
		## Move Towards Enemy
		if left_sword_target != null:
			target_position = left_sword_target.global_position
		## Stop Attacking
		else:
			end_left_attack()
	## Can't use 'else' as we may have called 'end_left_attack()'
	if !left_sword_attacking:
		## Move Towards Player Orbiting Position
		orbit_position = GetOrbitPosition(orbit_angle)
		target_position = orbit_position
		velocity = velocity * 0.6
	## Rotation
	if abs(left_sword_angular_velocity) > 0.05:
		left_sword_angular_velocity -= (left_sword_angular_velocity * angular_drag * delta)
	else:
		left_sword_angular_velocity = 0
	## Execute
	left_sword.global_position = left_sword.global_position.move_toward(target_position, delta * velocity) 
	left_sword.rotation += left_sword_angular_velocity * delta

func _on_right_sword_body_entered(body: Node2D) -> void:
	if can_attack(body):
		attack_body(body)
		right_attacked_list.append(body)
	if body == right_sword_target:
		end_right_attack()
func _on_left_sword_body_entered(body: Node2D) -> void:
	if can_attack(body):
		attack_body(body)
		left_attacked_list.append(body)
	if body == left_sword_target:
		end_left_attack()

func end_right_attack():
	right_collision.call_deferred("set_disabled", true)
	right_sword_target = null
	right_sword_attacking = false
	right_attacked_list.clear()
	right_attacking_cooldown_stopwatch = 0
	right_attacking_stopwatch = 0
func end_left_attack():
	left_collision.call_deferred("set_disabled", true)
	left_sword_target = null
	left_sword_attacking = false
	left_attacked_list.clear()
	left_attacking_cooldown_stopwatch = 0
	left_attacking_stopwatch = 0
