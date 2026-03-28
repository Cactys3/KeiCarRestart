extends SpawningUpgrade 
## This upgrade:
#
const SCENE = preload("uid://ck86b4m7iaeeu")
const spawn_every_seconds_base: int = 5
## Set Vars
func _ready() -> void:
	spawn_projectiles = true
	homing = false
	homing_speed = 0
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
