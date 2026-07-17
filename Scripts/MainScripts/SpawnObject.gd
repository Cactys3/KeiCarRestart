extends StatsObject
## Objects spawned by the player or upgrades
class_name SpawnObject

@export var spawn_name: String = "unset"
@export var can_attack_enemies: bool = true
@export var can_attack_events: bool = true
@export var can_attack_creations: bool = false
@export var can_attack_player: bool = false
@export var can_attack_creator: bool = false
var attack_counter: int = 0
## How long until we can attack an enemy for a second time?
@export var attack_same_enemy_cooldown: float = 1
@export var attack_color: Color = Color.TRANSPARENT
@export var can_die_from_collision: bool = true
@export var can_die_from_duration: bool = true

var check_collision_stopwatch: float = 0

func stats_changed():
	apply_stats()
	super()
func apply_stats():
	scale = Vector2(size_stat, size_stat)
func _ready() -> void:
	super()
	apply_stats()
func _process(delta: float) -> void:
	super(delta)
	## Check Collisions
	check_collision_stopwatch += delta
	if check_collision_stopwatch >= 3:
		check_collisions()
		check_collision_stopwatch = 0
	## Handle Attacked Elements
	for element: AttackedObjectsElement in AttackedObjects:
		if element._process(delta):
			AttackedObjects.erase(element)
## Check area/body that are overlapping
func check_collisions():
	var area = get_node(".") as Area2D
	var collisions: Array[Node2D] = []
	collisions.append_array(area.get_overlapping_areas())
	collisions.append_array(area.get_overlapping_bodies())
	for node in collisions:
		if !have_attacked(node):
			_on_body_entered(node)

## Return enemy within range, try to use detection_range by default
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
func get_random_enemy_in_range_avoid_list(distance: float, avoided_enemies: Array[Enemy]) -> Variant:
	var list = get_tree().get_nodes_in_group("enemy")
	list.shuffle()
	var backup_enemy = null
	for enemy: Node2D in list:
		if !enemy is Enemy:
			## In case random nodes have group 'enemy'
			#print("Not an enemy Fail")
			continue
		if enemy.global_position.distance_to(global_position) < distance:
			## If they're in the list, look for an enemy we haven't attacked first
			if avoided_enemies.has(enemy):
				backup_enemy = enemy
			else:
				return enemy
		else:
			pass#print("Too far fail: ", enemy.global_position.distance_to(global_position), " > ", distance)
	return backup_enemy
func get_random_enemy() -> Variant:
	return get_tree().get_nodes_in_group("enemy").pick_random()
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
## Check if can attack body, then call attack_body
func _on_body_entered(body: Node2D) -> void:
	## Get the Damageable Object
	if "damageable_object" in body:
		body = body.damageable_object
	## Attempt to attack
	if can_attack(body):
		attack_body(body)
## Check if we can attack body using @export variables
func can_attack(body: Node2D) -> bool: 
	## Is it a valid node with required methods/variables
	if !super(body):
		return false
	## Type checks 
	if body.is_in_group("enemy") && !can_attack_enemies:
		return false
	if body.is_in_group("event") && !can_attack_events:
		return false
	if body.is_in_group("player") && !can_attack_player:
		return false
	## Have we attacked it
	return !have_attacked(body)
## Override this to attack the body
func attack_body(body: Node2D):
	append_attack_element(body)
	attack_counter += 1
	body.damage(make_attack(1))

var AttackedObjects: Array = []
func have_attacked(node: Node) -> bool:
	for element: AttackedObjectsElement in AttackedObjects:
		if element.object == node:
			return true
	return false
func append_attack_element(node: Node):
	AttackedObjects.append(AttackedObjectsElement.new(node, attack_same_enemy_cooldown))
## If self is an Area2D, setup collision mask/layer
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	## From Enemy or Player
	area.set_collision_layer_value(3, is_player_weapons)
	area.set_collision_layer_value(5, is_enemy_weapons)
	## Always can check Mask against everything (that can be damaged)
	area.set_collision_mask_value(2, true)
	area.set_collision_mask_value(4, true)
	area.set_collision_mask_value(8, true)
	area.set_collision_mask_value(10, true)
	area.body_entered.connect(_on_body_entered)
	area.area_entered.connect(_on_body_entered)

class AttackedObjectsElement:
	var stopwatch: float = 0
	var duration: float = 0
	var start: bool = false
	var object: Node
	func _init(underlying_object: Node, new_duration: float):
		object = underlying_object
		duration = new_duration
		start = true
	func _process(delta: float) -> bool:
		stopwatch += delta
		if stopwatch >= duration:
			return true
		return false
