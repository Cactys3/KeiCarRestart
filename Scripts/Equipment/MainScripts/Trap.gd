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



func _get_hp_stat():
	return super() + Statics.trap_hp_buff
func _get_stance_stat():
	return super() + Statics.trap_stance_buff
func _get_movespeed_stat():
	return super() + Statics.trap_movespeed_buff
func _get_xp_stat():
	return super() + Statics.trap_xp_buff
func _get_mogul_stat():
	return super() + Statics.trap_mogul_buff
func _get_luck_stat():
	return super() + Statics.trap_luck_buff
func _get_damage_stat():
	return super() + Statics.trap_damage_buff
func _get_range_stat():
	return super() + Statics.trap_range_buff
func _get_weight_stat():
	return super() + Statics.trap_weight_buff
func _get_attackcooldown_stat():
	return super() + Statics.trap_attackcooldown_buff
func _get_reloadtime_stat():
	return super() + Statics.trap_reloadtime_buff
func _get_velocity_stat():
	return super() + Statics.trap_velocity_buff
func _get_ammo_stat():
	return super() + Statics.trap_ammo_buff
func _get_count_stat():
	return super() + Statics.trap_count_buff
func _get_piercing_stat():
	return super() + Statics.trap_piercing_buff
func _get_duration_stat():
	return super() + Statics.trap_duration_buff
func _get_size_stat():
	return super() + Statics.trap_size_buff
func _get_critdamage_stat():
	return super() + Statics.trap_critdamage_buff
func _get_ghostly_stat():
	return super() + Statics.trap_ghostly_buff
func _get_regen_stat():
	return super() + Statics.trap_regen_buff
func _get_magnetize_stat():
	return super() + Statics.trap_magnetize_buff
func _get_lifesteal_stat():
	return super() + Statics.trap_lifesteal_buff
func _get_shield_stat():
	return super() + Statics.trap_shield_buff
func _get_difficulty_stat():
	return super() + Statics.trap_difficulty_buff
func _get_revies_stat():
	return super() + Statics.trap_revies_buff
func _get_thorns_stat():
	return super() + Statics.trap_thorns_buff
func _get_inaccuracy_stat():
	return super() + Statics.trap_inaccuracy_buff
