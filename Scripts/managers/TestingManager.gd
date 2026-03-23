extends Node2D

@export var EnemyParent: Node2D

@onready var player: Character = get_tree().get_first_node_in_group("player")


@export var shop: Panel
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		ShopManager.unlocked_upgrade_keys = ShopManager.upgrade_list.keys()
		GameManager.instance.add_upgrade(ShopManager.get_rand_upgrade().get_upgrade())
	if Input.is_action_just_pressed("test_2"):
		pass
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
