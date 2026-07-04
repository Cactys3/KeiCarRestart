extends ProjectileUpgrade
## This upgrade:
#
var bleed_procs: int = 0
## Set Vars
func _ready() -> void:
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Upgrade Projectiles apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.is_projectile() && attack.is_from_upgrade():
		attack.status.applies_bleed = true
	return attack
## Spawn Additional Based on Bleed Procs
func spawn() -> bool:
	var procs = bleed_procs 
	bleed_procs = 0
	additional_spawns += procs
	var spawned: bool = super()
	additional_spawns -= procs
	return spawned
## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	bleed_procs += 1
	super(bleed_damage, enemy)
