extends Projectile
class_name EnemyProjectile
var enemy: Enemy
## Sets up projectile for enemies
func setup_enemy(new_enemy: Enemy, new_target: Node2D, enemy_direction:Vector2, new_is_clone: bool, new_acceleration: float):
	setup_projectile(null, new_target, enemy_direction)
	setup_collisions(false, true)
	enemy = new_enemy
## Swap parent to enemy and fallback to make own attack
func make_parent_attack(attack_damage_multiplier: float) -> Attack:
	if is_instance_valid(enemy):
		return enemy.make_attack(attack_damage_multiplier)
	return make_attack(attack_damage_multiplier)

func can_attack(body: Node2D) -> bool: 
	if !super(body):
		return false
	if body == enemy && !can_attack_creator:
		return false
	return true
