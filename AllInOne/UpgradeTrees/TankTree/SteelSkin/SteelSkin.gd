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
var last_location: Vector2
var timer: float = 0
var cooldown: float = 2

func _process(delta: float) -> void:
	super(delta)
	if timer > 0:
		timer -= delta

func player_damaged(character: Character, attack: Attack):
	if timer <= 0:
		timer = cooldown
		var knockback: float = abs(attack.get_knockback())
		if knockback > 0:
			## spawn something to damage the guy
			spawn_knockback_thing(attack.attacker, knockback, game_man.player.global_position)
func spawn_knockback_thing(target: Node2D, knockback: float, location: Vector2):
	last_attacker = target
	last_knockback = knockback
	last_location = location
	spawn()

func edit_spawn_object(object: SpawnObject):
	## Inform the trap if it is AOE or not
	object.is_aoe = steel_skin_is_aoe
	object.steel_skin_target = last_attacker
	object._damage += last_knockback / 4
	object._weight += floor(last_knockback / 10)

func get_spawning_position() -> Vector2:
	return last_location
