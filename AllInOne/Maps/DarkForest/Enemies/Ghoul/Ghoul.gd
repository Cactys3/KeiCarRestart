extends Enemy
func _ready() -> void:
	super()
	hitbox_disabled = true
	damage_hitbox.monitoring = false
	can_attack_enemies = true
	can_attack_events = true
	can_attack_player = true
	can_attack_creations = true
	super()
func _process(delta: float) -> void:
	super(delta)

## Ghoul's damage hitbox only is enabled after it dies during its explosion
## Ghoul dies when its custom collision hitbox encounters a player, or when it dies normally

func _on_ghoul_custom_collision_body_entered(body: Node2D) -> void:
	die()
func play_animation(animation: String):
	## On play death animation, enable explosion hitbox
	if animation == play_animation_on_death:
		#print("Playing Death, Waittime: ", get_animation_runtime(play_animation_on_death) * 0.5)
		enable_hitbox(get_animation_runtime(play_animation_on_death) * 0.5)
		return await super(animation)
## Enable the explosion hitbox after the wait time
func enable_hitbox(time: float):
	await get_tree().create_timer(time, false).timeout
	damage_hitbox.monitoring = true
	hitbox_disabled = false
## Return seconds that animation takes to play
func get_animation_runtime(animation: String) -> float:
	var frame_count = anim.sprite_frames.get_frame_count(animation)
	var fps = anim.sprite_frames.get_animation_speed(animation)
	return frame_count / fps
