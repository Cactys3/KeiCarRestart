extends Projectile
## Spawns a blood puddle on death
@export var puddle: PackedScene
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func die():
	if !dead && puddle:
		var pud = puddle.instantiate()
		GameManager.instance.trap_parent.add_child(pud)
		pud.global_position = global_position
		## Must do this because the turret/etc (var parent) that fired this projectile may have already died before this code activates
		## TODO: Fix things that fire projectiles queue_freeing before all of their projectiles are dead. Make them wait.
		if parent:
			pud.setup(parent)
		else:
			pud.setup(null)
	super()
