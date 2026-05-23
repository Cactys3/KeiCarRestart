extends Node
class_name InputManager
## Maintain inputs in a dictioanry: "input_string_name" : 'object_that_has_input_rn or null'
## Dish out inputs via a 'get_free()'
## Swap inputs via a 'swap_input' that calls the corresponding methods on each 'object_that_has_input_rn' objects to change their inputs
## Free inputs via a 'free_input()' 

## Prompts
static var primary_prompt: String = "Mouse1"
static var secondary_prompt: String = "Mouse2"
static var tertiary_prompt: String = "Mouse3"
static var input_1_prompt: String = "1"
static var input_2_prompt: String = "2"
static var input_3_prompt: String = "3"
static var input_4_prompt: String = "4"
static var input_5_prompt: String = "5"
static var input_6_prompt: String = "6"
static var input_7_prompt: String = "7"
static var input_8_prompt: String = "8"
static var input_9_prompt: String = "9"
static var ability_1_prompt: String = "Q"
static var ability_2_prompt: String = "E"
static var ability_3_prompt: String = "R"
static var left_prompt: String = "A"
static var right_prompt: String = "D"
static var up_prompt: String = "W"
static var down_prompt: String = "S"
static var cancel_prompt: String = "Backspace"
static var accept_prompt: String = "Enter"
static var gameplay_menu_prompt: String = "Tab"
static var settings_menu_prompt: String = "Escape"
static var prompt_dict: Dictionary[String, String] = {
	PRIMARY: primary_prompt,
	SECONDARY: secondary_prompt,
	TERTIARY: tertiary_prompt,
	INPUT_1: input_1_prompt,
	INPUT_2: input_2_prompt,
	INPUT_3: input_3_prompt,
	INPUT_4: input_4_prompt,
	INPUT_5: input_5_prompt,
	INPUT_6: input_6_prompt,
	INPUT_7: input_7_prompt,
	INPUT_8: input_8_prompt,
	INPUT_9: input_9_prompt,
	ABILITY_1: ability_1_prompt,
	ABILITY_2: ability_2_prompt,
	ABILITY_3: ability_3_prompt,
	LEFT: left_prompt,
	RIGHT: right_prompt,
	UP: up_prompt,
	DOWN: down_prompt,
	CANCEL: cancel_prompt,
	ACCEPT: accept_prompt,
	GAMEPLAY_MENU: gameplay_menu_prompt,
	SETTINGS_MENU: settings_menu_prompt}


## Main Combat Inputs, Primary Fire, Secondary Optional Fire, Tertiary Optional Fire
const PRIMARY: String = "M1" 
const SECONDARY: String = "M2"
const TERTIARY: String = "M3"
## Inputs assigned to certian things
const INPUT_1: String = "Input1"
const INPUT_2: String = "Input2"
const INPUT_3: String = "Input3"
const INPUT_4: String = "Input4"
const INPUT_5: String = "Input5"
const INPUT_6: String = "Input6"
const INPUT_7: String = "Input7"
const INPUT_8: String = "Input8"
const INPUT_9: String = "Input9"
## Abilities
const ABILITY_1: String = "Ability1"
const ABILITY_2: String = "Ability2"
const ABILITY_3: String = "Ability3"
## Directions
const LEFT: String = "left"
const RIGHT: String = "right"
const UP: String = "up"
const DOWN: String = "down"
## Escapes the current menu, Chooses no on the curent option, etc
const CANCEL: String = "Cancel"
## Accepts the current option, Selects the current option
const ACCEPT: String = "Accept"
## Opens the Gameplay Menu
const GAMEPLAY_MENU: String = "GameplayMenu"
## Opens the Settings Menu (if not interpreted as a CANCEL input)
const SETTINGS_MENU: String = "SettingsMenu"
## Array of Inputs for assigning to Equipment
static var AssignedInputs: Array[AssignedInput] = [
	AssignedInput.new(INPUT_1, null),
	AssignedInput.new(INPUT_2, null),
	AssignedInput.new(INPUT_3, null),
	AssignedInput.new(INPUT_4, null),
	AssignedInput.new(INPUT_5, null),
	AssignedInput.new(INPUT_6, null),
	AssignedInput.new(INPUT_7, null),
	AssignedInput.new(INPUT_8, null),
	AssignedInput.new(INPUT_9, null),]
## Assigns and returns a free input or "" if none are free
static func assign_input(equipment: Equipment) -> AssignedInput:
	for input in AssignedInputs:
		if input.InputOwner == null:
			input.InputOwner = equipment
			equipment.assign_input(input.InputTag)
			## input UI
			GameManager.instance.ui_man.hud.add_assigned_input_ui(equipment.item_image, get_prompt(input.InputTag), get_slot(input.InputTag))
			print("Assigned Input: ", input.InputTag)
			return input
	return null
## Attempt to remove input from its owner, return success
static func free_input(input: String) -> bool:
	var found: bool = false
	var assigned_input: AssignedInput
	for i in AssignedInputs:
		if i.InputTag == input:
			assigned_input = i
			found = true
			break
	if found:
		if assigned_input.InputOwner != null:
			if assigned_input.InputOwner.remove_input():
				assigned_input.InputOwner = null
				return true
			return false
		printerr("Trying to free input, but was already free: ", assigned_input.InputTag)
		return true
	printerr("Called free_input with an invalid input: ", input)
	return false
## Attempt to swap two inputs' owners, return success
static func swap_inputs(input_one: AssignedInput, input_two: AssignedInput) -> bool:
	if input_one.InputOwner != null && input_two.InputOwner != null:
		var temp_owner: Equipment = input_one.InputOwner
		input_one.InputOwner = input_two.InputOwner
		input_two.InputOwner = temp_owner
		return true
	return false

static func get_prompt(input: String) -> String:
	return prompt_dict[input]
static func get_slot(input: String) -> int:
	match input:
		ABILITY_1:
			return 0
		ABILITY_2:
			return 1
		ABILITY_3:
			return 2
		INPUT_1:
			return 1 + 2
		INPUT_2:
			return 2 + 2
		INPUT_3:
			return 3 + 2
		INPUT_4:
			return 4 + 2
		INPUT_5:
			return 5 + 2
		INPUT_6:
			return 6 + 2
		INPUT_7:
			return 7 + 2
		INPUT_8:
			return 8 + 2
		INPUT_9:
			return 9 + 2
	return 0

## An Input Class that can be assigned to an Equipment
class AssignedInput:
	var InputTag: String = ""
	var InputOwner: Equipment = null
	func _init(new_tag: String, new_owner: Equipment) -> void:
		InputTag = new_tag
		InputOwner = new_owner
