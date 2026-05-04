extends Area2D
## Objects spawned by the player or upgrades
class_name SpawnObject
@export var enemy_detection_radius: float = 70
## Return enemy within range
func get_enemy_nearby(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
	return nearest_enemy
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
## Returns if weapon is pointing towards the given enemy, within degree of leniency
func IsAimingAtEnemyWithinDegree(enemy: Node2D, degree: float, current_rotation: float) -> bool:
	if enemy != null:
		var angle = rad_to_deg(acos(Vector2(cos(current_rotation), sin(current_rotation)).dot((enemy.global_position - global_position).normalized())))
		return angle <= degree
	return false
## Returns if weapon is pointing towards any enemy TODO: not setup
func IsAimingAtAnyEnemy(current_rotation: float) -> bool:
	if false: #TODO: setup with raycasts
		return true
	return false
func get_detection_radius() -> float:
	return enemy_detection_radius
