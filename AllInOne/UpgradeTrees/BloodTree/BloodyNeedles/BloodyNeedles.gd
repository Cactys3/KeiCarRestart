extends ProjectileUpgrade 
## This upgrade:
#
## Set Vars
func _ready() -> void:
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
func spawn() -> bool:
	return super()
func initialize_projectile(projectile: Projectile) -> Projectile:
	var ret = super(projectile)
	return ret
func _process(delta: float) -> void:
	super(delta)
