extends Node2D
## Must be inherited by a Map to function fully
## Handles: Losing/Winning Game, Stopwatch, Spawning Enemies, Bosses, Shops, Forges, Events, Map Tiles
class_name GameInstance
static var is_game_over = false
static var instance: GameInstance
var TITLE_SCENE
## Nodes
var character: Character
var camera: Camera2D
var game_man: GameManager
var ui_man: UIManager
var background_parent: Node2D
var event_foreground_parent: Node2D
var event_background_parent: Node2D
var enemy_parent: Node2D
var xp_parent: Node2D
var character_parent: Node2D
var ability_parent: Node2D
var weapon_parent: Node2D
## Misc
const MAP_BORDER_COLLISION = preload("uid://c0fcgkctqqqug")
## Images
const TileBlank = preload("uid://2f83wrm2po8i")
var TILES: Array[PackedScene] = []
## Specify [tile path, tile vector]
var preset_tiles: Dictionary = {}
## Events
## Specify [event scene, event coordinates]
var preset_events: Array[PresetEvent]
## Enemies
## Enemy Events
const ENEMY_SHAPE_EVENT = preload("uid://brpqburwthbfs")
## Bosses
## Proximity Events
const LOOT_CHEST = preload("uid://cll8qcsho5mrw")
const STAT_SCROLL = preload("uid://bqo1xj4v5qth7")
var events: Array[EventSpawn] # stores event objects of all spawnable events
var enemies: Array[EnemySpawn] # stores enemies to spawn 
var enemy_events: Array[EnemyEventSpawn]
var bosses: Array[BossSpawn] # stores bosses to spawn
var phases: Array[SpawningPhase] # stores the phases to spawn enemies in
var current_phase: SpawningPhase
## Drops
const ITEM_DROP = preload("uid://d3v2pdpqpmvpe")
## Powerup Drop
static var drop_chance_powerup: float = 0.01:
	get():
		if GameManager.instance:
			return calculate_powerup_drop_chance(drop_chance_powerup, GameManager.instance.luck)
		else:
			return calculate_powerup_drop_chance(drop_chance_powerup, 0)
static var next_enemy_drops_powerup: bool = false
var enemies_since_powerup: int = 0
var enemies_per_powerup: int = 150
## Component Drop
static var drop_chance_component: float = 0.01:
	get():
		if GameManager.instance:
			return calculate_component_drop_chance(drop_chance_component, GameManager.instance.luck)
		else:
			return calculate_component_drop_chance(drop_chance_component, 0)
static var next_enemy_drops_component: bool = false
var enemies_since_component: int = 0
var enemies_per_component: int = 150
## Forge Drop
static var next_enemy_drops_forge: bool = true
var enemies_since_forge: int = 0
var enemies_per_forge: int = 50
## Spawning Stuff
var win_time: float = 10
var total_stopwatch: float = 0
var enemy_stopwatch: float = 0
var enemy_cooldown: float = 1
var spawning_phase: int = -1
var active_events: Array[Event]
var map_height: int = 10 ## this many chunks tall
var map_width: int = 10 ## this many chunks wide
var x_infinite: bool = false
var y_infinite: bool = false
const spawn_area_size: float = 650
const spawn_deadzone_size: float = 425
## Event Tracking
static var loot_chests_purchased: int = 0
## Enemies
static var enemies_spawned: int = 0
static var enemies_killed: int = 0
static var enemies_alive: int = 0
static var min_enemies: int = 30
static var max_enemies: int = 90
## Fallback values for when min_enemies is changed
static var default_min_enemies: int = 30
## Fallback values for when max_enemies is changed
static var default_max_enemies: int = 90
static var enemy_max_distance_to_player: float = 1000 ## Max distance enemies cane from player before being freed
## Enemy Events
static var enemy_events_alive: int = 0
static var enemy_events_spawned: int = 0
## Bosses
static var bosses_spawned: int = 0
static var bosses_killed: int = 0
static var bosses_alive: int = 0
## kills until next boss spawn
var kills_needed: float = 50 
## kills aquired since last boss spawn
var kills_left: float = 0 
## Player Level, calculated in enemy health
var level: float:
	get():
		return game_man.level
## Chunks
var loaded_chunk_position: Vector2 = Vector2.ZERO
## Height of each tile/chunk (affects event spawns + art), default = 360
var chunk_y: float = 360
## Width of each tile/chunk (affects event spawns + art), default = 640
var chunk_x: float = 640
var chunk_grid: Vector2 = Vector2.ZERO
var chunk_rect: ColorRect
var chunks: Array[Sprite2D]
var loaded_chunk: Sprite2D
var chunks_dic: Dictionary
var chunk_list: Array[ChunkElement] = []
## Rounds
# have different 'events' that decide what enemies to spawn
var started: bool = false
var completed_ready: bool = false
# https://www.youtube.com/watch?v=0tPFpL977eY
func _ready() -> void:
	# Ensure only one instance exists
	if instance != null:
		printerr("Error: Only one instance of gamemanager is allowed in the scene!")
		queue_free() 
		return
	instance = self  
	completed_ready = true
## Sets up the GameInstance by giving parameter values (character should be resource so can change default values?)
func setup(new_character: Character, new_weapon: String, run_modifiers) -> void:
	character_parent.add_child(new_character)
	camera.reparent(new_character)
	TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	chunk_rect = ColorRect.new()
	call_deferred("connect_signals")
	setup_events()
	game_man.setup(new_character, new_weapon, camera)
	character = new_character
	add_tiles()
func connect_signals():
	game_man.EnemyKilled.connect(enemy_killed)
	game_man.BossKilled.connect(boss_killed)
## Adds all events for this map to events - Override
func setup_events(): 
	pass
var timer: float = 0
func _process(delta: float) -> void:
	if !completed_ready:
		return
	if is_game_over:
		## Lowkey still want to spawn these enemies because it's funny
		check_max_min_enemies()
		handle_chunks(character.global_position)
		return
	timer += delta
	if !instance:
		instance = self
	var pos = character.global_position 
	ui_man.set_fps(Engine.get_frames_per_second())
	## Do before spawning so we spawn the correct things
	handle_spawn_phases()
	## Spawn Things
	if game_man && game_man.paused == false:
		handle_stopwatch(delta)
		handle_enemy_spawning(delta, pos)
	## Chunks
	for chunk in chunk_list:
		if chunk.can_release(delta):
			chunk_list.erase(chunk)
	handle_chunks(pos)
	if total_stopwatch >= 1:
		check_max_min_enemies()
	## Creates MainMenu Scene and removes current Scene
func check_max_min_enemies():
	var calculated_min_enemies = GlobalStats.calculate_min_enemies(min_enemies, game_man.difficulty)
	var calculated_max_enemies = GlobalStats.calculate_max_enemies(max_enemies, game_man.difficulty)
	if enemies_alive > calculated_max_enemies:
		despawn_enemies(game_man.player.global_position, calculated_max_enemies - max_enemies)
	elif enemies_alive < calculated_min_enemies:
		spawn_backups(game_man.player.global_position, calculated_min_enemies - enemies_alive)
## Is enemy count under max enemy count
func can_spawn_more_enemies() -> bool:
	return enemies_alive < GlobalStats.calculate_max_enemies(max_enemies, game_man.difficulty)
func return_to_main_menu() -> void:
	## Save
	Save.save_file(TitleManager.file_slot)
	## Save GameTime
	var time_since_gametime_start_seconds: float = roundi((Time.get_ticks_msec() - TitleManager.start_gametime) / 1000)
	Save.update_runtime_data(TitleManager.file_slot, Save.Playtime, Save.get_runtime_data(TitleManager.file_slot, Save.Playtime) + time_since_gametime_start_seconds)
	TitleManager.start_gametime = 0
	## Change Scenes
	if TITLE_SCENE == null:
		TITLE_SCENE = load("res://Scenes/Main/TitleScene.tscn")
	get_tree().current_scene.queue_free()
	var new_instance = TITLE_SCENE.instantiate()
	get_tree().root.add_child(new_instance)
	get_tree().current_scene = new_instance
func handle_stopwatch(delta: float):
	total_stopwatch += delta
	ui_man.set_stopwatch(total_stopwatch)
	if total_stopwatch >= win_time:
		win()
## Handles spawning new chunks and calculating whats inside them
func handle_chunks(pos: Vector2):
	var refresh: bool = true
	## Check If Load New Chunk
	if !started:
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y)
		started = true
	elif pos.x >= loaded_chunk_position.x + (chunk_x / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x + chunk_x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x + 1, chunk_grid.y)
	elif pos.x <= loaded_chunk_position.x - (chunk_x / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x - chunk_x, loaded_chunk_position.y)
		chunk_grid = Vector2(chunk_grid.x - 1, chunk_grid.y)
	elif pos.y >= loaded_chunk_position.y + (chunk_y / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y + chunk_y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y + 1)
	elif pos.y <= loaded_chunk_position.y - (chunk_y / 2):
		loaded_chunk_position = Vector2(loaded_chunk_position.x, loaded_chunk_position.y - chunk_y)
		chunk_grid = Vector2(chunk_grid.x, chunk_grid.y - 1)
	else:
		refresh = false
	if refresh:
		#draw_new_visual()
		#print("refresh: " + str(chunk_grid))
		## Loop through chunks we are loading
		for offset in [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)]:
			var chunk = chunk_grid + offset
			if !chunks_dic.has(chunk):
				load_chunk(chunk)
			else:
				## If its been x seconds since loading/second passing a chunk, second pass it
				var still_waiting: bool = false
				for old_chunk in chunk_list:
					if old_chunk.chunk == chunk:
						still_waiting = true
				if !still_waiting:
					second_pass_chunk(chunk)
## Only spawn enemies / check to spawn bosses every so often
func handle_enemy_spawning(delta: float, pos: Vector2):
	enemy_stopwatch += delta
	if enemy_stopwatch > GlobalStats.calculate_spawning_cd(enemy_cooldown, game_man.difficulty):
		enemy_stopwatch = 0
		spawn_enemies(pos)
		spawn_bosses(pos)
		spawn_enemy_events(pos)
## Load a chunk of the map, spawn events in it, add to array
func load_chunk(chunk_id: Vector2):
	chunk_list.append(ChunkElement.new(chunk_id))
	var new_chunk: Node2D
	# if chunk is without of map bounds
	if check_bounds(chunk_id):
		new_chunk = get_edge_tile(chunk_id)
		spawn_map_border(chunk_id)
	else:
		new_chunk = get_tile(chunk_id)
		spawn_events(chunk_id, false) 
	background_parent.add_child(new_chunk)
	new_chunk.position = ((chunk_id) * Vector2(chunk_x, chunk_y))
	chunks.append(new_chunk)
	chunks_dic.get_or_add(chunk_id, new_chunk)
## Second pass over a chunk that's already loaded that we are walking towards
func second_pass_chunk(chunk_id: Vector2):
	chunk_list.append(ChunkElement.new(chunk_id))
	if !check_bounds(chunk_id):
		spawn_events(chunk_id, true)
## Checks if the chunk is out of bounds for this map (out of bounds = true)
func check_bounds(chunk_id: Vector2) -> bool:
	return (abs(chunk_id.x) > abs(map_width) && !x_infinite) || (abs(chunk_id.y) > abs(map_height) && !y_infinite)
func spawn_map_border(chunk_id: Vector2):
	var border = MAP_BORDER_COLLISION.instantiate()
	event_foreground_parent.add_child(border)
	border.global_position = ((chunk_id) * Vector2(chunk_x, chunk_y))
	print("Chunk: ", chunk_id, " Position: ", ((chunk_id) * Vector2(chunk_x, chunk_y)), " Result: ", border.global_position )
## Despawns the enemy that is farthest from position
func despawn_enemies(pos: Vector2, num: int):
	if num > 0:
		print("Too many enemies, Despawning " + str(num) + "!")
	var enemie: Array = get_tree().get_nodes_in_group("enemy")
	enemie.sort_custom(func(a, b): return a.global_position.distance_to(pos) > b.global_position.distance_to(pos))
	for i: int in num:
		if enemie.size() > 0:
			var enemy: Enemy = enemie[0]
			enemie.erase(enemy)
			remove_enemy(enemy)
## Removes enemy from game without triggering death things like gain xp/money
func remove_enemy(enemy: Enemy):
	#print("enemy too far away, -1")
	enemy.queue_free()
	enemies_alive -= 1
	enemies_spawned -= 1
## Spawns backup enemies until min_enemies is met
func spawn_backups(pos: Vector2, num: int):
	if num > 0:
		pass#print("Not enough enemies, Spawning " + str(num) + "! " + str(GlobalStats.calculate_min_enemies(min_enemies, game_man.difficulty)))
	var counter: int = 0
	var enemies_added: int = 0
	var initial_enemies: int = enemies_alive
	while(enemies_added < num && counter < 500):
		spawn_enemies(game_man.player.global_position)
		enemies_added = enemies_alive - initial_enemies
		counter += 1
## Spawns any events that should be spawned in newly created chunk
func spawn_events(chunk_id: Vector2, second_pass: bool):
	## Process events in priority order
	events.sort_custom(func(a, b): return a.priority > b.priority)
	for event in events:
		if event.can_spawn() && (!second_pass || event.can_spawn_in_second_pass):
			for i in event.max_per_tile:
				if randf() < event.spawn_chance:
					load_event(event.event, chunk_id)
					event.spawn_count += 1
	if !second_pass:
		for event in preset_events:
			if is_position_in_chunk(chunk_id, event.position):
				place_event(event.event, chunk_id, event.position)
## Goes through enemies in enemies and spawns based on data
func spawn_enemies(pos: Vector2):
	for enemy in enemies:
		if !can_spawn_more_enemies():
			print("can't spawn more enemies")
			break
		if enemy.can_spawn():
			for i in enemy.max_attempts:
				if randf() < enemy.spawn_chance:
					spawn_enemy(enemy.scene, random_position(pos))
## Goes through enemy events in enemy_events and spawns based on data
func spawn_enemy_events(pos: Vector2):
	for event in enemy_events:
		if event.can_spawn():
			if randf() < event.spawn_chance:
				spawn_enemy_event(event.scene, event, pos)
				event.curr_spawns += 1
## Goes through enemies in enemies and spawns based on data
func spawn_bosses(pos: Vector2):
	for boss in bosses:
		if boss.can_spawn():
			if boss.spawn_once_on_start:
				boss.spawn_once_on_start = false
				spawn_boss(boss.scene, random_position(pos))
			for i in boss.get_spawns(enemies_killed, total_stopwatch):
				spawn_boss(boss.scene, random_position(pos))
func load_event(new_event: EventData, chunk: Vector2) -> bool:
	## Calculate chunk and event values
	var center := Vector2(chunk.x * chunk_x, chunk.y * chunk_y)
	var half := Vector2(chunk_x, chunk_y) / 2.0
	var new_min := center - half 
	var new_max := center + half
	var half_size: Vector2 = new_event.event_size / 2.0
	var place_min: Vector2 = new_min + half_size
	var place_max: Vector2 = new_max - half_size
	#print("load_event: center=", center, " half=", half, " place_min=", place_min, " place_max=", place_max, " half_size=", half_size)
	# Check if event is too large for chunk, just return true and place it in the center
	if place_min.x > place_max.x || place_min.y > place_max.y:
		#print("load_event: event too large for chunk, placing at center")
		place_event(new_event, chunk, center - new_event.event_center_offset)
		return true
	## Idk how intensive x attempts is
	var attempts: int = 20
	for i in attempts:
		var candidate := Vector2(randf_range(place_min.x, place_max.x), randf_range(place_min.y, place_max.y))
		var candidate_rect := Rect2(candidate + new_event.event_center_offset - half_size, new_event.event_size)
		#print("load_event: attempt ", i, " candidate=", candidate, " candidate_rect=", candidate_rect)
		var overlaps := false
		## TODO: should really only check against events in this chunk or surrounding chunks
		for event in active_events:
			var existing_rect := Rect2(event.position + event.event_center_offset - event.event_size / 2.0, event.event_size)
			#print("load_event: checking against event=", event.name, " existing_rect=", existing_rect, " overlaps=", candidate_rect.intersects(existing_rect))
			if rects_overlap(candidate_rect, existing_rect):
				overlaps = true
				break
		if !overlaps:
			#print("load_event: placed at candidate=", candidate)
			place_event(new_event, chunk, candidate)
			return true
	print("load_event: failed to place after ", attempts, " attempts")
	return false
func place_event(new_event: EventData, chunk: Vector2, new_position: Vector2) -> Event:
	var event_scene: Event = new_event.create_event()
	event_scene.position = new_position
	event_background_parent.add_child(event_scene)
	event_scene.setup(total_stopwatch, level, chunk)
	active_events.append(event_scene)
	return event_scene
func draw_new_visual():
	chunk_rect.color = Color(0, 0, 0, 0)
	chunk_rect = ColorRect.new()
	chunk_rect.position = loaded_chunk_position - Vector2(chunk_x / 2, chunk_y / 2)
	chunk_rect.size = Vector2(chunk_x, chunk_y)
	chunk_rect.color = Color(1, 0, 0, .1)
	background_parent.add_child(chunk_rect)
func spawn_enemy(scene: PackedScene, pos: Vector2):
	enemies_alive += 1
	enemies_spawned += 1
	var enemy = scene.instantiate()
	enemy.initialize(total_stopwatch / 60, level, game_man.difficulty)
	enemy.visible = false
	game_man.enemy_parent.add_child(enemy)
	enemy.global_position = pos
	enemy.visible = true
func spawn_boss(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	var boss = scene.instantiate()
	boss.visible = false
	game_man.enemy_parent.add_child(boss)
	boss.global_position = pos
	boss.visible = true
func spawn_enemy_event(scene: PackedScene, enemy_event_spawn: EnemyEventSpawn, pos: Vector2):
	enemy_events_alive += 1
	enemy_events_spawned += 1
	var event = scene.instantiate()
	game_man.enemy_parent.add_child(event)
	enemy_event_spawn.initialize_event(event, self, pos)
func spawn_final_boss(scene: PackedScene, pos: Vector2):
	bosses_alive += 1
	bosses_spawned += 1
	var boss: Boss = scene.instantiate()
	boss.visible = false
	boss.global_position = pos
	game_man.enemy_parent.add_child(boss)
	boss.visible = true
	
	boss.death.connect(final_boss_death)
func final_boss_death(boss_position: Vector2):
	Save.unlock_achievement(Save.boss) ## TODO: ACHIEVEMENT - BOSS
func enemy_killed(enemy: Enemy, attack: Attack):
	enemies_alive -= 1
	enemies_killed += 1
	ui_man.set_kills(enemies_killed)
	#print("Killed: " + str(enemies_killed))
	if enemies_since_forge >= enemies_per_forge:
		enemies_since_forge = 0
		next_enemy_drops_forge = true
	if enemies_since_component >= enemies_per_component:
		enemies_since_component = 0
		next_enemy_drops_component = true
	if kills_left <= 0:
		kills_needed = kills_needed * 0.95
		kills_left = kills_needed
		#spawn_boss(TESTBOSS, random_position(game_man.player.position))
func boss_killed(enemy: Enemy, attack: Attack):
	bosses_killed += 1
	bosses_alive -= 1
	ui_man.bosses_killed_label.text = str(bosses_killed)
func enemy_event_killed():
	enemy_events_alive -= 1
func win():
	game_man.ui_man.pause(UIManager.PauseItem.new(Callable(), UIManager.PauseItem.PauseTypes.system, false, false, game_man.ui_man.top_level_labels_parent))
	is_game_over = true
	ui_man.toggle_you_win(true)
	await get_tree().create_timer(5, false).timeout
	Save.unlock_achievement(Save.win) ## TODO: ACHIEVEMENT - WIN
	return_to_main_menu()
func lose():
	## Disable stuff for ending text or cutscene or whatever
	is_game_over = true
	for upgrade in game_man.active_upgrades:
		## just disable (keep in inventory so we can do end of game stats summary or smth for equipped items)
		upgrade.deactivate()
	for weapon in game_man.weapon_list:
		## just disable (keep in inventory so we can do end of game stats summary or smth for equipped items)
		game_man.remove_weapon(weapon)
	ui_man.toggle_you_lose(true)
	await get_tree().create_timer(2, false).timeout
	ui_man.you_lose.text += ", buddy"
	await get_tree().create_timer(3, false).timeout
	Save.unlock_achievement(Save.lose) ## TODO: ACHIEVEMENT - LOSE
	return_to_main_menu()
static func random_position(player_pos: Vector2) -> Vector2:
	# Random radius between deadzone and circle radius
	var r = sqrt(randf()) * (spawn_area_size - spawn_deadzone_size) + spawn_deadzone_size
	# Return global position + random offset
	var angle = Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU))).normalized()
	var pos = player_pos + angle * r 
	return pos
func SpawningButtonPressed(b: bool) -> void:
	pass
## Spawns an ItemDrop for a random component at location
static func drop_item(equipment: Equipment, location: Vector2):
	var drop: ItemDrop = ITEM_DROP.instantiate()
	drop.setup_equipment(equipment)
	GameManager.instance.xp_parent.add_child(drop)
	drop.global_position = location
static func drop_chest(drop_title: String, handle_id: int, attachment_id: int, projectile_id: int, location: Vector2):
	pass
static func drop_powerup(location: Vector2):
	pass#var drop: ItemDrop = ITEM_DROP.instantiate() # TODO: make powerups
	#drop.setup_item(ShopManager.make_itemUI(component))
	#GameManager.instance.xp_parent.add_child(drop)
	#drop.global_position = location
## Calculates chance for enemy to drop a component
static func calculate_component_drop_chance(drop_chance: float, luck: float) -> float:
	## 20 luck means 1 percent higher chance
	return drop_chance + luck / 2000
## Calculates chance for enemy to drop a powerup
static func calculate_powerup_drop_chance(drop_chance: float, luck: float) -> float:
	## 20 luck means 1 percent higher chance
	return drop_chance + luck / 2000
static func rects_overlap(a: Rect2, b: Rect2) -> bool:
	return a.intersects(b, true) or a.encloses(b) or b.encloses(a)
func is_position_in_chunk(chunk: Vector2, pos: Vector2) -> bool:
	var x: bool = (pos.x >= chunk.x * chunk_x) && (pos.x <= (chunk.x * chunk_x) + chunk_x)
	if !x:
		return false
	var y: bool = (pos.y >= chunk.y * chunk_y) && (pos.y <= (chunk.y * chunk_y) + chunk_y)
	return y
## Overrides
func add_tiles():
	pass
## Check/Change Spawn Phases, setup enemies/events accordingly
func handle_spawn_phases():
	## Check if current phase continues
	if current_phase && current_phase.should_start_or_continue(total_stopwatch):
		return
	## Find new phase since current phase is completed
	for phase in phases:
		if phase.should_start_or_continue(total_stopwatch):
			current_phase = phase
			return
	## Didn't find a phase...?
## Gets tile by vector, or gets random - Override
func get_tile(vector: Vector2) -> Node2D:
	if preset_tiles.has(vector):
		return preset_tiles[vector]
	return get_rand_tile()
## Get tiles for the map's border
func get_edge_tile(vector: Vector2) -> Node2D:
	return TileBlank.instantiate()
## Gets random tile for map - Override
func get_rand_tile() -> Node2D:
	var num_of_tiles: int = TILES.size()
	if num_of_tiles <= 0:
		return TileBlank.instantiate()
	return TILES[randi_range(0, num_of_tiles - 1)].instantiate()
func generic_phase_setup_dont_clear(phase_num: int):
	spawning_phase = phase_num
func generic_phase_setup(phase_num: int):
	enemies.clear()
	enemy_events.clear()
	spawning_phase = phase_num
	min_enemies = default_min_enemies
	max_enemies = default_max_enemies
## Contains data for the data to consider each time enemies are spawned
class EnemySpawn: ## TODO: add in functionality to enemy spawn in a line across the screen? just make a scene with that tbh
	var scene: PackedScene
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	## number of attempts to try to spawn enemies at spawn chance
	var max_attempts: int = -1
	var ready: bool = false
	func _init(new_scene: PackedScene, new_spawn_chance: float, new_max_attempts: int) -> void:
		scene = new_scene
		spawn_chance = new_spawn_chance
		max_attempts = new_max_attempts
		ready = true
	## returns if enemy can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		return true
## Contains data for the data to consider each time enemies are spawned
class EnemyEventSpawn: ## TODO: add in functionality to enemy spawn in a line across the screen? just make a scene with that tbh
	var name: String = "default"
	var scene: PackedScene
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	var spawn_once: bool = false
	## Max number of spawns at one time
	var max_spawns: int = 1
	var curr_spawns: int = 0
	var ready: bool = false
	func _init(new_name: String, new_scene: PackedScene, new_spawn_chance: float, new_spawn_once: bool, new_max_spawns: int) -> void:
		name = new_name
		scene = new_scene
		spawn_chance = new_spawn_chance
		spawn_once = new_spawn_once
		max_spawns = new_max_spawns
		ready = true
	## returns if enemy can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		if curr_spawns > 0 && spawn_once:
			return false
		return curr_spawns < max_spawns
	func initialize_event(event: Node2D, instance: GameInstance, player_position: Vector2):
		## Position
		if spawn_on_player:
			event.global_position = player_position
			print("player: ", player_position, ", real: ", instance.character.global_position, ", event: ", event.global_position)
		else:
			event.global_position = GameInstance.random_position(player_position)
		## Setup
		event.initialize(instance.total_stopwatch, instance.level, self)
		if is_shape:
			event.setup(enemy, num_of_enemies, shape, shape_size)
	var is_shape: bool = false
	var enemy: PackedScene
	var num_of_enemies: int
	var shape: EnemyShapeSpawn.Shapes
	var shape_size: float
	var spawn_on_player: bool = false
	## Setup for EnemyShapeSpawns
	func setup_shape(new_enemy: PackedScene, new_num_of_enemies: int, new_shape: EnemyShapeSpawn.Shapes, new_shape_size: float, new_spawn_on_player: bool):
		is_shape = true
		enemy = new_enemy
		num_of_enemies = new_num_of_enemies
		shape = new_shape
		shape_size = new_shape_size
		spawn_on_player = new_spawn_on_player
## Contains data for a boss to spawn, determines when it will spawn/what makes it spawn
class BossSpawn:
	var scene: PackedScene
	## Number of times it can spawn max, per instance
	var max_spawns: int 
	var kills_per_spawn: int ## Number of enemy kills needed before spawning
	var time_per_spawn: float ## Amount of time needed between each spawn
	var spawn_once_on_start: bool ## If it will spawn once automatically 
	var enemies_killed: int
	var time_elapsed: float
	var ready: bool = false
	func _init(new_enemies_killed: int, new_time_elapsed: float, new_scene: PackedScene, new_spawn_once_on_start: bool, new_kills_per_spawn: int, new_time_per_spawn: float) -> void:
		enemies_killed = new_enemies_killed
		time_elapsed = new_time_elapsed
		scene = new_scene
		kills_per_spawn = new_kills_per_spawn
		time_per_spawn = new_time_per_spawn
		spawn_once_on_start = new_spawn_once_on_start
		ready = true
	func get_spawns(new_enemies_killed: int, new_time_elapsed: float) -> int:
		var ret: int = 0
		if kills_per_spawn > 0 && new_enemies_killed - enemies_killed >= kills_per_spawn:
			ret += 1
			enemies_killed += kills_per_spawn
		if time_per_spawn > 0 && new_time_elapsed - time_elapsed >= time_per_spawn:
			ret += 1
			time_elapsed += time_per_spawn
		return ret
	## returns if boss can spawn
	func can_spawn() -> bool:
		if !ready:
			return false
		return true
## Contains data for the data to consider each time events are spawned
class EventSpawn:
	## Higher priority means this event is attempted to be spawned first 
	var priority: float = 0
	var can_spawn_in_second_pass: bool = false
	var event: EventData
	## spawn chance from 0 to 1
	var spawn_chance: float = 0
	## number of events that can be created per map, -1 for infinite
	var max_spawns: int = -1
	## number of events that have been spawned
	var spawn_count: int = 0
	## max number of events per tile
	var max_per_tile: int = 1
	## Width and Height of the event (so events don't spawn inside each other)
	var event_size: Vector2
	var ready: bool = false
	func _init(new_event: EventData, new_size: Vector2, new_spawn_chance: float, new_max_spawns: int, new_max_per_tile: int) -> void:
		event = new_event
		event_size = new_size
		spawn_chance = new_spawn_chance
		max_spawns = new_max_spawns
		max_per_tile = new_max_per_tile
		ready = true
	## returns if another event can be spawned
	func can_spawn() -> bool:
		if !ready:
			return false
		if max_spawns == -1:
			return true
		return spawn_count < max_spawns
class SpawningPhase:
	var name: String = "default"
	var started: bool = false ## Has this phase started
	var completed: bool = false ## Has this phased completed
	var initial_time: float ## Time that the phase started
	var duration: float ## Time that the phase lasts
	var start_method: Callable ## Method to setup the phase
	func _init(new_name: String, new_duration: float, new_start_method: Callable):
		name = new_name
		duration = new_duration
		start_method = new_start_method
	func should_start_or_continue(time: float):
		if completed:
			return false
		if !started:
			started = true
			start_method.call()
			initial_time = time
			return true
		if (time - initial_time) > duration:
			completed = true
			return false
		return true
class PresetEvent:
	var event: EventData
	var position: Vector2
	func _init(new_event: EventData, new_position: Vector2):
		event = new_event
		position = new_position
class ChunkElement:
	## Holds one chunk ID and one countdown for second passing a chunk
	var chunk: Vector2
	## After like 15 seconds if we come back to the same chunk, do a second pass
	var countdown: float = 15
	func _init(new_chunk: Vector2):
		chunk = new_chunk
		## Release after x seconds after loaded/second passed
		countdown = 15
	## Process the countdown and return whether it's finished
	func can_release(delta: float) -> bool:
		countdown -= delta
		return countdown <= 0
## Saves data to the file
func save():
	Save.save_file(TitleManager.file_slot)
func quit():
	get_tree().quit()
