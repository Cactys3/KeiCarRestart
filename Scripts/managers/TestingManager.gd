extends Node2D

@export var EnemyParent: Node2D

@onready var player: Character = get_tree().get_first_node_in_group("player")
const flub = preload("uid://ckhl8l6bj1bvv")
const grub = preload("uid://dojorw4mt1dsw")
const jub = preload("uid://b4ljdiupnggrv")
const thub = preload("uid://drjvl1sgqrjuy")

@export var shop: Panel
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		get_tree()
	
	if Input.is_action_just_pressed("test_2"):
		var j: Enemy = jub.instantiate()
		var g: Enemy = grub.instantiate()
		var f: Enemy = flub.instantiate()
		var t: Enemy = thub.instantiate()
		EnemyParent.add_child(j)
		EnemyParent.add_child(g)
		EnemyParent.add_child(f)
		EnemyParent.add_child(t)
		j.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		g.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		f.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
		t.global_position = Vector2(randf_range(-500, 500), randf_range(-500, 500))

	if Input.is_action_just_pressed("test_3"):
		pass
	if Input.is_action_just_pressed("test_4"):
		pass
	if Input.is_action_just_pressed("test_5"):
		pass
	if Input.is_action_just_pressed("test_6"):
		pass
	if Input.is_action_just_pressed("test_7"):
		pass
	if Input.is_action_just_pressed("test_0"):
		GameManager.instance.level_up.emit()
	
	## Formerly in Game Manager:
	
	var game_man: GameManager = GameManager.instance
	
	if Input.is_action_just_pressed("ability1"):
		pass
		#game_man.create_level_up_instance()
	
	if Input.is_action_just_pressed("ability2"):
		pass
	
	if Input.is_action_just_pressed("ability3"):
		game_man.money += 10
	
	if Input.is_action_just_pressed("test_5"):
		pass
	
	if Input.is_action_just_pressed("test_6"):
		pass
