extends Area2D
## Objects spawned by the player or upgrades
class_name SpawnObject

## Returns nearest enemy or null
func get_nearest_enemy() -> Variant:
	if get_tree() == null:
		return null
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if nearest_enemy == null:
			nearest_enemy = enemy
		elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = enemy
	return nearest_enemy
func get_random_enemy() -> Variant:
	return get_tree().get_nodes_in_group("enemy").pick_random()

func _on_area_entered(area: Area2D) -> void:
	## Damage enemy
	pass
