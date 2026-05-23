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
	if Input.is_action_just_pressed(InputManager.INPUT_9):
		GameInstance.instance.spawn_enemy(load("uid://cqip08xv6m5no"), player.global_position + Vector2(0, -150))
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
