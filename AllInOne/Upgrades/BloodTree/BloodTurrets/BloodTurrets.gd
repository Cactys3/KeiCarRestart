extends CreationUpgrade
## This upgrade:
#
## Enables the functionality of this upgrade
func activate(new_player: Character):
	spawn_on_reload = true
	connect_reload = true
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	for turret in active_creations:
		if is_instance_valid(turret):
			turret.queue_free()
	super()
## Set Vars
func _ready() -> void:
	super()

func reload(weapon: Weapon) -> void:
	super(weapon)
