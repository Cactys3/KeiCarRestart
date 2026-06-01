extends Upgrade
## This upgrade:
#
const buff_base_duration: float = 5
const buff_factor: float = 0.15
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
	check_remove()
## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	## Don't +=, just = so that it's 5 seconds lasting after whenever you get a bleed proc
	if !buff_applied:
		buff_applied = true
		GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, buff_factor)
	add_to_buff_time(buff_base_duration)
	super(bleed_damage, enemy)
func remove_buff():
	GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, -buff_factor)
	super()
