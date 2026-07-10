extends Ability
## Make sure to override to set correct type
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
## Can Trigger while player being stunned
func can_trigger() -> bool:
	return !on_cooldown && !paused_until_ability_finish && !player.stunning
## Dash Character in direction of mouse? or direction of keybinds
func trigger():
	var direction: Vector2 = Vector2.ZERO
	## Towards Movement Inputs
	if Input.is_action_pressed("left"):
		direction.x += -1
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("up"):
		direction.y += -1
	if Input.is_action_pressed("down"):
		direction.y += 1
	## Backup for not moving:
	if direction == Vector2.ZERO:
		## Towards Velocity
		direction = player.last_known_velocity.normalized()
		## Towards Mouse (backup) 
		## TODO: Implement settings for changing all dashes to dash towards mouse
		#direction = (get_global_mouse_position() - player.global_position).normalized()
	## Move Player
	player.velocity += direction * 150
	super()
