extends SpawnObject
class_name Trap

enum ActivationTypes{entered, timer, activation}
@export var sound_on_activate: Sound
@export var spawn_scene_on_activation: PackedScene
@export var activation_type: ActivationTypes = ActivationTypes.entered
@export var activate_for_enemies: bool = true
@export var activate_for_bosses: bool = true
@export var activate_for_events: bool = false
@export var can_die_from_duration: bool = true
@export var can_die_from_piercing: bool = true
var parent: StatsObject
var lifetime: float = 10
var piercing: float = 0
var dead: bool = false
var stopwatch: float = 0
signal activation_signal
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	if can_die_from_duration && stopwatch >= lifetime:
		die()
	else:
		stopwatch += delta
## Setup trap to start
func setup(new_parent: StatsObject):
	parent = new_parent
	lifetime = duration_stat + 1 ## +1 for making sure it appears for testing 
	match activation_type:
		ActivationTypes.entered:
			pass
		ActivationTypes.timer:
			activation_signal.connect(activate)
		ActivationTypes.activation:
			pass
## Carryout the functionality of the trap on activation
func activate(body: Node2D):
	if sound_on_activate:
		AudioManager.instance.play(sound_on_activate, global_position)
	if spawn_scene_on_activation:
		var scene = spawn_scene_on_activation.instantiate()
		GameManager.instance.projectile_parent.add_child(scene)
		scene.global_position = global_position
		scene.setup()
func _on_entered(body: Node2D) -> void:
	if activation_type == ActivationTypes.entered:
		if body is Enemy && activate_for_enemies:
			activate(body)
		elif body is Boss && activate_for_enemies:
			activate(body)
		elif body is NonInteractableEvent && activate_for_events:
			activate(body)
func die():
	if !dead:
		dead = true
		queue_free()
func hit_enemy(enemy: Node2D):
	piercing += 1
	if can_die_from_piercing && piercing > piercing_stat:
		die()
