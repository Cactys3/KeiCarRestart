extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	healing_aura = find_upgrade(healing_aura_name)
	healing_aura.make_aura_vengeful()
func deactivate():
	super()

var healing_aura: Upgrade
var healing_aura_name: String = "Healing Aura"
