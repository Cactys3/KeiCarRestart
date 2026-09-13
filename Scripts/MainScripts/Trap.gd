extends SpawnObject
class_name Trap

enum ActivationTypes{entered, timer, activation}
@export var sound_on_activate: Sound
@export var spawn_scene_on_activation: PackedScene
@export var activation_type: ActivationTypes = ActivationTypes.entered
@export var activate_for_enemies: bool = true
@export var activate_for_bosses: bool = true
@export var activate_for_events: bool = false
@export var damage_enemy_on_entered_activation: bool = false
@export var die_on_activation: bool = false
var parent: StatsObject
var source: Attack.AttackSources = Attack.AttackSources.unset
var piercing: float = 0
var dead: bool = false
var stopwatch: float = 0
signal activation_signal
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.trap
func get_attack_source() -> Attack.AttackSources:
	return source
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	check_duration(delta)
## Setup trap to start
func setup(new_parent: StatsObject, attack_source: Attack.AttackSources):
	parent = new_parent
	source = attack_source
	match activation_type:
		ActivationTypes.entered:
			pass
		ActivationTypes.timer:
			activation_signal.connect(activate)
		ActivationTypes.activation:
			pass
	setup_collisions(true, false)
## Carryout the functionality of the trap on activation
func activate(body: Node2D):
	print("activate")
	if damage_enemy_on_entered_activation && can_attack(body): ## TODO: Added can_attack here, check if that works for every trap
		attack_body(body)
		hit_enemy(body)
	if sound_on_activate:
		AudioManager.instance.play(sound_on_activate, global_position)
	if spawn_scene_on_activation:
		var scene = spawn_scene_on_activation.instantiate()
		GameManager.instance.projectile_parent.add_child(scene)
		scene.global_position = global_position
		scene.setup()
	if die_on_activation:
		die()
func _on_entered(body: Node2D) -> void:
	print("on enter")
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
	if can_die_from_collision && piercing > piercing_stat:
		die()
func check_duration(delta: float):
	if can_die_from_duration && stopwatch >= duration_stat:
		die()
	else:
		stopwatch += delta
## Set Traps layer true
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(11, true)
	super(is_player_weapons, is_enemy_weapons)
