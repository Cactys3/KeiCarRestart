extends Trap

var is_aoe: bool = false
var steel_skin_target: Node2D
var steel_skin_knockback: float

## Attack everyone if AOE, else only target
func attack_body(body: Node2D):
	print("Attacking AOE: ", is_aoe)
	if is_aoe || body == steel_skin_target:
		append_attack_element(body)
		attack_counter += 1
		post_damage_return(body.damage(make_attack(1)))
func _process(delta: float) -> void:
	super(delta)
	check_duration(delta)
func check_duration(delta: float):
	if stopwatch >= 0.5:
		die()
	else:
		stopwatch += delta
