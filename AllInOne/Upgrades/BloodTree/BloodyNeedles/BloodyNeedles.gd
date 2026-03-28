extends SpawningUpgrade 
## This upgrade:
#
const SCENE = preload("uid://ck86b4m7iaeeu")
const spawn_every_seconds_base: int = 5
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

## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	if object is Projectile:
		object = object as Projectile
		var enemy: Node2D = get_nearest_enemy()
		if enemy:
			object.setup_projectile(self, enemy, enemy.global_position, true, 20, false, 0)
			return true
	return false
