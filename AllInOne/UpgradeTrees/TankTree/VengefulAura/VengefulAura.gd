extends ProjectileUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	healing_aura = find_upgrade(healing_aura_name)
	if healing_aura:
		healing_aura.make_aura_vengeful()
	else:
		print("Healing Aura Missing")
func deactivate():
	super()

var healing_aura: Upgrade
var healing_aura_name: String = "Healing Aura"
var target: Node2D = null

func player_damaged(character: Character, attack: Attack):
	if attack.attacker:
		target = attack.attacker
		spawn()
	super(character, attack)
func get_spawn_target() -> Node2D:
	if target:
		return target
	else:
		return super()
func get_spawning_position() -> Vector2:
	if target:
		return target.global_position
	else:
		return super()
