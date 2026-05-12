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
func spawn() -> bool:
	## TODO: rework later as spawning them all same place same time probably doesn't look good or function
	var spawned: bool = false
	for i in bleed_procs + 1:
		spawned = spawned || super()
	bleed_procs = 0
	return spawned

## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	bleed_procs += 1
	super(bleed_damage, enemy)
