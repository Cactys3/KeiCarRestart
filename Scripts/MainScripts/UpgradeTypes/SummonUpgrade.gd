extends SpawningUpgrade
## Adds functionality to Upgrade that adds a Summon which follows the player and damages enemies
class_name SummonUpgrade
## -1 means infinite
@export var max_spawns: int = -1
@export var spawn_on_activate: bool = true
var spawned: bool = false
var summons: Array[Summon]
var check_spawn_cd: float = 0
func _process(delta: float) -> void:
	super(delta)
	## Check if we should summon more summons (copies)
	if spawned && active:
		check_spawn_cd += delta
		if check_spawn_cd > 5:
			check_spawn_cd = 0
			spawn()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	player = new_player
	if spawn_on_activate:
		spawn()
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	despawn()
	super()
func spawn() -> bool:
	## Calculate total number we should spawn (do nothing if we have already spawned)
	var summons_to_spawn: int = int(1 + (Statics.summon_count_buff + additional_spawns) - summons.size())
	print("Spawning: ", summons_to_spawn)
	if max_spawns > -1:
		if summons.size() >= max_spawns:
			## Don't spawn more than allowed
			summons_to_spawn = 0
		elif summons.size() + summons_to_spawn >= max_spawns:
			## If we would go over the limit, spawn what is allowed under the limit
			summons_to_spawn = max_spawns - summons.size()
	if !can_spawn_multiple:
		## Make sure we only spawn one total
		if summons.size() >= 1:
			summons_to_spawn = 0
		else:
			summons_to_spawn = 1
	if summons_to_spawn > 0:
		## If we spawn, increase active spawn counter
		if super():
			summons_to_spawn -= 1
			Statics.active_summons += 1
			spawned = true
	if summons_to_spawn > 0:
		## Spawn for count left to spawn
		for i in summons_to_spawn:
			if super():
				Statics.active_summons += 1
				spawned = true
	return spawned
func despawn():
	Statics.active_summons -= 1
	spawned = false
	for summon in summons:
		summon.queue_free()
	summons.clear()
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	if object is Summon:
		object = object as Summon
		summons.append(object)
		print("player:", player.name)
		object.setup(player, get_attack_source())
		return super(object)
	return false
## Overrides
func get_spawning_position() -> Vector2:
	return game_man.player.global_position
func get_spawning_duration() -> float:
	return super() + Statics.summon_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.summon
