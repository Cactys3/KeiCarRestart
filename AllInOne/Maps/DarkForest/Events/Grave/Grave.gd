extends NonInteractableEvent

## Extend to spawn skeletons on a cooldown
const SKELETON = preload("uid://c0shj1jlhrlmv")
const spawn_cooldown: float = 10
var spawn_stopwatch: float = 7

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	if has_setup:
		if spawn_stopwatch >= spawn_cooldown && GameInstance.instance.can_spawn_more_enemies():
			## Only actually spawn if close enough to player
			if global_position.distance_to(GameManager.instance.player.global_position) < GameInstance.instance.enemy_max_distance_to_player:
				spawn()
			spawn_stopwatch = 0
		else:
			spawn_stopwatch += delta
## Spawn a skeleton on the grave 
func spawn():
	GameInstance.instance.spawn_enemy(SKELETON, global_position)
