extends Control

@onready var grow_bar: GrowBar = $Container/GrowBar


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		pass
	if Input.is_action_just_pressed("test_2"):
		grow_bar.set_value(grow_bar.curr_value + 100)
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
