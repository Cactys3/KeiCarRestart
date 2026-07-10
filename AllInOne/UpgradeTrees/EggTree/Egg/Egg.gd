extends SummonUpgrade
## A Specific Upgrade that summons an egg
class_name EggUpgrade
## This upgrade:
## Spawn the egg to orbit the player
## Set the timer to appear above the orbiting egg
## Once the timer is done, replace the egg with the summon
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)
func apply_buff():
	super()
func remove_buff():
	super()
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

const HATCHLING = preload("uid://dw7ki5c7gs7cs")
# 4 minutes
var total_time_duration: float = 4 * 60
var time_until_hatch: float = 4 * 60
var hatched: bool = false
var egg: Summon
var hatchling: Summon
var twin: Summon
## Core Modifed Stats
var additional_size: float = 0
var additional_damage: float = 0
var additional_velocity: float = 0
var additional_count: float = 0
var additional_status: float = 0
var additional_attackspeed: float = 0
## Extra Stats
var additional_inaccuracy: float = 0
var additional_reloadtime: float = 0
var additional_luck: float = 0
var additional_critdamage: float = 0
var additional_piercing: float = 0
var additional_ammo: float = 0
var additional_movespeed: float = 0
## Status Versions 
enum Versions {neutral, burn, bleed, frost, wet, poison, shock}
var version: Versions = Versions.neutral
## Is it twins?
var twins: bool = false

func activate(new_player: Character):
	super(new_player)
	## Setup cooldown ui and make it 
	setup_cooldown_ui()

var update_stopwatch: float = 0
func _process(delta: float) -> void:
	super(delta)
	## Every x sec, update cd UI TODO: egg also breaks if cooldownUI braeks, unlink them
	if active && !hatched && cooldownUI != null:
		time_until_hatch -= delta
		if update_stopwatch > 0.1:
			update_stopwatch = 0
			if time_until_hatch >= 0:
				cooldownUI.set_progress(time_until_hatch / total_time_duration)
			else:
				## Call cooldown finished and free the cooldownui so it doesn't repeat
				emit_cooldown_finished()
				cooldownUI.queue_free()
		else:
			update_stopwatch += delta

func initialize_object(object: Node2D) -> bool:
	var ret: bool = super(object)
	if ret:
		if object.spawn_name == "Egg":
			egg = object
			egg.egg_upgrade = self
	return ret

func delay_hatching(time: float):
	cooldownUI_stopwatch += time

func emit_cooldown_finished():
	## Emit signal so other upgrades that affect it can do their stuff
	super()
	## Then hatch and make the summon with that info
	hatch()

func hatch():
	hatched = true
	## Eat the egg
	if !egg:
		printerr("no egg?? but hatching!!")
	var spawn_position = egg.global_position
	summons.erase(egg)
	egg.queue_free()
	egg = null
	## Make the hatchling(s)
	hatchling = make_hatchling(spawn_position)
	if twins:
		twin = make_hatchling(spawn_position + Vector2(30, 30)) ## Offset

func make_hatchling(spawn_position: Vector2) -> Summon:
	var summon: Summon = HATCHLING.instantiate()
	summons.append(summon)
	get_spawn_parent().add_child(summon)
	summon.global_position = spawn_position
	summon.setup(player, get_attack_source())
	## Add additional stats
	summon._size += additional_size
	summon._damage += additional_damage
	summon._velocity += additional_velocity
	summon._count += additional_count
	#summon._status += additional_status
	summon._attackcooldown += additional_attackspeed
	summon._inaccuracy += additional_inaccuracy
	summon._reloadtime += additional_reloadtime
	summon._luck += additional_luck
	summon._critdamage += additional_critdamage
	summon._piercing += additional_piercing
	summon._ammo += additional_ammo
	summon._movespeed += additional_movespeed
	summon.set_type(version)
	return summon
