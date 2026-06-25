extends GameInstance

## Images
const TILE_1 = preload("uid://6umpoqb01ijk")
const TILE_2 = preload("uid://c31b0ffovjscb")
const TILE_3 = preload("uid://bgs83x0xtiw2d")
const TILE_4 = preload("uid://tbrvycdmuhur")
const TILE_5 = preload("uid://bxl3s0tqhk86p")
const TILE_6 = preload("uid://ba73lakqdgl7j")
const IMAGES: Array[Texture] = [TILE_1, TILE_2, TILE_3, TILE_4, TILE_5, TILE_6]
## Enemies
const APPLE = preload("uid://c4cvxdvw51wwo")
const BANANA = preload("uid://8ob3x88ieoaf")
const CARROT = preload("uid://dge34p6um1pnd")
const CHERRIES = preload("uid://pt7m21s0mrd5")
const ORANGE = preload("uid://crmq3c7inbvea")
const PICKLE = preload("uid://ceglf6qhpnv2")
const WATERMELON = preload("uid://bj2y4iclkpjpa")
## Enemy Events

## Bosses

## Objects/Events

## Update grave values dynamically, so keep a reference

## Overides
func get_edge_tile(vector: Vector2) -> Node2D:
	return super(vector)
func add_tiles():
	super()
	for image in IMAGES:
		var tile = FlashFixSprite.new()
		tile.texture = image
		var packed_tile = PackedScene.new()
		packed_tile.pack(tile)
		TILES.append(packed_tile)

func _process(delta: float) -> void:
	super(delta)
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
	
	## Setup Events
	
	
	## Setups Phases
	phases.append(SpawningPhase.new("test", 60, phase_test))
	phases.append(SpawningPhase.new("1", 60, phase_one))
	phases.append(SpawningPhase.new("2", 60, phase_two))
	phases.append(SpawningPhase.new("3", 60, phase_three))
	phases.append(SpawningPhase.new("4", 60, phase_four))
	phases.append(SpawningPhase.new("5", 60, phase_five))
	phases.append(SpawningPhase.new("6", 60, phase_six))
	phases.append(SpawningPhase.new("7", 60, phase_seven))
	phases.append(SpawningPhase.new("8", 60, phase_eight))
	phases.append(SpawningPhase.new("9", 60, phase_nine))
	phases.append(SpawningPhase.new("10", 60, phase_ten))
	phases.append(SpawningPhase.new("11", 60, phase_eleven))
	phases.append(SpawningPhase.new("12", 60, phase_twelve))
	phases.append(SpawningPhase.new("13", 60, phase_thirteen))
	phases.append(SpawningPhase.new("14", 60, phase_fourteen))
	phases.append(SpawningPhase.new("15", 60, phase_fifteen))
	phases.append(SpawningPhase.new("16", 60, phase_sixteen))
	phases.append(SpawningPhase.new("17", 60, phase_seventeen))
	phases.append(SpawningPhase.new("18", 60, phase_eighteen))
	#phases.append(SpawningPhase.new("19", 60, phase_nineteen))
	#phases.append(SpawningPhase.new("20", 60, phase_twenty))

func generic_phase_setup(phase_num: int):
	super(phase_num)

func phase_test():
	print("PHASE TEST")
	generic_phase_setup(1)
	var event: EnemyEventSpawn = EnemyEventSpawn.new("Shape", ENEMY_SHAPE_EVENT, 1, true, 1)
	event.setup_shape(APPLE, 50, EnemyShapeSpawn.Shapes.star, 200, true)
	enemy_events.append(event)

func phase_one():
	print("PHASE 1")
	generic_phase_setup(1)
func phase_two():
	print("PHASE 2")
	generic_phase_setup(2)
func phase_three():
	print("PHASE 3")
	generic_phase_setup(3)
func phase_four():
	print("PHASE 4")
	generic_phase_setup(4)
func phase_five():
	print("PHASE 5")
	generic_phase_setup(5)
func phase_six():
	print("PHASE 6")
	generic_phase_setup(6)
func phase_seven():
	print("PHASE 7")
	generic_phase_setup(7)
func phase_eight():
	print("PHASE 8")
	generic_phase_setup(8)
func phase_nine():
	print("PHASE 9")
	generic_phase_setup(9)
func phase_ten():
	print("PHASE 10")
	generic_phase_setup(10)
func phase_eleven():
	print("PHASE 11")
	generic_phase_setup(11)
func phase_twelve():
	print("PHASE 12")
	generic_phase_setup(12)
func phase_thirteen():
	print("PHASE 13")
	generic_phase_setup(13)
func phase_fourteen():
	print("PHASE 14")
	generic_phase_setup(14)
func phase_fifteen():
	print("PHASE 15")
	generic_phase_setup(15)
func phase_sixteen():
	print("PHASE 16")
	generic_phase_setup(16)
func phase_seventeen():
	print("PHASE 17")
	generic_phase_setup(17)
func phase_eighteen():
	print("PHASE 18")
	generic_phase_setup(18)
func phase_nineteen():
	print("PHASE 19")
	generic_phase_setup(19)
func phase_twenty():
	print("PHASE 20")
	generic_phase_setup(20)
