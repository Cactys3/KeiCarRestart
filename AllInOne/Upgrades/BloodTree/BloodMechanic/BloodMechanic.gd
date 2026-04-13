extends CreationUpgrade
## This upgrade:
#
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
func deactivate():
	for turret in active_turrets:
		if is_instance_valid(turret):
			turret.queue_free()
	super()
## Set Vars
func _ready() -> void:
	spawn_on_reload = true
	edits_attack = true
	super()
## Upgrade Turrets apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.attack_type == Attack.AttackTypes.upgrade_creation:
		attack.status.applies_bleed = true
	return attack

const turret_duration: float = 10
var active_turrets: Array[Turret] = []
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	if object is Turret:
		object = object as Turret
		object.setup(self, turret_duration + duration_stat + UpgradeStatics.creation_duration_buff)
		active_turrets.append(object)
		return true
	return false

## TODO: Implement Blood Puddles
