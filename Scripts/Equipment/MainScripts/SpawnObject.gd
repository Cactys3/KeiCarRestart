extends StatsObject
## Objects spawned by the player or upgrades
class_name SpawnObject

@export var spawn_name: String = "unset"
@export var can_attack_enemies: bool = true
@export var can_atack_events: bool = true
@export var can_attack_player: bool = false
## How long until we can attack an enemy for a second time?
@export var attack_same_enemy_cooldown: float = 2
@export var attack_color: Color = Color.TRANSPARENT
@export var show_debug_range: bool = false
@export var can_die_from_collision: bool = true
@export var can_die_from_duration: bool = true

var attack_counter: int = 0
var AttackedObjects: Array = []
func _draw() -> void:
	draw_arc(Vector2.ZERO, range_stat, 0, TAU, 64, Color.RED.lerp(Color.TRANSPARENT, 0.7), 1)
func _process(delta: float) -> void:
	super(delta)
	for element: AttackedObjectsElement in AttackedObjects:
		element._process(delta)
	if show_debug_range || DebugManager.SpawnObjectRange:
		queue_redraw()
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
	if can_attack(body):
		attack_body(body)
		attack_counter += 1
		append_attack_element(body)
## Check if we can attack body using @export variables
func can_attack(body: Node2D) -> bool: 
	## Is it a valid node with required methods/variables
	if !super(body):
		return false
	## Type checks 
	if body.is_in_group("enemy") && !can_attack_enemies:
		return false
	if body.is_in_group("event") && !can_atack_events:
		return false
	if body.is_in_group("player") && !can_attack_player:
		return false
	## Have we attacked it
	return !have_attacked(body)
## Override this to attack the body
func attack_body(body: Node2D):
	if body.has_method("damage"):
		body.damage(make_attack(1))

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

func _get_hp_stat():
	return (super() + Statics.spawn_hp_buff) * Statics.spawn_hp_factor
func _get_stance_stat():
	return (super() + Statics.spawn_stance_buff) * Statics.spawn_stance_factor
func _get_movespeed_stat():
	return (super() + Statics.spawn_movespeed_buff) * Statics.spawn_movespeed_factor
func _get_xp_stat():
	return (super() + Statics.spawn_xp_buff) * Statics.spawn_xp_factor
func _get_mogul_stat():
	return (super() + Statics.spawn_mogul_buff) * Statics.spawn_mogul_factor
func _get_luck_stat():
	return (super() + Statics.spawn_luck_buff) * Statics.spawn_luck_factor
func _get_damage_stat():
	return (super() + Statics.spawn_damage_buff) * Statics.spawn_damage_factor
func _get_range_stat():
	return (super() + Statics.spawn_range_buff) * Statics.spawn_range_factor
func _get_weight_stat():
	return (super() + Statics.spawn_weight_buff) * Statics.spawn_weight_factor
func _get_attackcooldown_stat():
	return (super() + Statics.spawn_attackcooldown_buff) * Statics.spawn_attackcooldown_factor
func _get_reloadtime_stat():
	return (super() + Statics.spawn_reloadtime_buff) * Statics.spawn_reloadtime_factor
func _get_velocity_stat():
	return (super() + Statics.spawn_velocity_buff) * Statics.spawn_velocity_factor
func _get_ammo_stat():
	return (super() + Statics.spawn_ammo_buff) * Statics.spawn_ammo_factor
func _get_count_stat():
	return (super() + Statics.spawn_count_buff) * Statics.spawn_count_factor
func _get_piercing_stat():
	return (super() + Statics.spawn_piercing_buff) * Statics.spawn_piercing_factor
func _get_duration_stat():
	return (super() + Statics.spawn_duration_buff) * Statics.spawn_duration_factor
func _get_size_stat():
	return (super() + Statics.spawn_size_buff) * Statics.spawn_size_factor
func _get_critdamage_stat():
	return (super() + Statics.spawn_critdamage_buff) * Statics.spawn_critdamage_factor
func _get_ghostly_stat():
	return (super() + Statics.spawn_ghostly_buff) * Statics.spawn_ghostly_factor
func _get_regen_stat():
	return (super() + Statics.spawn_regen_buff) * Statics.spawn_regen_factor
func _get_magnetize_stat():
	return (super() + Statics.spawn_magnetize_buff) * Statics.spawn_magnetize_factor
func _get_lifesteal_stat():
	return (super() + Statics.spawn_lifesteal_buff) * Statics.spawn_lifesteal_factor
func _get_shield_stat():
	return (super() + Statics.spawn_shield_buff) * Statics.spawn_shield_factor
func _get_difficulty_stat():
	return (super() + Statics.spawn_difficulty_buff) * Statics.spawn_difficulty_factor
func _get_revies_stat():
	return (super() + Statics.spawn_revies_buff) * Statics.spawn_revies_factor
func _get_thorns_stat():
	return (super() + Statics.spawn_thorns_buff) * Statics.spawn_thorns_factor
func _get_inaccuracy_stat():
	return (super() + Statics.spawn_inaccuracy_buff) * Statics.spawn_inaccuracy_factor
