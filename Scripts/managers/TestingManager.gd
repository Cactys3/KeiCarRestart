extends Node2D

@export var EnemyParent: Node2D
@onready var player: Character = get_tree().get_first_node_in_group("player")
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")
@onready var search: LineEdit = $Search
@onready var grid: GridContainer = $Grid
var buttons: Array[Button]
var game_man: GameManager:
	get():
		return GameManager.instance
func _ready() -> void:
	if search:
		search.text_changed.connect(change_search)
	if grid:
		for upgrade in ShopManager.upgrade_list.keys() + ["Add All Upgrades!"]:
			var button: Button = Button.new()
			grid.add_child(button)
			button.text = upgrade
			button.pressed.connect(add_upgrade.bind(upgrade))
			buttons.append(button)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		var list = ShopManager.get_rand_upgrades(1, GameManager.instance)
		if !list.is_empty():
			pass#GameManager.instance.add_upgrade(list[0])
	if Input.is_action_just_pressed("test_2"):
		GameInstance.instance.spawn_enemy(load("uid://cqip08xv6m5no"), player.global_position + Vector2(0, -150))
	if Input.is_action_just_pressed("test_3"):
		## Spawning Upgrades
		## Bleed
		pass
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOODY_NEEDLES))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOODY_MAGAZINE))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOODY_QUIVER))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOOD_TURRETS))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOOD_MECHANIC))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.BLOOD_SPHERE))
		## Ghostly
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.FEARY))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.GHOSTSPLOSION))
		#game_man.add_upgrade(ShopManager.get_upgrade(ShopManager.GHOSTLY_HELPER))
	if Input.is_action_just_pressed("test_4"):
		pass#game_man.curr_hp -= 10
	if Input.is_action_just_pressed("test_5"):
		pass#game_man.curr_hp += 1
	if Input.is_action_just_pressed("test_6"):
		pass#game_man.curr_hp += 10
	if Input.is_action_just_pressed("test_7"):
		pass#game_man.xp += game_man.xp_to_next_level + 1
	if Input.is_action_just_pressed("test_0"):
		pass#GameManager.instance.level_up.emit()
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
func add_upgrade(upgrade_name: String) -> void:
	if upgrade_name == "Add All Upgrades!":
		for upgrade in ShopManager.upgrade_list.keys():
			game_man.add_upgrade(ShopManager.get_upgrade(upgrade))
		
	else:
		game_man.add_upgrade(ShopManager.get_upgrade(upgrade_name))
func change_search(text: String) -> void:
	text = text.replace(" ", "")
	if text == "":
		for button in buttons:
			button.visible = true
	else:
		for button in buttons:
			if button.text.to_lower().replace(" ", "").contains(text):
				button.visible = true
			else:
				button.visible = false
