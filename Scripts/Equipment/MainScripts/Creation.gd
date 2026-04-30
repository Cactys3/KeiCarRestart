extends SpawnObject
class_name Creation

enum MovementTypes{GivenDirection, NearestEnemy, RandomEnemy, RandomDirection}
@export var movement_type: MovementTypes = MovementTypes.NearestEnemy
var velocity: float = 0
var acceleration: float = 0
var direction: Vector2 = Vector2(0, 0)

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

func _on_area_entered(area: Area2D) -> void:
	pass
