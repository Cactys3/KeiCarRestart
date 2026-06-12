extends Control

# 	- [ ] Grab all upgrades and make a click-draggable icon with their name and image
#	- [ ] put all beginner up high, intermediate, etc lower and lower
#	- [ ] Grab all connection points between upgrades and create lines between prereqs

@export var spawn_type: SpawnTypes = SpawnTypes.Random
enum SpawnTypes {Random, Rows}
@export_group("Rows Spawning Info")
@export var basic_starting_y: float = 0
@export var intermediate_starting_y: float = 100
@export var advanced_starting_y: float = 200
@export var exclusive_starting_y: float = 300
@export var basic_x: float = 0
@export var intermediate_x: float = 0
@export var advanced_x: float = 0
@export var exclusive_x: float = 0
@export var x_offset: float = 50

const UPGRADE_UI_THUMBNAIL = preload("uid://kayvs8ppkfos")
var upgrades: Dictionary[UpgradeData, DraggableUI] = {}
func _ready() -> void:
	var list: Array[UpgradeData] = ShopManager.upgrade_list.values()
	for upgrade in list:
		if upgrade.upgrade_name != "":
			var ui = UPGRADE_UI_THUMBNAIL.instantiate()
			add_child(ui)
			ui.setup(upgrade)
			if spawn_type == SpawnTypes.Random:
				ui.global_position = Vector2(
				randf_range(global_position.x, global_position.x + size.x - ui.size.x),
				randf_range(global_position.y, global_position.y + size.y - ui.size.y))
			else:
				match upgrade.upgrade_rarity:
					Upgrade.UpgradeRarities.Basic:
						ui.position = Vector2(basic_x, basic_starting_y)
						basic_x = double_and_flip(basic_x)
					Upgrade.UpgradeRarities.Intermediate:
						ui.position = Vector2(intermediate_x, intermediate_starting_y)
						intermediate_x = double_and_flip(intermediate_x)
					Upgrade.UpgradeRarities.Advanced:
						ui.position = Vector2(advanced_x, advanced_starting_y)
						advanced_x = double_and_flip(advanced_x)
					Upgrade.UpgradeRarities.Exclusive:
						ui.position = Vector2(exclusive_x, exclusive_starting_y)
						exclusive_x = double_and_flip(exclusive_x)
			upgrades[upgrade] = ui
			#print("Added Upgrade: ", upgrade.upgrade_name, ", At: ", ui.position)
	for upgrade in list:
		for prereq in upgrade.prerequisite_upgrades:
			#print("Trying to find prereq:",  prereq.upgrade_name)
			var start = upgrades.get(prereq).position
			var end = upgrades.get(upgrade).position
			var line: Line2D = Line2D.new()
			add_child(line)
			line.add_point(start, 0)
			line.add_point(end, 1)
			line.width = 3
			#print("Make line from: ", prereq.upgrade_name, " to: ", upgrade.upgrade_name)
			upgrades.get(prereq).set_line(line, 0)
			upgrades.get(upgrade).set_line(line, 1)
			line.gradient = Gradient.new()
			var color_one: Color = prereq.upgrade_color
			var color_two: Color = upgrade.upgrade_color
			if !color_one:
				color_one = Color.WHITE
			if !color_two:
				color_two = Color.WHITE
			line.gradient.colors = [color_one, color_two]

func double_and_flip(value: float) -> float:
	var s = sign(value) * -1
	if s == 0:
		s = 1
	value = (abs(value) + abs(x_offset)) * s
	return value
