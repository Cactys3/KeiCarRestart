extends Upgrade
## This upgrade:
#
var buff_time_left: float = 0
const buff_base_duration: float = 5
var buff_applied = false

## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()

func _process(delta: float) -> void:
	if buff_time_left > 0:
		if !buff_applied:
			buff_applied = true
		buff_time_left -= delta
	super(delta)

func bleed_proc():
	buff_time_left = (buff_base_duration * upgrade_buffs_duration_factor)
