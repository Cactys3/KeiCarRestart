extends Summon

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)

## Called by upgrade, doesn't rely on cooldowns and other attack vars
func throw_spear_at_enemy(enemy: Enemy):
	## TODO: Rotate towards enemy
	## TODO: throw spear
	## Make a queue of attacks?
	print("Firing at enemy: ", enemy)
	if enemy:
		var projectiles = create_num_projectiles(count_stat + 1, enemy)
		var index = 0
		for projectile in projectiles:
			print(projectile.spawn_name, ", ", index)
			index += 1

## TODO: Scale Stats with defense

func _get_count_stat():
	return super() + floor(game_man.curr_shield / 10)

func edit_projectile(projectile: Projectile) -> void:
	projectile.velocity += player.movespeed
	projectile._damage += game_man.max_hp / 4
	projectile._piercing += game_man.curr_shield / 7
	super(projectile)
