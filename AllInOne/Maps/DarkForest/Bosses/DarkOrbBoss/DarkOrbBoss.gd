extends Boss


func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)

const idle_animation_name: String = "default"
const attack_animation_name: String = "clean_attack"

func shoot_projectile(target: Node2D) -> void:
	## Ensure we aren't progressing projectile timer or shooting more
	shoots_projectiles = false
	var total_time: float = get_animation_runtime(attack_animation_name)
	var first_wait: float = get_animation_runtime(attack_animation_name) * 0.5
	var second_wait: float = get_animation_runtime(attack_animation_name) * 0.3
	var third_wait: float = total_time - (first_wait + second_wait)
	## Play Startup Of Attack
	anim.play(attack_animation_name)
	await get_tree().create_timer(first_wait).timeout
	## Freeze Before Shooting out Projectile
	stop_movement()
	await get_tree().create_timer(second_wait).timeout
	## Spawn Beam After Giving Player Short Time To Dodge
	super(target)
	await get_tree().create_timer(third_wait).timeout
	## Reset Stuff (Movement, Projectile Timer, Animation)
	anim.play(idle_animation_name)
	shoots_projectiles = true
	restart_movement(false)

## Return seconds that animation takes to play
func get_animation_runtime(animation: String) -> float:
	var frame_count = anim.sprite_frames.get_frame_count(animation)
	var fps = anim.sprite_frames.get_animation_speed(animation)
	return frame_count / fps
