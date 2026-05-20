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
var data: UpgradeData
## sets up the data using an Equipment
func set_equipment(upgrade_data: UpgradeData, new_type: types):
	data = upgrade_data
	option_name = upgrade_data.upgrade_name
	image = upgrade_data.upgrade_image
	color = upgrade_data.upgrade_color
	description = upgrade_data.upgrade_description
	rarity = "N/A"
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
	GameManager.instance.add_upgrade(data)
## Returns 'count' of LevelUpData filled with a random valid upgrade
static func get_level_up_options(count: int) -> Array[LevelUpData]:
	var array: Array[LevelUpData] = []
	## Get the upgrade
	var upgrades = ShopManager.get_rand_upgrades(count, GameManager.instance)
	print_debug("so we want, ", count, " upgrades, but we only got, ", upgrades.size())
	for upgrade in upgrades:
		print_debug("Make leve of upgrade: ", upgrade.upgrade_name, ", ", upgrade.upgrade_description, ", ", upgrade.resource_path)
		var level_up: LevelUpData = LevelUpData.new()
		level_up.set_equipment(upgrade, LevelUpData.types.upgrade)
		array.append(level_up)
	return array 

### Old
#static func get_upgrade_upgrade(other_upgrades: Array[LevelUpData]) -> LevelUpData:
	#var avoided_items: Array[UpgradeData] = []
	#for upgrade in other_upgrades:
		#if upgrade.type == types.upgrade:
			#avoided_items.append(upgrade.equipment)
	#var levelupdata: LevelUpData = LevelUpData.new()
	#var item: UpgradeData 
	#if avoided_items.is_empty():
		#item = ShopManager.get_rand_upgrade()
	#else:
		#item = ShopManager.get_rand_upgrade_except(avoided_items)
	#if item == null:
		#printerr("Called get_item_level_upgrade() whilst had already made upgrade options for all avaliable components")
		### Fallback to just having duplicate options
		#item = ShopManager.get_rand_upgrade()
	#levelupdata.set_equipment(item, LevelUpData.types.upgrade)
	#return levelupdata

## Returns RichText colorized based on rarity
func colorize(text: String, rarity: Upgrade.UpgradeRarities) -> String:
	var textcolor
	match rarity:
		Upgrade.UpgradeRarities.Basic:
			textcolor = Upgrade.BASIC_COLOR.to_html(false)
		Upgrade.UpgradeRarities.Intermediate:
			textcolor = Upgrade.INTERMEDIATE_COLOR.to_html(false)
			text = tornado(text)
		Upgrade.UpgradeRarities.Advanced:
			textcolor = Upgrade.ADVANCED_COLOR.to_html(false)
			text = pulse(text)
		Upgrade.UpgradeRarities.Exclusive:
			textcolor = Upgrade.EXCLUSIVE_COLOR.to_html(false)
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
