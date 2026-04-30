extends SpawnObject
class_name Trap

enum ActivationTypes{enemy_entered, timer, activation}
@export var spawn_scene_on_activation: PackedScene
@export var activation_type: ActivationTypes = ActivationTypes.enemy_entered
signal activation_signal
## Setup trap to start
func setup():
	match activation_type:
		ActivationTypes.enemy_entered:
			pass
		ActivationTypes.timer:
			activation_signal.connect(activate)
		ActivationTypes.activation:
			pass
## Carryout the functionality of the trap on activation
func activate():
	if spawn_scene_on_activation:
		var scene = spawn_scene_on_activation.instantiate()
		GameManager.instance.projectile_parent.add_child(scene)
		scene.global_position = global_position
		scene.setup()
func _on_area_entered(area: Area2D) -> void:
	if activation_type == ActivationTypes.enemy_entered:
		activate()
