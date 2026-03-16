extends Node2D
class_name Loot
const LOOT_CHEST_UI = preload("uid://bjggm4l8hm8ih")
var title: String
var setup_done: bool = false
var ui: Control
var entered: bool = false
var pause: UIManager.PauseItem = null
var equipment: Equipment

func _init() -> void:
	visible = false
func _ready() -> void:
	flash()
func flash():
	await get_tree().create_timer(0.05).timeout
	visible = true
func setup(new_equipment: Equipment):
	equipment = new_equipment
func _body_entered(body: Node2D) -> void:
	## If player enters proximity
	if body.is_in_group("player"):
		## Setup Chest UI
		ui = LOOT_CHEST_UI.instantiate()
		ui.button_pressed.connect(toggle_ui)
		ui.button_pressed.connect(unpause)
		GameManager.instance.ui_man.misc_parent.add_child(ui)
		ui.position = Vector2(-800, -400)
		ui.set_text(title, equipment.item_name)
		ui.set_images(equipment.item_image)
		ui.start()
		## try to move weapon to equipment, backup add it to inventory (equipment full)
		GameManager.instance.add_equipment(equipment)
		
		var ui_man = GameManager.instance.ui_man
		pause = UIManager.PauseItem.new(toggle_ui, UIManager.PauseItem.PauseTypes.ui, false, false, ui_man.misc_parent)
		ui_man.pause(pause)
		entered = true
func unpause():
	GameManager.instance.ui_man.unpause(pause)
func toggle_ui():
	if entered:
		ui.queue_free()
		entered = false
		queue_free()
