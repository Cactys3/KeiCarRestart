extends TrapUpgrade
## This upgrade:
# Spawns a Quicksand Traps
func _ready() -> void:
	super()
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
