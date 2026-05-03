extends SpawnObject
class_name Creation

enum MovementTypes{GivenDirection, NonMoving, NearestEnemy, RandomEnemy, RandomDirection}
@export var movement_type: MovementTypes = MovementTypes.NonMoving
@export var has_self_hitbox: bool = true
var velocity: float = 0
var acceleration: float = 0
var direction: Vector2 = Vector2(0, 0)
var creation_duration: float = 0
var duration_stopwatch: float = 0
var parent: CreationUpgrade
var is_ready: bool = false
func _ready() -> void:
	pass
func setup(new_parent: Equipment, new_duration: float):
	parent = new_parent
	creation_duration = new_duration
	is_ready = true
func _process(delta: float) -> void:
	match movement_type:
		MovementTypes.GivenDirection:
			pass
		MovementTypes.NearestEnemy:
			pass
		MovementTypes.RandomEnemy:
			pass
		MovementTypes.RandomDirection:
			pass
	velocity += velocity * acceleration
	position += direction.normalized() * velocity
	duration_stopwatch += delta
	if duration_stopwatch > creation_duration:
		die()
func _on_area_entered(area: Area2D) -> void:
	pass
func die():
	parent.active_creations.erase(self)
	queue_free()
