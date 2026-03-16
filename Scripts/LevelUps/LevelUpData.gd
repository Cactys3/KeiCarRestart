extends Node
class_name LevelUpData

var money: int
var option_name: String = "default"
var image: Texture2D
var color: Color
var border_color: Color = Color.WHITE_SMOKE
var description: String = "Default Description"
var rarity: String
var level: int
var type: types
enum types{upgrade, special}
var equipment: Equipment 
## sets up the data using an Equipment
func set_equipment(new_equipment: Equipment, new_type: types):
	option_name = new_equipment.item_name
	image = new_equipment.item_image
	color = new_equipment.item_color
	border_color = new_equipment.border_color
	description = new_equipment.get_item_description()
	rarity = Equipment.get_rarity(new_equipment.item_rarity)
	level = new_equipment.level
	equipment = new_equipment
	type = new_type
	match(new_type):
		types.upgrade:
			option_name = option_name 
		_:
			option_name =  "misc: " + option_name
## sets up the data via parameters
func set_data(new_name: String, new_image: Texture2D, new_color: Color, new_border_color: Color, new_description: String, new_type: types):
	option_name = new_name
	image = new_image
	color = new_color
	border_color = new_border_color
	description = new_description
	type = new_type
## this level up optin was chosen, carry out the level up, this method is polymorph
func carryout_level_up():
	match(type):
		types.upgrade:
			carryout_new_upgrade()
		_:
			carryout_special()
func carryout_money():
	GameManager.instance.money += money
func carryout_special():
	carryout_money()
func carryout_new_upgrade():
	pass
## The meaty function that decides what the level up option will be 
static func get_random_level_up_option(other_options: Array[LevelUpData]) -> LevelUpData:
	var game_man: GameManager = GameManager.instance
	
	return get_upgrade_upgrade(other_options)
static func get_upgrade_upgrade(other_upgrades: Array[LevelUpData]) -> LevelUpData:
	var avoided_items: Array[Equipment] = []
	for upgrade in other_upgrades:
		if upgrade.type == types.upgrade:
			avoided_items.append(upgrade.equipment)
	var levelupdata: LevelUpData = LevelUpData.new()
	var item: Equipment 
	if avoided_items.is_empty():
		item = ShopManager.get_rand_upgrade()
	else:
		item = ShopManager.get_rand_upgrade_except(avoided_items)
	if item == null:
		printerr("Called get_item_level_upgrade() whilst had already made upgrade options for all avaliable components")
		## Fallback to just having duplicate options
		item = ShopManager.get_rand_upgrade()
	levelupdata.set_equipment(item, LevelUpData.types.upgrade)
	return levelupdata
## Returns RichText colorized based on rarity
func colorize(text: String, rarity: Equipment.item_rarities) -> String:
	var textcolor
	match rarity:
		Equipment.item_rarities.common:
			textcolor = Equipment.COMMON_COLOR.to_html(false)
		Equipment.item_rarities.rare:
			textcolor = Equipment.RARE_COLOR.to_html(false)
			text = tornado(text)
		Equipment.item_rarities.epic:
			textcolor = Equipment.EPIC_COLOR.to_html(false)
			text = pulse(text)
		Equipment.item_rarities.exclusive:
			textcolor = Equipment.EXCLUSIVE_COLOR.to_html(false)
			text = shake(text)
	text = "[color=%s]" % ("#" + textcolor) + text + "[/color]"
	#text = wave(text)
	#text = pulse(text)
	#text = tornado(text)
	#text = shake(text)
	text = "" + text + ""
	return text
func pulse(text: String) -> String:
	return "[pulse freq=2.0 color=#blue ease=-1.0]" + text + "[/pulse]"
func wave(text: String) -> String:
	return "[wave amp=5.0 freq=2.0 connected=1]" + text + "[/wave]"
func tornado(text: String) -> String:
	return "[tornado radius=2.0 freq=0.5 connected=1]" + text + "[/tornado]" 
func shake(text: String) -> String:
	return "[shake rate=20.0 level=5 connected=1]" + text + "[/shake]" 
func round2(num: float) -> String:
	return GlobalStats.round_to_digits(num, 5)
	#return round(num * pow(10, 2)) / pow(10, 2)
func get_type_name(given_type: int) -> String:
	match given_type:
		types.upgrade:
			return "New Item!"
		types.special:
			return "Special Upgrade!"
		_:
			return "ね。。。"
