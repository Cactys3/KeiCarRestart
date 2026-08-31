extends Node2D

@export var EnemyParent: Node2D
@onready var player: Character = get_tree().get_first_node_in_group("player")
@onready var xp = preload("res://Scenes/Misc/xp_blip.tscn")
@onready var search: LineEdit = $Search
@onready var all: GridContainer = $HBoxContainer/All

@onready var blood: GridContainer = $HBoxContainer/Blood
@onready var nerd: GridContainer = $HBoxContainer/Nerd
@onready var gun: GridContainer = $HBoxContainer/Gun
@onready var ghost: GridContainer = $HBoxContainer/Ghost
@onready var egg: GridContainer = $HBoxContainer/Egg
@onready var tank: GridContainer = $HBoxContainer/Tank
@onready var ranger: GridContainer = $HBoxContainer/Ranger
@onready var unset: GridContainer = $HBoxContainer/Unset

var buttons: Array[Button]
var game_man: GameManager:
	get():
		return GameManager.instance
func _ready() -> void:
	if search:
		search.text_changed.connect(change_search)
	for upgrade in ShopManager.upgrade_list.keys() + ["Add All Upgrades!"]:
		## add to specific grid
		if upgrade != "Add All Upgrades!":
			match ShopManager.upgrade_list[upgrade].upgrade_tree:
				UpgradeData.UpgradeTrees.blood:
					add_to_grid(upgrade, blood)
				UpgradeData.UpgradeTrees.nerd:
					add_to_grid(upgrade, nerd)
				UpgradeData.UpgradeTrees.gun:
					add_to_grid(upgrade, gun)
				UpgradeData.UpgradeTrees.ghost:
					add_to_grid(upgrade, ghost)
				UpgradeData.UpgradeTrees.egg:
					add_to_grid(upgrade, egg)
				UpgradeData.UpgradeTrees.tank:
					add_to_grid(upgrade, tank)
				UpgradeData.UpgradeTrees.ranger:
					add_to_grid(upgrade, ranger)
				_:
					add_to_grid(upgrade, unset)
		## Add to grid that has all upgrades
		#add_to_grid(upgrade, all)

func add_to_grid(upgrade: String, grid: GridContainer):
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
