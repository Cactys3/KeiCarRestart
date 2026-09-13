extends Upgrade
## This upgrade:
#

## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
const damage_buff_to_bled: float = 0.25
const heal_on_bleed: int = 3
## Set Vars
func _ready() -> void:
	super()
func bleed_proc(bleed_damage: float, enemy: Enemy):
	game_man.heal_player(heal_on_bleed, GameManager.HealTypes.heal)
	super(bleed_damage, enemy)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	## More dmg if they're bleeding
	if enemy.is_bleeding:
		attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, damage_buff_to_bled)
	return attack
