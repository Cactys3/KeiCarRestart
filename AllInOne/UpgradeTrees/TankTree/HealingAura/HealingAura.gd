extends SummonUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
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

var aura: Summon = null
var aura_is_scaling: bool = false
## Called by scalingaura
func make_aura_scaling():
	aura_is_scaling = true
	if grab_aura():
		grab_aura().start_scaling()
var aura_is_vengeful: bool = false
## Called by vengefulaura
func make_aura_vengeful():
	aura_is_vengeful = true
	if grab_aura():
		grab_aura().start_venging()
func grab_aura() -> Summon:
	if aura == null:
		if summons.size() > 0:
			aura = summons[0]
		else:
			printerr("Where is aura? we need it by now")
	return aura
