extends ProjectileUpgrade 
## This upgrade:
#
const SCENE = preload("uid://ck86b4m7iaeeu")
const spawn_every_seconds_base: float = 0.1
## Set Vars
func _ready() -> void:
	spawn_every_seconds = true
	spawn_every_seconds = spawn_every_seconds_base
	scene_to_spawn = SCENE
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
func spawn() -> bool:
	print("spawn!")
	return super()
func initialize_projectile(projectile: Projectile) -> Projectile:
	var ret = super(projectile)
	print("initialize_projectile!", super(projectile).parent.name)
	return ret
func _process(delta: float) -> void:
	super(delta)
	#print(stopwatch, ">=",  (spawn_every_seconds * spawn_every_seconds_cd_reduction_factor))
