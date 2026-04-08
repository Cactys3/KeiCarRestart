extends ProjectileUpgrade
## This upgrade:
#
const SCENE = preload("uid://ck86b4m7iaeeu")
const spawn_every_seconds_base: int = 5
var bleed_procs: int = 0
## Set Vars
func _ready() -> void:
	connect_bleed_proc = true
	spawn_projectiles = true
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
