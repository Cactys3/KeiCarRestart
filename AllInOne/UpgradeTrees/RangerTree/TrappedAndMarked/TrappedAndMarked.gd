extends ProjectileUpgrade
## This upgrade:
# When an enemy steps on a trap, shoot arrows at them.
func activate(new_player: Character):
	connect_enemy_trapped = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

var last_enemy: Enemy = null
var last_trap: Trap = null # trap as backup to just get trap position and shoot projectile towards there
func enemy_trapped(enemy: Enemy, trap: Trap):
	last_enemy = enemy
	last_trap = trap
	spawn()
## Make sure that projectiles shoots towards enemy that is trapped
func initialize_projectile(projectile: Projectile) -> Projectile:
	var enemy: Node2D = get_nearest_enemy()
	
	if last_enemy:
		enemy = last_enemy
	
	if enemy:
		projectile.setup_projectile(self, get_attack_source(), enemy, (enemy.global_position - player.global_position).normalized())
	else:
		projectile.setup_projectile(self, get_attack_source(), null, player.transform.x)
	return projectile
