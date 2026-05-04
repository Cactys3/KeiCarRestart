extends SpawnObject
class_name Creation

enum MovementTypes{GivenDirection, NonMoving, NearestEnemy, RandomEnemy, RandomDirection}
@export var movement_type: MovementTypes = MovementTypes.NonMoving
@export var can_be_damaged: bool = true
@export var can_be_stunned: bool = true
@export var can_be_knockbacked: bool = true
## Flat Damage Reduction
@export var stance: float = 0
@export var knockback_modifier: float = 0
var game_man:
	get():
		return GameManager.instance
var stun_time_left: float = 0
var stunning: bool = false
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
	if stun_time_left > 0:
		stun_time_left -= delta
		stunning = true
	elif stunning:
		stunning = false
	
	if !stunning:
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

func damage(attack: Attack):
	if GameInstance.is_game_over || !can_be_damaged:
		return
	## Consider Stance
	var net_damage = attack.get_damage() - stance
	if GlobalStats.calculate_avoid_damage(UpgradeStatics.creation_dodge_buff):
		net_damage = 0
		game_man.CreationDodged.emit(self, attack)
	if net_damage > 0:
		game_man.CreationDamaged.emit(self, attack)
	## Consider Sheild
	if net_damage > 0 && game_man.shield > 0:
		if (game_man.shield > net_damage):
			game_man.shield -= net_damage
			net_damage = 0
		else:
			net_damage -= game_man.shield
			game_man.shield = 0
	## Consider HP
	if net_damage > 0:
		game_man.curr_hp -= net_damage
	## Stun currently prevents the player from inputting movements, this means that the currently velocity (including knockback) will apply fully for the duration of the stun
	if can_be_stunned && attack.stun != 0:
		stun_time_left += attack.get_stun()
		stunning = true
	## Knockback is applied fully for 1 frame as the player's own movement code then overwrites it quickly on the following frames.
	if can_be_knockbacked && attack.get_knockback() != 0:
		call_deferred("set", "velocity", (global_position - attack.position).normalized() * attack.get_knockback() * knockback_modifier)
	if game_man.curr_hp <= 0:
		game_man.CreationKilled.emit(self, attack)
		die()
	
	## This shit doesn't work for some fucked up reason when it's preloaded
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	dmg_text.setup_color(str(int(round(attack.get_damage()))), net_damage + 36, WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), Color.RED)
