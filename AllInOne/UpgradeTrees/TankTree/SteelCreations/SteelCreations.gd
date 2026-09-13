extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	steel_skin_upgrade = find_upgrade(steel_skin_name)
	if steel_skin_upgrade:
		steel_skin_upgrade.steel_skin_is_aoe = true
func deactivate():
	super()

var steel_skin_upgrade: Upgrade
var steel_skin_name: String = "Steel Skin"

func creation_damaged(creation: Creation, attack: Attack):
	print("Creation Damaged")
	var knockback: float = abs(attack.get_knockback())
	if knockback > 0:
		if steel_skin_upgrade:
			steel_skin_upgrade.spawn_knockback_thing(attack.attacker, knockback, creation.global_position)
		else:
			printerr("Don't have steelskin upgrade ref? need it!")
	super(creation, attack)
