extends Node2D
class_name Turret
## Does it fire multiple projectiles one after another with a delay or at the same time with an angle/position spread
@export var multiple_projectiles_aim_type: Weapon.multiple_projectiles_aim_types = Weapon.multiple_projectiles_aim_types.spread
@export var AimType: AimTypes = AimTypes.TowardsNearestEnemy
@export var has_attacking_animation: bool = false
@export var anim: AnimatedSprite2D 
enum AimTypes{Spinning, TowardsNearestEnemy, TowardsRandomEnemy, AtMouse}
var parent: Equipment
var projectile: Projectile
var turret_duration: float = 10
var duration_stopwatch: float = 0
var homing: bool = false
var homing_speed: float = 0
var target: Node2D
var is_ready: bool = false
func setup(new_parent: Equipment, new_projectile: Projectile, new_duration: float, new_homing: bool, new_homing_speed: float):
	parent = new_parent
	projectile = new_projectile
	turret_duration = new_duration
	homing = new_homing
	homing_speed = new_homing_speed
	is_ready = true
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	if is_ready:
		duration_stopwatch += delta
	if duration_stopwatch >= turret_duration:
		die()
	match(AimType):
		AimTypes.Spinning:
			process_spinning(delta)
		AimTypes.TowardsNearestEnemy:
			process_towards_nearest_enemy(delta)
		AimTypes.TowardsRandomEnemy:
			process_towards_random_enemy(delta)
		AimTypes.AtMouse:
			process_at_mouse(delta)
func process_spinning(delta: float) -> void:
	pass
func process_towards_nearest_enemy(delta: float) -> void:
	pass
func process_towards_random_enemy(delta: float) -> void:
	pass
func process_at_mouse(delta: float) -> void:
	pass
func create_projectile() -> void:
	var proj: Projectile = init_projectile(global_position, Weapon.get_inaccurate_direction(Vector2(cos(rotation), sin(rotation)), parent.inaccuracy_stat))
func init_projectile(new_position: Vector2, new_direction: Vector2) -> Projectile:
	if projectile == null || !is_instance_valid(projectile):
		push_error("projectile null in attachment script")
		return null
	var proj: Projectile = projectile.instantiate()
	proj.visible = false
	if AimType == AimTypes.TowardsNearestEnemy:
		target = get_nearest_enemy()
	elif AimType == AimTypes.TowardsRandomEnemy:
		target = get_random_enemy()
	proj.setup_projectile(parent, target, new_direction, homing, homing_speed, false, 0)
	GameManager.instance.projectile_parent.add_child(proj)
	proj.global_position = new_position
	proj.rotation = new_direction.normalized().angle()
	proj.died.connect(projectile_died)
	return proj
func projectile_died():
	pass
func get_nearest_enemy() -> Variant:
	var nearest_enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if nearest_enemy == null:
			nearest_enemy = enemy
		elif global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = enemy
	return nearest_enemy
func get_random_enemy() -> Variant:
	return get_tree().get_nodes_in_group("enemy").pick_random()

func die():
	pass
