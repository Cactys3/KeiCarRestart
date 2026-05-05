extends Projectile
class_name EnemyProjectile
var enemy: Enemy
## Sets up projectile for enemies
func setup_enemy(new_enemy: Enemy, new_target: Node2D, enemy_direction:Vector2, new_is_clone: bool, new_acceleration: float):
	setup_projectile(null, new_target, enemy_direction)
	enemy = new_enemy
## Attack Override to use Enemy instead of Equipment
func attack_body(body: Node2D, clone: bool) -> void:
	## If enemy that shot us still exists
	if is_instance_valid(enemy):
		enemy.damage_player_projectile(body)
	else:
	## If enemy that shot us has been freed/killed
		var attack: Attack = make_attack(is_clone)
		if attack:
			body.damage(attack)
