extends Node2D
class_name EnemyShapeSpawn

enum Shapes {circle, square, triangle, line, star}

var stopwatch: float
var level: float
var event_spawn: GameInstance.EnemyEventSpawn

func initialize(current_stopwatch: float, current_level: float, my_event_spawn: GameInstance.EnemyEventSpawn):
	stopwatch = current_stopwatch
	level = current_level
	event_spawn = my_event_spawn
## Spawns enemy with count num_of_enemies in shape at shape_size
func setup(enemy: PackedScene, num_of_enemies: int, shape: Shapes, shape_size: float):
	match shape:
		Shapes.circle:
			setup_circle(enemy, num_of_enemies, shape_size)
		Shapes.square:
			setup_square(enemy, num_of_enemies, shape_size)
		Shapes.triangle:
			setup_triangle(enemy, num_of_enemies, shape_size)
		Shapes.line:
			setup_line(enemy, num_of_enemies, shape_size)
		Shapes.star:
			setup_star(enemy, num_of_enemies, shape_size)

func setup_circle(enemy: PackedScene, num_of_enemies: int, shape_size: float):
	for i in num_of_enemies:
		var angle: float = (TAU / num_of_enemies) * i
		var curr_position: Vector2 = Vector2(cos(angle), sin(angle)) * shape_size
		GameInstance.instance.spawn_enemy(enemy, curr_position + global_position)

func setup_square(enemy: PackedScene, num_of_enemies: int, shape_size: float):
	# shape_size = half-side length, so perimeter = 8 * shape_size
	# Distribute enemies evenly along all 4 sides
	var perimeter: float = shape_size * 8.0
	var spacing: float = perimeter / num_of_enemies
	for i in num_of_enemies:
		var t: float = spacing * i
		var curr_position: Vector2
		var side_len: float = shape_size * 2.0
		# Walk around the square: top, right, bottom, left
		if t < side_len:
			curr_position = Vector2(-shape_size + t, -shape_size)
		elif t < side_len * 2.0:
			curr_position = Vector2(shape_size, -shape_size + (t - side_len))
		elif t < side_len * 3.0:
			curr_position = Vector2(shape_size - (t - side_len * 2.0), shape_size)
		else:
			curr_position = Vector2(-shape_size, shape_size - (t - side_len * 3.0))
		GameInstance.instance.spawn_enemy(enemy, curr_position + global_position)

func setup_triangle(enemy: PackedScene, num_of_enemies: int, shape_size: float):
	# Equilateral triangle, shape_size = circumradius
	# 3 vertices equally spaced on a circle, starting from the top
	var vertices: Array[Vector2] = []
	for v in 3:
		var angle: float = -PI / 2.0 + (TAU / 3.0) * v
		vertices.append(Vector2(cos(angle), sin(angle)) * shape_size)
	var side_len: float = vertices[0].distance_to(vertices[1])
	var perimeter: float = side_len * 3.0
	var spacing: float = perimeter / num_of_enemies
	for i in num_of_enemies:
		var t: float = spacing * i
		var curr_position: Vector2
		if t < side_len:
			curr_position = vertices[0].lerp(vertices[1], t / side_len)
		elif t < side_len * 2.0:
			curr_position = vertices[1].lerp(vertices[2], (t - side_len) / side_len)
		else:
			curr_position = vertices[2].lerp(vertices[0], (t - side_len * 2.0) / side_len)
		GameInstance.instance.spawn_enemy(enemy, curr_position + global_position)

func setup_line(enemy: PackedScene, num_of_enemies: int, shape_size: float):
	# shape_size = half-length of the line, random angle
	var angle: float = randf() * TAU
	var direction: Vector2 = Vector2(cos(angle), sin(angle))
	for i in num_of_enemies:
		# Spread enemies from -shape_size to +shape_size along the line
		var t: float = (float(i) / max(num_of_enemies - 1, 1)) * 2.0 - 1.0
		var curr_position: Vector2 = direction * (t * shape_size)
		GameInstance.instance.spawn_enemy(enemy, curr_position + global_position)

func setup_star(enemy: PackedScene, num_of_enemies: int, shape_size: float):
	# 5-pointed star: alternating outer (shape_size) and inner (shape_size * 0.4) radii
	var points: int = 5
	var inner_size: float = shape_size * 0.4
	var vertices: Array[Vector2] = []
	for v in points * 2:
		var radius: float = shape_size if v % 2 == 0 else inner_size
		var angle: float = -PI / 2.0 + (TAU / (points * 2)) * v
		vertices.append(Vector2(cos(angle), sin(angle)) * radius)
	# Compute total perimeter across all 10 edges
	var edge_lengths: Array[float] = []
	var perimeter: float = 0.0
	for v in vertices.size():
		var edge_len: float = vertices[v].distance_to(vertices[(v + 1) % vertices.size()])
		edge_lengths.append(edge_len)
		perimeter += edge_len
	var spacing: float = perimeter / num_of_enemies
	for i in num_of_enemies:
		var t: float = spacing * i
		var curr_position: Vector2
		# Walk along edges until we find which edge t falls on
		for v in vertices.size():
			if t <= edge_lengths[v]:
				curr_position = vertices[v].lerp(vertices[(v + 1) % vertices.size()], t / edge_lengths[v])
				break
			t -= edge_lengths[v]
		GameInstance.instance.spawn_enemy(enemy, curr_position + global_position)
