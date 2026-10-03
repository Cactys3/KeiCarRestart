extends Control

const CLOUD_1 = preload("uid://du0g6gxohtm51")
const CLOUD_2 = preload("uid://c1vnw47p8p4xv")
const CLOUD_3 = preload("uid://btaqyw8somiw1")
const CLOUD_4 = preload("uid://codg8v0gmuqja")

var spawning: bool = true
var spawning_cd: float = 1
var stopwatch: float = 0
var spawn_chance: float = 0.6
var despawn_distance: float = 500
var height_range: float = 500

var clouds: Array[duple]

func _process(delta: float) -> void:
	if spawning:
		if stopwatch > spawning_cd:
			stopwatch = 0
			if randf() > spawn_chance:
				spawn()
		else:
			stopwatch += delta
		for cloud in clouds:
			cloud.cloud.position += Vector2(cloud.speed * delta, 0)
	else:
		for cloud in clouds:
			cloud.queue_free()
		clouds.clear()

## TODO: Spawn initial clouds on the screen (so some already exist when loading in)

func spawn():
	var cloud: TextureRect = TextureRect.new()
	add_child(cloud)
	cloud.texture = get_rand_texture()
	cloud.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	cloud.size += Vector2(randf_range(250, 500), randf_range(250, 500))
	clouds.append(duple.new(cloud, randf_range(100, 200)))
	cloud.position += Vector2(0, randf_range(-height_range, height_range))

func get_rand_texture() -> Texture2D:
	match randi_range(0, 3):
		0:
			return CLOUD_1
		1:
			return CLOUD_2
		2:
			return CLOUD_3
		3:
			return CLOUD_4
		_:
			return CLOUD_1

class duple:
	var cloud: TextureRect
	var speed: float
	func _init(n_cloud: TextureRect, n_speed: float):
		cloud = n_cloud
		speed = n_speed
