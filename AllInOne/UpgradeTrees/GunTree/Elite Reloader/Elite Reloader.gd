extends Upgrade
## This upgrade:
#
const damage_buff: float = 0.20 # 5%
const buff_duration: float = 1
func apply_buff():
	print("BUFFF")
	## TODO: damage buff
	GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, damage_buff)
	add_to_buff_time(buff_duration)
	super()
func remove_buff():
	print("BUFFF GONE")
	GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, -damage_buff)
	super()
func reload(weapon: Weapon) -> void:
	apply_buff()
	super(weapon)
