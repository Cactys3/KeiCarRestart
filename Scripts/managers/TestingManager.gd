extends Node2D

@export var EnemyParent: Node2D
@onready var player: Character = get_tree().get_first_node_in_group("player")
@export var shop: Panel
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")
var game_man: GameManager:
	get():
		return GameManager.instance

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		var list = ShopManager.get_rand_upgrades(1, GameManager.instance)
		if !list.is_empty():
			GameManager.instance.add_upgrade(list[0])
	if Input.is_action_just_pressed("test_2"):
		GameInstance.instance.spawn_enemy(load("uid://cqip08xv6m5no"), player.global_position + Vector2(0, -150))
	if Input.is_action_just_pressed("test_3"):
		game_man.curr_hp -= 1
	if Input.is_action_just_pressed("test_4"):
		game_man.curr_hp -= 10
	if Input.is_action_just_pressed("test_5"):
		game_man.curr_hp += 1
	if Input.is_action_just_pressed("test_6"):
		game_man.curr_hp += 10
	if Input.is_action_just_pressed("test_7"):
		game_man.xp += game_man.xp_to_next_level
	if Input.is_action_just_pressed("test_0"):
		GameManager.instance.level_up.emit()
	if Input.is_action_just_pressed("ability1"):
		pass
	if Input.is_action_just_pressed("ability2"):
		pass
	if Input.is_action_just_pressed("ability3"):
		pass
	if Input.is_action_just_pressed("test_5"):
		pass
	if Input.is_action_just_pressed("test_6"):
		pass
