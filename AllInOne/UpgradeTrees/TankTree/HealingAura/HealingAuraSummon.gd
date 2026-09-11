extends Summon

@onready var outer: AnimatedSprite2D = $AnimatedSprite2D/Outer
@onready var inner: AnimatedSprite2D = $AnimatedSprite2D/Inner
@onready var middle: AnimatedSprite2D = $AnimatedSprite2D/Middle

var inner_speed: float = 5
var outer_speed: float = 5
var middle_speed: float = 5
var max_speed: float = 1
var min_speed: float = 0.01
func _ready() -> void:
	super()
	inner_speed = randf_range(min_speed, max_speed)
	outer_speed = randf_range(min_speed, max_speed)
	middle_speed = randf_range(min_speed, max_speed)
	randomize_sign(inner_speed)
	randomize_sign(outer_speed)
	randomize_sign(middle_speed)
func randomize_sign(value: float) -> float:
	var ret = value
	if randf() > 0.5:
		ret = value * -1
	return ret
func _process(delta: float) -> void:
	super(delta)
	outer.rotation += delta * outer_speed
	inner.rotation -= delta * inner_speed
	middle.rotation += delta * middle_speed
func start_venging():
	## Start attacking?
	pass
func start_scaling():
	## Scale?
	pass
## For sure has custom stuff
