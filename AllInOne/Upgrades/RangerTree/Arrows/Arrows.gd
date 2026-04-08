extends ProjectileUpgrade
## This upgrade:
#
const SCENE = null
func _ready() -> void:
	scene_to_spawn = SCENE
	#spawn_on_reload = true
	#homing = true
	#homing_speed = 20
	super()
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func check_remove():
	pass
