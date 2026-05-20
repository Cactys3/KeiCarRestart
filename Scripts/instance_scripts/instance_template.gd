extends GameInstance
## Images
const TILE1 = preload("uid://6umpoqb01ijk")
const TILE2 = preload("uid://c31b0ffovjscb")
const TILE3 = preload("uid://bgs83x0xtiw2d")
const TILE4 = preload("uid://tbrvycdmuhur")
const TILE5 = preload("uid://bxl3s0tqhk86p")
const TILE6 = preload("uid://ba73lakqdgl7j")
## Enemies
## Enemy Events
## Bosses
## Events
func _process(delta: float) -> void:
	super(delta)
func add_tiles():
	TILES.append(TILE1) 
	TILES.append(TILE2) 
	TILES.append(TILE3) 
	TILES.append(TILE4) 
	TILES.append(TILE5) 
func _ready() -> void:
	super()
	## Setup Variables
	default_min_enemies = 30
	default_max_enemies = 90
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
	win_time = 60*20
	enemy_cooldown = 1
	spawning_phase = -1
	map_height = 3 ## this many chunks tall
	map_width = 3 ## this many chunks wide
	## Setups Phases
	#phases.append(SpawningPhase.new("", 60, phase_one))
	## Setup Basic Events
	#events.append(EventSpawn.new("", , 0.25, -1, 1))
	## Setup Interactable Events
	#events.append(EventSpawn.new("", , 0.3, -1, 3))
	## Setup Main Events
func phase_one():
	print_debug("PHASE 1 - ")
	generic_phase_setup(1)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_two():
	print_debug("PHASE 2 - ")
	generic_phase_setup(2)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_three():
	print_debug("PHASE 3 - ")
	generic_phase_setup(3)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_four():
	print_debug("PHASE 4 - ")
	generic_phase_setup(4)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_five():
	print_debug("PHASE 5 - ")
	generic_phase_setup(5)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_six():
	print_debug("PHASE 6 - ")
	generic_phase_setup(6)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_seven():
	print_debug("PHASE 7 - ")
	generic_phase_setup(7)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_eight():
	print_debug("PHASE 8 - ")
	generic_phase_setup(8)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_nine():
	print_debug("PHASE 9 - ")
	generic_phase_setup(9)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_ten():
	print_debug("PHASE 10 - ")
	generic_phase_setup(10)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_eleven():
	print_debug("PHASE 11 - ")
	generic_phase_setup(11)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_twelve():
	print_debug("PHASE 12 - ")
	generic_phase_setup(12)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_thirteen():
	print_debug("PHASE 13 - ")
	generic_phase_setup(13)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_fourteen():
	print_debug("PHASE 14 - ")
	generic_phase_setup(14)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_fifteen():
	print_debug("PHASE 15 - ")
	generic_phase_setup(15)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_sixteen():
	print_debug("PHASE 16 - ")
	generic_phase_setup(16)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_seventeen():
	print_debug("PHASE 17 - ")
	generic_phase_setup(17)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_eighteen():
	print_debug("PHASE 18 - ")
	generic_phase_setup(18)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_nineteen():
	print_debug("PHASE 19 - ")
	generic_phase_setup(19)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
func phase_twenty():
	print_debug("PHASE 20 - ")
	generic_phase_setup(20)
	#enemies.append(EnemySpawn.new("", , 0.2, 1))
