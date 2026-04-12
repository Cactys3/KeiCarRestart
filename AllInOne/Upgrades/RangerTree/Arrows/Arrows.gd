extends ProjectileUpgrade
## This upgrade:
# Shoot arrows at nearby enemies every 3 seconds.
func _ready() -> void:
	super()
func activate(new_player: Character):
	spawn_every_seconds = arrows_cd
	spawn_with_cd = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass
const arrows_cd: float = 3
