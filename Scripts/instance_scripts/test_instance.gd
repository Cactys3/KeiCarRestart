extends GameInstance

## Test map that includes random enemies I've made for testing

## Images

## Enemies

## Bosses

## Proximity Events
## Spawning Phases

func _ready() -> void:
	win_time = 60
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	phases.append(SpawningPhase.new("phase 1", 60, phase_one))

func _process(delta: float) -> void:
	super(delta)
## Overrides
func add_tiles():
	TILES.append(null) 
func handle_stopwatch(delta: float):
	super(delta)
func phase_one():
	#print("PHASE 1")
	spawning_phase = 1
	enemies.clear()
	enemies.append(EnemySpawn.new("", null, 0.3, 3))
	enemies.append(EnemySpawn.new("", null, 0.3, 3))
	enemies.append(EnemySpawn.new("", null, 0.3, 3))
	enemies.append(EnemySpawn.new("", null, 0.3, 3))

func handle_enemy_spawning(delta: float, pos: Vector2):
	super(delta, pos)
func setup_events(): 
	super()
