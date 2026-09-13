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
	update_buff()
	GameManager.instance.StatsChanged.connect(update_buff)
## For sure has custom stuff

var size_buff: float = 0
var damage_buff: float = 0
func update_buff():
	## Each 100 hp over the first 100 is 100% more size
	var new_size_buff: float = max(1, player.max_health - 75) / 100
	var new_damage_buff: float = (player.regen / 2) + (player.max_shield / 8)
	print(player.regen, " / 2 + ", player.max_shield, " / 20")
	## Apply New Buff
	_size += (new_size_buff - size_buff)
	_damage += (new_damage_buff - damage_buff)
	print("Size Change: ", (new_size_buff - size_buff), " Damage Change: ", new_damage_buff, " - ", damage_buff)
	## Set Vars
	size_buff = new_size_buff
	damage_buff = new_damage_buff
	## Stats Changed
	stats_changed()
