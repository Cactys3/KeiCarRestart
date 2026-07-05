extends SpawnObject
class_name Ability

@export var ability_cooldown: float = 10
@export var cooldown_starts_on_ability_finish: bool = false
@export var has_buff: bool = false
@export var buff_duration: float = 5
@export_group("Visuals")
@export var child_to_player: bool = false
@export var turn_to_mouse: bool = false
## -1 is instant
@export var turn_speed: float = -1
var duration_stopwatch: float = 0
var is_setup: bool = false
var dead: bool = false
var buff_applied: bool = false
var buff_time_left: float = 0
var buff_stopwatch: float = 0
var on_cooldown: bool = false
var paused_until_ability_finish: bool = false
var cooldown_stopwatch: float = 0
## Given manually by character
var data: AbilityData
var player: Character
signal AbilityFinished(ability: Ability)
## Make sure to override to set correct type
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
func get_attack_source() -> Attack.AttackSources:
	return Attack.AttackSources.ability
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	if child_to_player:
		global_position = player.global_position
	super(delta)
	if is_setup:
		## Turn towards mouse
		if turn_to_mouse:
			if turn_speed > 0:
				rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).angle(), turn_speed * delta)
			else:
				look_at(get_global_mouse_position())
		## Ability Cooldown
		if on_cooldown:
			if cooldown_stopwatch > 0:
				cooldown_stopwatch -= delta
			else:
				on_cooldown = false
		## Buff Duration
		if has_buff && buff_applied:
			if buff_stopwatch > 0:
				buff_stopwatch -= delta
			else:
				remove_buff()
func setup(new_player: Character):
	is_setup = true
	player = new_player
	if child_to_player:
		GameInstance.instance.ability_parent.add_child(self)#new_player.add_child(self)
	else:
		GameInstance.instance.ability_parent.add_child(self)
	setup_collisions(true, false)
func remove_buff():
	buff_applied = false
func apply_buff():
	buff_applied = true
## Input corresponding to this ability was pressed, check if can activate
func InputPressed() -> bool:
	if is_setup:
		if !on_cooldown && !paused_until_ability_finish:
			trigger()
			if cooldown_starts_on_ability_finish:
				paused_until_ability_finish = true
			else:
				on_cooldown = true
				cooldown_stopwatch = ability_cooldown
			return true
	else:
		printerr("InputPressed for ability but not setup")
	return false
## Succesfully trigger ability
func trigger():
	ability_finished()
func ability_finished():
	AbilityFinished.emit(self)
	if paused_until_ability_finish:
		paused_until_ability_finish = false
		on_cooldown = true
		cooldown_stopwatch = ability_cooldown
func can_attack(body: Node2D) -> bool:
	return super(body)
## Set Abilities layer true
func setup_collisions(is_player_weapons: bool, is_enemy_weapons: bool):
	var area = get_node(".") as Area2D
	area.set_collision_layer_value(14, true)
	super(is_player_weapons, is_enemy_weapons)
