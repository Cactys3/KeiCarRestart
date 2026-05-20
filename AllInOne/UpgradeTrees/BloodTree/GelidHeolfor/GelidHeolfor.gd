extends Upgrade
## This upgrade:
#
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
func _ready() -> void:
	connect_bleed_proc = true
	connect_frost_proc = true
	super()
## On (enemy) Bleed Proc Signal 
func bleed_proc(bleed_damage: float, enemy: Enemy):
	if enemy.is_frosted:
		explode(enemy)
	super(bleed_damage, enemy)
## On (enemy) Frost Proc Signal 
func frost_proc(frost_damage: float, enemy: Enemy):
	if enemy.is_bleeding:
		explode(enemy)
	super(frost_damage, enemy)
## Spawn an explosion of ice on the enemy
func explode(enemy: Enemy):
	if !enemy.dead:
		pass ## TODO: Spawn an explosion
