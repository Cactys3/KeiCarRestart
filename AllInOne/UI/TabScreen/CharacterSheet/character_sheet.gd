extends TextureRect
class_name CharacterSheet

var showing: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
## Hide and Show augment sheet
func _pull_tab_pressed():
	if showing:
		position += Vector2(size.x, 0)
	else:
		position += Vector2(-size.x, 0)
	showing = !showing
