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
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)
func apply_buff():
	super()
func remove_buff():
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

var steel_skin_upgrade: Upgrade
var steel_skin_name: String = "Steel Skin"

func creation_damaged(creation: Creation, attack: Attack):
	var knockback: float = abs(attack.get_knockback())
	if knockback > 0:
		if steel_skin_upgrade:
			steel_skin_upgrade.spawn_knockback_thing(attack.attacker, knockback)
		else:
			printerr("Don't have steelskin upgrade ref? need it!")
	super(creation, attack)
