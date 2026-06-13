extends GameInstance
## Images
const TILE1 = preload("uid://cdoowwkvlvfk0")

## Enemies
const DARKORB = preload("uid://cqip08xv6m5no")
const SKELETON = preload("uid://c0shj1jlhrlmv")
const CRAWLER = preload("uid://dqhvvhnltc7yh")
const GHOUL = preload("uid://cavkgqw85lhxw")
const GHOST = preload("uid://td8gxdry4xcs")
const TREE_SPIRIT = preload("uid://cb307rg4gvkxp")

## Enemy Events
## Bosses
const CORRUPT_TREE = preload("uid://c6x5kxiq3op78")
## Objects/Events
const EVIL_TREE = preload("uid://cgctjw83xmopn")
const GRAVE = preload("uid://cks1ybymewgsv")

## Update grave values dynamically, so keep a reference
var grave: EventSpawn
var tree: EventSpawn

## Overides
## Check for corrupt tree, if so, custom spawn
func spawn_boss(scene: PackedScene, pos: Vector2):
	if scene == CORRUPT_TREE:
		spawn_corrupt_tree(scene, pos)
	else:
		super(scene, pos)
## Find the tree closest to the player and replace it with a corrupt tree 
func spawn_corrupt_tree(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	## Get the closest tree event
	var chosen_tree: Event = null
	var tree_distance: float
	var tree_position: Vector2 = pos
	var done_first: bool = false
	for node in get_tree().get_nodes_in_group("event"):
		if node.event_name == "Evil Tree":
			if !done_first:
				done_first = true
				chosen_tree = node
				tree_distance = node.global_position.distance_to(character.global_position)
			else:
				var new_distance: float = node.global_position.distance_to(character.global_position)
				print("New: ", new_distance, " vs old: ", tree_distance)
				if new_distance < tree_distance:
					chosen_tree = node
					tree_position = chosen_tree.global_position
					tree_distance = new_distance
					print("set new tree, dostamce:", tree_distance )
	var boss = scene.instantiate()
	game_man.enemy_parent.add_child(boss)
	boss.global_position = tree_position
	if chosen_tree:
		print("killing tree: ", chosen_tree)
		chosen_tree.call_deferred("die")
	else:
		print("set no tree")
func _process(delta: float) -> void:
	super(delta)
func add_tiles():
	TILES.append(TILE1) 
func _ready() -> void:
	super()
	## Setup Variables
	default_min_enemies = 30
	default_max_enemies = 90
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
	win_time = 60 * 20
	enemy_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	## Setups Phases
	phases.append(SpawningPhase.new("1", 5, phase_one))
	phases.append(SpawningPhase.new("2", 600, phase_two))
	## Setup Events
	grave = EventSpawn.new(GRAVE, Vector2(30, 44), 1, -1, 1)
	## Try to spawn graves before trees
	grave.priority = 1
	tree = EventSpawn.new(EVIL_TREE, Vector2(30, 44), 0.5, -1, 15)
	events.append(grave)
	events.append(tree)
func phase_one():
	print("PHASE 1 - ")
	generic_phase_setup(1)
	enemies.append(EnemySpawn.new(DARKORB, 0.2, 1))
	enemies.append(EnemySpawn.new(SKELETON, 0.2, 1))
	enemies.append(EnemySpawn.new(CRAWLER, 0.2, 1))
	enemies.append(EnemySpawn.new(GHOUL, 0.2, 1))
	enemies.append(EnemySpawn.new(GHOST, 0.2, 1)) 
	enemies.append(EnemySpawn.new(TREE_SPIRIT, 0.2, 1))
	#bosses.append(BossSpawn.new(-1, -1, CORRUPT_TREE, true, -1, -1))
func phase_two():
	print("PHASE 2 - ")
	generic_phase_setup(2)
	enemies.append(EnemySpawn.new(DARKORB, 0.2, 1))
	enemies.append(EnemySpawn.new(SKELETON, 0.2, 1))
	enemies.append(EnemySpawn.new(CRAWLER, 0.2, 1))
	enemies.append(EnemySpawn.new(GHOUL, 0.2, 1))
	enemies.append(EnemySpawn.new(GHOST, 0.2, 1)) 
	enemies.append(EnemySpawn.new(TREE_SPIRIT, 0.2, 1))
	bosses.append(BossSpawn.new(-1, -1, CORRUPT_TREE, true, -1, -1))
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_three():
	print("PHASE 3 - ")
	generic_phase_setup(3)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_four():
	print("PHASE 4 - ")
	generic_phase_setup(4)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_five():
	print("PHASE 5 - ")
	generic_phase_setup(5)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_six():
	print("PHASE 6 - ")
	generic_phase_setup(6)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_seven():
	print("PHASE 7 - ")
	generic_phase_setup(7)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_eight():
	print("PHASE 8 - ")
	generic_phase_setup(8)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_nine():
	print("PHASE 9 - ")
	generic_phase_setup(9)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_ten():
	print("PHASE 10 - ")
	generic_phase_setup(10)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_eleven():
	print("PHASE 11 - ")
	generic_phase_setup(11)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_twelve():
	print("PHASE 12 - ")
	generic_phase_setup(12)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_thirteen():
	print("PHASE 13 - ")
	generic_phase_setup(13)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_fourteen():
	print("PHASE 14 - ")
	generic_phase_setup(14)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_fifteen():
	print("PHASE 15 - ")
	generic_phase_setup(15)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_sixteen():
	print("PHASE 16 - ")
	generic_phase_setup(16)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_seventeen():
	print("PHASE 17 - ")
	generic_phase_setup(17)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_eighteen():
	print("PHASE 18 - ")
	generic_phase_setup(18)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_nineteen():
	print("PHASE 19 - ")
	generic_phase_setup(19)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
func phase_twenty():
	print("PHASE 20 - ")
	generic_phase_setup(20)
	#enemies.append(EnemySpawn.new(, 0.2, 1))
