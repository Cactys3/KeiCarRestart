extends Weapon
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)

@onready var right_collision: CollisionShape2D = $RightCollision
@onready var left_collision: CollisionShape2D = $LeftCollision
const AttackLeft = "Attack_Left"
const AttackRight = "Attack_Right"
const AttackBoth = "Attack_Both"
const Idle = "Idle"
const IdleFrameRate = 3
const MinPunchTime = 0.10
const MaxPunchTime = 0.3
## Override: Punch left and right for count and then do a big both punch
func attack(): 
	var which: bool = true
	var num_of_punches = count_stat
	var time_per_punch = mult_proj_delay_total_time / (num_of_punches + 1) # +1 for the final punch
	time_per_punch = clamp(time_per_punch, MinPunchTime, MaxPunchTime)
	var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
	var fps = anim.sprite_frames.get_animation_speed(AttackLeft)
	## Make attack take the same total  time no matter how many punches
	anim.speed_scale = (num_of_frames / fps) / time_per_punch
	var i = 0
	print("num punches: ", num_of_punches, " num frames: ", num_of_frames, " fps: ", fps, " time_per_punch: ", time_per_punch)
	while i < num_of_punches:
		print("Punches Left: ", i)
		i += 1
		which = !which
		if which:
			anim.play(AttackLeft)
			left_collision.disabled = false
			await anim.animation_finished
		else:
			anim.play(AttackRight)
			right_collision.disabled = false
			await anim.animation_finished
		right_collision.disabled = true
		left_collision.disabled = true
		
	anim.play(AttackBoth)
	await anim.animation_finished
	anim.play(Idle)
	anim.speed_scale = IdleFrameRate
	#await create_projectiles()
	## Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false

func attack_all_bullets(): 
	var which: bool = true
	var num_of_punches = count_stat
	var time_per_punch = mult_proj_delay_total_time / (num_of_punches + 1) # +1 for the final punch
	time_per_punch = clamp(time_per_punch, MinPunchTime, MaxPunchTime)
	var num_of_frames = anim.sprite_frames.get_frame_count(AttackLeft)
	var fps = anim.sprite_frames.get_animation_speed(AttackLeft)
	## Make attack take the same total  time no matter how many punches
	anim.speed_scale = (num_of_frames / fps) / time_per_punch
	var i = 0
	print("num punches: ", num_of_punches, " num frames: ", num_of_frames, " fps: ", fps, " time_per_punch: ", time_per_punch)
	while i < num_of_punches:
		print("Punches Left: ", i)
		i += 1
		which = !which
		if which:
			anim.play(AttackLeft)
			left_collision.disabled = false
			await anim.animation_finished
		else:
			anim.play(AttackRight)
			right_collision.disabled = false
			await anim.animation_finished
		right_collision.disabled = true
		left_collision.disabled = true
		
	anim.play(AttackBoth)
	await anim.animation_finished
	anim.play(Idle)
	anim.speed_scale = IdleFrameRate
	#await create_projectiles()
	## Reset attack values so we can attack again
	cooldown_timer = 0
	attacking = false
