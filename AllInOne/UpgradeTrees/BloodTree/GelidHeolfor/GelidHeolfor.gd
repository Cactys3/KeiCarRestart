extends ProjectileUpgrade
## This upgrade:
#
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
func _ready() -> void:
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
var enemies_exploded: Array[Enemy] = []
var enemy_position = Vector2(0, 0)
## Spawn an explosion of ice on the enemy
func explode(enemy: Enemy):
	if enemy && !enemy.dead:# && !enemies_exploded.has(enemy):
		enemy_position = enemy.global_position
		enemies_exploded.append(enemy)
		spawn()
func get_spawning_position() -> Vector2:
	return enemy_position
