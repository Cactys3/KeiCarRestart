extends Weapon
func _ready() -> void:
	super()
@onready var right_sprite: AnimatedSprite2D = $RightGlove/RightSprite
@onready var left_sprite: AnimatedSprite2D = $LeftGlove/LeftSprite
@onready var right_collision: CollisionShape2D = $RightGlove/RightCollision
@onready var left_collision: CollisionShape2D = $LeftGlove/LeftCollision
@onready var right_glove: Area2D = $RightGlove
@onready var left_glove: Area2D = $LeftGlove

const AttackLeft = "Left"
const AttackRight = "Right"
const AttackBoth = "Both"
const Idle = "Idle"
const IdleFrameRate = 3
const PunchFrameRate = 8
const MinPunchTime = 0.10
const MaxPunchTime = 0.3
var left_or_right: bool = false
var left_position_offset: float = 0
var right_position_offset: float = 0
func _process(delta: float) -> void:
	super(delta)
	## Add in left/right position offsets
	right_glove.position = right_position_offset * Vector2(0, 1)
	left_glove.position = left_position_offset * Vector2(0, 1)
## Override: Do a left/right punch
func create_projectile():
	## Ranged Attack
	super()
	## Melee Attack
	if left_or_right:
		set_anim_speed(PunchFrameRate)
		play_anim(AttackLeft)
		left_collision.disabled = false
		#await anim.animation_finished
		## Loop over each frame, offset forward for each frame, add position
		var i: int = 0
		var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
		var total: int = 0
		while (i < num_of_frames - 1):
			i += 1
			print("Frame: ", i, " / ", num_of_frames)
			await anim.frame_changed
			left_position_offset += 10 + range_stat
			total += 10 + range_stat
		left_position_offset -= total
		set_anim_speed(IdleFrameRate)
		play_anim(Idle)
		left_collision.disabled = true
	else:
		set_anim_speed(PunchFrameRate)
		play_anim(AttackRight)
		right_collision.disabled = false
		#await anim.animation_finished
		## Loop over each frame, offset forward for each frame, add position
		var i: int = 0
		var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
		var total: int = 0
		while (i < num_of_frames - 1):
			i += 1
			print("Frame: ", i, " / ", num_of_frames)
			await anim.frame_changed
			right_position_offset += 10 + range_stat
			total += 10 + range_stat
		right_position_offset -= total
		set_anim_speed(IdleFrameRate)
		play_anim(Idle)
		right_collision.disabled = true
	left_or_right = !left_or_right
## Override: Do a left + right punch
func create_last_projectile():
	## Ranged Attack
	super.create_projectile()
	## Melee Attack
	projectiles_left_in_ammo -= 1
	set_anim_speed(PunchFrameRate)
	play_anim(AttackBoth)
	right_collision.disabled = false
	left_collision.disabled = false
	#await anim.animation_finished
	## Loop over each frame, offset forward for each frame, add position
	var i: int = 0
	var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
	var total: int = 0
	while (i < num_of_frames - 1):
		i += 1
		print("Frame: ", i, " / ", num_of_frames)
		await anim.frame_changed
		right_position_offset += 10 + range_stat
		left_position_offset += 10 + range_stat
		total += 10 + range_stat
	right_position_offset -= total
	left_position_offset -= total
	set_anim_speed(IdleFrameRate)
	play_anim(Idle)
	right_collision.disabled = true
	left_collision.disabled = true
## Override to calculate time_one_projectile_takes_to_create
func _time_one_projectile_takes_to_create() -> float:
	#("Frames: ", float(anim.sprite_frames.get_frame_count(AttackLeft)), " at fps: ",  float(PunchFrameRate), " is: ", float(anim.sprite_frames.get_frame_count(AttackLeft)) / float(PunchFrameRate))
	return float(anim.sprite_frames.get_frame_count(AttackLeft)) / float(PunchFrameRate)
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

func play_anim(anim: String) -> void:
	right_sprite.play(anim)
	left_sprite.play(anim)
func set_anim_speed(speed: float) -> void:
	right_sprite.speed_scale = speed
	left_sprite.speed_scale = speed

func _hit_enemy(enemy: Node2D) -> void:
	if enemy.is_in_group("enemy"):
		enemy = enemy as Enemy
		var attack :Attack = make_attack()
		enemy.damage(attack)
