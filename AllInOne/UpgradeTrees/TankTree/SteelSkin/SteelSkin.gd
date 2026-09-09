extends TrapUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()

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

func edit_spawn_object(object: SpawnObject):
	## Inform the trap if it is AOE or not
	object.is_aoe = steel_skin_is_aoe
	object.steel_skin_target = last_attacker
	object.steel_skin_knockback = last_knockback
	## Activate the damage
	object.activate()
