extends ProjectileUpgrade
## This upgrade:
#
var bleed_procs: int = 0
## Set Vars
func _ready() -> void:
	connect_bleed_proc = true
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
var curr_damage_buff: float = 0
var curr_size_buff: float = 0
var curr_bleed_buff: float = 0
## Upgrade Projectiles apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.attack_type == Attack.AttackTypes.upgrade_projectile:
		attack.status.applies_bleed = true
	return attack
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	if object is Projectile:
		object = object as Projectile
		var enemy: Node2D = get_nearest_enemy()
		if enemy:
			object.setup_projectile(self, enemy, (enemy.global_position - player.global_position).normalized())
		else:
			object.setup_projectile(self, null, player.transform.x)
		## Make an attack and pass it to the projectile prebuilt
		curr_damage_buff = bleed_procs / 10.0 ## TODO: balancing these number
		curr_size_buff = bleed_procs / 50.0
		curr_bleed_buff = bleed_procs / 2.0
		bleed_procs = 0
		var attack: Attack = make_attack(1)
		attack.temporary_base_stats.add_to_stat(GlobalStats.DAMAGE, curr_damage_buff)
		attack.temporary_base_stats.add_to_stat(GlobalStats.BLEED_APPLY, curr_bleed_buff)
		object.setup_projectile_prebuilt_attack(attack)
		object.scale += Vector2(curr_size_buff, curr_size_buff)
	return false


## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	bleed_procs += 1
	super(bleed_damage, enemy)
