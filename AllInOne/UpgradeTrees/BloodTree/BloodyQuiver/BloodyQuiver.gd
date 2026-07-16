extends ProjectileUpgrade
## This upgrade:
#
var bleed_procs: int = 0
## Set Vars
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Upgrade Projectiles apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.attack_type == Attack.AttackTypes.projectile && attack.attack_source == Attack.AttackSources.upgrade:
		attack.status.applies_bleed = true
	return attack

func edit_spawn_object(object: SpawnObject):
	## Edit spawn objects based on bleeds
	if bleed_procs > 0:
		## TODO: balancing these numbers
		var curr_damage_buff = bleed_procs * 2.0
		var curr_size_buff = bleed_procs / 10.0
		var curr_bleed_buff = bleed_procs / 5.0
		object._size += curr_size_buff
		object._damage += curr_damage_buff
		object.status.applies_bleed = true
		object.bleed_apply += curr_bleed_buff
		bleed_procs = 0

## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	print("bleed += 1, = ", bleed_procs)
	bleed_procs += 1
	super(bleed_damage, enemy)
