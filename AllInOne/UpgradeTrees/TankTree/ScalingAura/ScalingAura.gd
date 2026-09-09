extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	healing_aura = find_upgrade(healing_aura_name)
	healing_aura.make_aura_scaling()
	Statics.player_regen_buff += regen_buff
func deactivate():
	super()
	Statics.player_regen_buff -= regen_buff

var healing_aura: Upgrade
var healing_aura_name: String = "Healing Aura"

const regen_buff: float = 2
