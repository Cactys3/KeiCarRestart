extends Control
@export var label: RichTextLabel
@export var accept: Button 
@export var decline: Button 
signal decision_made
var decision: bool = false
func setup(text: String):
	label.text = text
	accept.pressed.connect(accept_method)
	decline.pressed.connect(decline_method)
func accept_method():
	decision = true
	decision_made.emit()
func decline_method():
	decision = false
	decision_made.emit()
