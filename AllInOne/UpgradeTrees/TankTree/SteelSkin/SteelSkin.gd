extends TrapUpgrade
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

var steel_skin_is_aoe: bool = false
var last_knockback: float = 0
var last_attacker: Node2D = null

func player_damaged(character: Character, attack: Attack):
	var knockback: float = abs(attack.get_knockback())
	if knockback > 0:
		## spawn something to damage the guy
		spawn_knockback_thing(attack.attacker, knockback)
func spawn_knockback_thing(enemy: Enemy, knockback: float):
	last_attacker = enemy
	last_knockback = knockback
	spawn()
## Inform the trap if it is AOE or not
func initialize_object(object: Node2D) -> bool:
	var ret = super(object)
	## Set vars
	ret.is_aoe = steel_skin_is_aoe
	ret.steel_skin_target = last_attacker
	ret.steel_skin_knockback = last_knockback
	## Activate the damage
	ret.activate()
	return ret
