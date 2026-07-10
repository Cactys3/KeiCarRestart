extends Ability
## Make sure to override to set correct type
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
## Gain massive ms
## size
## attackspeed
const movespeed_buff: float = 0.2
const size_buff: float = 0.2
const attackspeed_buff: float = 0.5
func trigger():
	apply_buff()
func apply_buff():
	Statics.player_movespeed_factor += movespeed_buff
	Statics.weapon_size_factor += size_buff
	Statics.weapon_attackspeed_factor -= attackspeed_buff
	Statics.weapon_reloadtime_factor += attackspeed_buff
	Statics.changed_stats()
	super()
func remove_buff():
	Statics.player_movespeed_factor -= movespeed_buff
	Statics.weapon_size_factor -= size_buff
	Statics.weapon_attackspeed_factor += attackspeed_buff
	Statics.weapon_reloadtime_factor -= attackspeed_buff
	## Only call ability finished once the buff has ran out (start cd timer)
	Statics.changed_stats()
	ability_finished()
	super()
