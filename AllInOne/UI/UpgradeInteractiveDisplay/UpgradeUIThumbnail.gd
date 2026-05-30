extends DraggableUI

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
var upgrade_data: UpgradeData
var lines: Array[PointLine]
var set_line_up: bool = false
var stopwatch: float = 0

func setup(data: UpgradeData):
	upgrade_data = data
	label.text = data.upgrade_name
	if data.upgrade_image:
		texture_rect.texture = data.upgrade_image
func set_line(line: Line2D, index: int):
	lines.append(PointLine.new(line, index))
func _process(delta: float) -> void:
	super(delta)
	if !lines.is_empty() && visible:
		stopwatch += delta
		if stopwatch > 0.5:
			stopwatch = 0
			for line in lines:
				line.line.set_point_position(line.point, position)
		

class PointLine:
	var line: Line2D
	var point: int
	func _init(new_line: Line2D, new_point: int) -> void:
		line = new_line
		point = new_point
