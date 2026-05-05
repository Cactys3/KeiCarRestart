extends StatsObject
## Objects spawned by the player or upgrades
class_name SpawnObject
@export var enemy_detection_radius: float = 150
## How long until we can attack an enemy for a second time?
@export var attack_same_enemy_cooldown: float = 2
var AttackedObjects: Array = []
func _process(delta: float) -> void:
	for element: AttackedObjectsElement in AttackedObjects:
		element._process(delta)
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
func get_random_enemy_in_range(distance: float) -> Variant:
	var list = get_tree().get_nodes_in_group("enemy")
	list.shuffle()
	for enemy: Node2D in list:
		if enemy.global_position.distance_to(global_position) < distance:
			return enemy
	return null
func get_enemy_nearby_except_attacked(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		## Don't look at attacked enemies
		if !have_attacked(enemy) && global_position.distance_to(enemy.global_position) <= (distance):# * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif (global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position)):
				nearest_enemy = enemy
	return nearest_enemy
func get_random_enemy_in_range_except_attacked(distance: float) -> Variant:
	var list = get_tree().get_nodes_in_group("enemy")
	list.shuffle()
	for enemy: Node2D in list:
		## Don't look at attacked enemies
		if !have_attacked(enemy) && enemy.global_position.distance_to(global_position) < distance:
			return enemy
	return null
func get_enemy_nearby_avoid_attacked(distance: float) -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if global_position.distance_to(enemy.global_position) <= (distance):# * scale.length()):
			if !nearest_enemy:
				nearest_enemy = enemy
			elif (global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position)):
				## Case: new enemy has been attacked already and previous hasn't, keep previous
				if !(have_attacked(enemy) && !have_attacked(nearest_enemy)):
					nearest_enemy = enemy
			elif !have_attacked(enemy) && have_attacked(nearest_enemy):
					## Case: Enemy Further away hasn't been attacked, use that enemy
					nearest_enemy = enemy
	return nearest_enemy
func get_random_enemy_in_range_avoid_attacked(distance: float) -> Variant:
	var list = get_tree().get_nodes_in_group("enemy")
	list.shuffle()
	var backup_enemy = null
	for enemy: Node2D in list:
		if enemy.global_position.distance_to(global_position) < distance:
			## If we've attacked them, look for an enemy we haven't attacked first
			if have_attacked(enemy):
				backup_enemy = enemy
			else:
				return enemy
	return backup_enemy
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

func have_attacked(node: Node) -> bool:
	for element: AttackedObjectsElement in AttackedObjects:
		if element.object == node:
			return true
	return false
func append_attack_element(node: Node):
	AttackedObjects.append(AttackedObjectsElement.new(node, attack_same_enemy_cooldown, AttackedObjects))

class AttackedObjectsElement:
	var stopwatch: float = 0
	var duration: float = 0
	var start: bool = false
	var list: Array
	var object: Node
	func _init(underlying_object: Node, new_duration: float, new_list: Array):
		object = underlying_object
		duration = new_duration
		list = new_list
		start = true
	func _process(delta: float) -> void:
		stopwatch += delta
		if stopwatch >= duration:
			remove()
	func remove():
		list.erase(self)
