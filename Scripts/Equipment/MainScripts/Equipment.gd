extends Node2D
class_name Equipment

@export_group("Information")
@export_placeholder("Name Go Here") var item_name: String = "unset"
@export_multiline var item_description: String = "default description"
@export var item_type: item_types
@export var item_color: Color = Color.DARK_SLATE_BLUE
@export var border_color: Color = Color.WHITE
@export var item_image: Texture2D 
var game_man: GameManager:
	get():
		return GameManager.instance
## Data Fields
var player: Character
## Generic Fields (always active)
## is this weapon or upgrade equipped
var active: bool = false
## unset, upgrade, projectile, weapon
enum item_types{unset, upgrade, projectile, weapon}
func _ready() -> void:
	flash()
## Flashing stuff
func flash():
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
## Returns type for the given item_types index
static func get_type(i: int) -> String:
	match(i):
		item_types.unset:
			return "unset"
		item_types.projectile:
			return "projectile"
		item_types.weapon:
			return "weapon"
		item_types.upgrade:
			return "upgrade"
	return "Type: " + str(i)
## enable and apply the functionality of this Equipment
func activate(new_player: Character):
	player = new_player
	active = true
## disable and halt the functionality of this Equipment
func deactivate():
	active = false
