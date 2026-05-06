extends Weapon
@onready var right_sprite: AnimatedSprite2D = $RightGlove/RightSprite
@onready var left_sprite: AnimatedSprite2D = $LeftGlove/LeftSprite
@onready var right_collision: CollisionShape2D = $RightGlove/RightCollision
@onready var left_collision: CollisionShape2D = $LeftGlove/LeftCollision
@onready var right_glove: Area2D = $RightGlove
@onready var left_glove: Area2D = $LeftGlove
@onready var right_projectile_spawn: Node2D = $RightGlove/RightProjectileSpawn
@onready var left_projectile_spawn: Node2D = $LeftGlove/LeftProjectileSpawn
var hit_enemies: Array = []
const AttackLeft = "Left"
const AttackRight = "Right"
const AttackBoth = "Both"
const Idle = "Idle"
const IdleFrameRate = 3
const PunchFrameRate = 3
const MaxPunchFrameRate = 6
const MinPunchFrameRate = 2
const MinPunchTime = 0.10
const MaxPunchTime = 0.3
const projectile_offset: float = 10
var left_or_right: bool = false
var left_position_offset: float = 0
var right_position_offset: float = 0
@export var punch_distance_default: float = 4
func _ready() -> void:
	right_collision.disabled = true
	left_collision.disabled = true
	super()
func _process(delta: float) -> void:
	super(delta)
	## Add in left/right position offsets
	right_glove.position = Vector2(right_position_offset, 0)
	left_glove.position = Vector2(left_position_offset, 0)
## Override: Do a left/right punch
func create_projectile():
	var total: int = 0
	## Melee Attack
	if left_or_right:
		set_anim_speed(get_punch_speed())
		print(get_punch_speed())
		play_anim(AttackLeft)
		left_collision.disabled = false
		#await anim.animation_finished
		## Loop over each frame, offset forward for each frame, add position
		var i: int = 0
		var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
		while (i < num_of_frames - 1):
			i += 1
			## TODO: Instead of doing this jittery movement each frame, calculate the end destination and implement contious movement
			await anim.frame_changed
			left_position_offset += punch_distance_default + (range_stat / 3)
			total += punch_distance_default + (range_stat / 3)
	else:
		set_anim_speed(get_punch_speed())
		play_anim(AttackRight)
		right_collision.disabled = false
		#await anim.animation_finished
		## Loop over each frame, offset forward for each frame, add position
		var i: int = 0
		var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
		while (i < num_of_frames - 1):
			i += 1
			await anim.frame_changed
			right_position_offset += punch_distance_default + (range_stat / 3)
			total += punch_distance_default + (range_stat / 3)
	## Ranged Attack
	projectiles_left_in_ammo -= 1
	var direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
	var proj: Projectile
	if left_or_right:
		proj = init_projectile(left_projectile_spawn.global_position, direction)
	else:
		proj = init_projectile(right_projectile_spawn.global_position, direction)
	## Cleanup
	set_anim_speed(IdleFrameRate)
	play_anim(Idle)
	if left_or_right:
		left_collision.disabled = true
		left_position_offset = 0#-= total ## TODO: slowly return instad of all at once
	else:
		right_collision.disabled = true
		right_position_offset = 0#-= total ## TODO: slowly return instad of all at once
	## Setup for next time
	left_or_right = !left_or_right
## Override: Do a left + right punch
func create_last_projectile():
	## Melee Attack
	projectiles_left_in_ammo -= 1
	set_anim_speed(get_punch_speed())
	play_anim(AttackBoth)
	right_collision.disabled = false
	left_collision.disabled = false
	## Loop over each frame, offset forward for each frame, add position
	var i: int = 0
	var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
	var total: int = 0
	while (i < num_of_frames - 1):
		i += 1
		await anim.frame_changed
		right_position_offset += punch_distance_default + (range_stat / 3)
		left_position_offset += punch_distance_default + (range_stat / 3)
		total += punch_distance_default + (range_stat / 3)
	## Ranged Attack, make one for each punch
	projectiles_left_in_ammo -= 1
	var left_direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
	var left_proj: Projectile = init_projectile(left_projectile_spawn.global_position, left_direction)
	var right_direction = get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), inaccuracy_stat)
	var right_proj: Projectile = init_projectile(right_projectile_spawn.global_position, right_direction)
	## Cleanup
	right_position_offset = 0#-= total ## TODO: slowly return instad of all at once
	left_position_offset = 0#-= total ## TODO: slowly return instad of all at once
	set_anim_speed(IdleFrameRate)
	play_anim(Idle)
	right_collision.disabled = true
	left_collision.disabled = true
	game_man.WeaponReloaded.emit(self) 
## Override to calculate time_one_projectile_takes_to_create
func _time_one_projectile_takes_to_create() -> float:
	#("Frames: ", float(anim.sprite_frames.get_frame_count(AttackLeft)), " at fps: ",  float(get_punch_speed()), " is: ", float(anim.sprite_frames.get_frame_count(AttackLeft)) / float(get_punch_speed()))
	return float(anim.sprite_frames.get_frame_count(AttackLeft)) / float(get_punch_speed())
## Previous implementation of Attack(), punches all punches alternating between L and R before doing a both punch
func create_all_projectiles(): 
	var which: bool = true
	var num_of_punches = count_stat
	var time_per_punch = mult_proj_delay_total_time / (num_of_punches + 1) # +1 for the final punch
	time_per_punch = clamp(time_per_punch, MinPunchTime, MaxPunchTime)
	var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
	var fps = anim.sprite_frames.get_animation_speed(AttackLeft)
	## Make attack take the same total  time no matter how many punches
	set_anim_speed((num_of_frames / fps) / time_per_punch)
	var i = 0
	#print("num punches: ", num_of_punches, " num frames: ", num_of_frames, " fps: ", fps, " time_per_punch: ", time_per_punch)
	while i < num_of_punches:
		#print("Punches Left: ", i)
		i += 1
		which = !which
		if which:
			play_anim(AttackLeft)
			left_collision.disabled = false
			await anim.animation_finished
		else:
			play_anim(AttackRight)
			right_collision.disabled = false
			await anim.animation_finished
		right_collision.disabled = true
		left_collision.disabled = true
	play_anim(AttackBoth)
	await anim.animation_finished
	play_anim(Idle)
	set_anim_speed(IdleFrameRate)
	#await create_projectiles()
func play_anim(animation: String) -> void:
	right_sprite.play(animation)
	left_sprite.play(animation)
func set_anim_speed(speed: float) -> void:
	right_sprite.speed_scale = speed
	left_sprite.speed_scale = speed
func _hit_enemy(enemy: Node2D) -> void:
	if get_can_attack_callable().call(enemy) && !hit_enemies.has(enemy):
		hit_enemies.append(enemy)
		var new_attack :Attack = make_melee_attack()
		enemy.damage(new_attack)
func get_punch_speed() -> float:
	return clamp((PunchFrameRate / max(0.1, attackcooldown_stat * 3)) + (velocity_stat / 90), MinPunchFrameRate, MaxPunchFrameRate)
func attack():
	hit_enemies.clear()
	super()
