extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Projectiles
class_name ProjectileUpgrade
func _process(delta: float) -> void:
	super(delta)
## Enables the functionality of this upgrade
func activate(new_player: Character):
	spawn()
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	despawn()
	super()
func spawn():
	UpgradeStatics.active_projectiles += 1
	## Spawn for count
	for i in UpgradeStatics.projectile_count:
		super()
func despawn():
	UpgradeStatics.active_projectiles -= 1
func initialize_object(object: Node2D) -> bool:
	if object is Projectile:
		var projectile: Projectile = initialize_projectile(object as Projectile)
		## Setup despawn tracker method
		projectile.setup_death_method(despawn)
		return true
	return false
func initialize_projectile(projectile: Projectile) -> Projectile:
	var enemy: Node2D = get_nearest_enemy()
	if enemy:
		projectile.setup_projectile(self, enemy, (enemy.global_position - player.global_position).normalized(), homing, homing_speed, false, 0)
	else:
		projectile.setup_projectile(self, null, player.transform.x, homing, homing_speed, false, 0)
	return projectile
## Projectile variables
@export var homing: bool = false
@export var homing_speed: float = 0
