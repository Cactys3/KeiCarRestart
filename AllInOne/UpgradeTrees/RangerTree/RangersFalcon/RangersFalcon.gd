extends SummonUpgrade
## This upgrade:
# Spawns a falcon Summon
func _ready() -> void:
	super()
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
