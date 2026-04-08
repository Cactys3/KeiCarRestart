extends Upgrade
## This upgrade:
#
var buff_time_left: float = 0
const buff_base_duration: float = 5
var buff_applied = false
const buff_factor: float = 0.2
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
	check_remove()
func _process(delta: float) -> void:
	if buff_time_left > 0:
		if !buff_applied:
			buff_applied = true
			## Kinda risky no? what if we queue
			GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, buff_factor)
		buff_time_left -= delta
	else:
		check_remove()
	super(delta)
## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	## Don't +=, just = so that it's 5 seconds lasting after whenever you get a bleed proc
	buff_time_left = (buff_base_duration * upgrade_buffs_duration_factor)
	super(bleed_damage, enemy)
func check_remove():
	if buff_applied:
		GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, -buff_factor)
		buff_applied = false
