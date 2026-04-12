extends ProjectileUpgrade
## This upgrade:
#
const SCENE = preload("uid://ck86b4m7iaeeu")
const spawn_every_seconds_base: int = 5
var bleed_procs: int = 0
## Set Vars
func _ready() -> void:
	edits_attack = true
	connect_bleed_proc = true
	homing = false
	homing_speed = 0
	spawn_every_seconds = true
	spawn_every_seconds = spawn_every_seconds_base
	scene_to_spawn = SCENE
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	var found: bool = false
	for upgrade in GameManager.instance.active_upgrades:
		if upgrade.data.upgrade_name == "BloodNeedles":
			upgrade.disabled_by_inherited_upgrade = true
			found = true
	if !found:
		printerr("Couldn't Find BloodNeedles to disable them (from BloodyMagazine)")
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
			object.setup_projectile(self, enemy, (enemy.global_position - player.global_position).normalized(), homing, homing_speed, false, 0)
		else:
			object.setup_projectile(self, null, player.transform.x, homing, homing_speed, false, 0)
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
