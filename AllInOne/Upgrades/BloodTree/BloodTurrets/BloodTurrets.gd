extends SpawningUpgrade
## This upgrade:
#
## Enables the functionality of this upgrade
func activate(new_player: Character):
	FasterInBloodPuddles = true
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	for turret in active_turrets:
		if is_instance_valid(turret):
			turret.queue_free()
	FasterInBloodPuddles = false
	super()
const SCENE = preload("uid://dovy7157t412j")
const PROJECTILE = preload("uid://cmox0efehx05e")
const turret_duration: float = 10
var active_turrets: Array[Turret] = []
static var FasterInBloodPuddles: bool = false
## Set Vars
func _ready() -> void:
	spawn_on_reload = true
	scene_to_spawn = SCENE
	super()
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	if object is Turret:
		object = object as Turret
		object.setup(self, PROJECTILE, turret_duration + duration_stat, homing, homing_speed)
		active_turrets.append(object)
		return true
	return false

## TODO: Faster in blood puddles (need blood puddles first)
## Walk in blood puddlles = BloodPuddles.Signal
## Connect that signal to a buff thing
## OR 
## Blood puddles look to this script's static 'FasterInBloodPuddles' to see if they boost speed
