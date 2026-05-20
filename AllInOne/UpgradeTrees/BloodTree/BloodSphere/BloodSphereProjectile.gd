extends Projectile

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)

## Extend to attempt to instantly proc bleed
func attack_body(body: Node2D, clone: bool) -> void:
	super(body, clone)
	# (bleed / bleed_threshhold) > (applied_bleed + 1)
	if body is Boss:
		## half of remaining bleed for bosses
		body.bleed += ((body.applied_bleed + 1) - (body.bleed / body.bleed_threshhold)) / 2
	elif body is Enemy:
		## all of remaining bleed for normal enemies
		#print_debug("Before: ", body.bleed)
		#print_debug("Required: ", (body.bleed / body.bleed_threshhold), " > ", (body.applied_bleed + 1))
		body.bleed += (body.applied_bleed + 1) - (body.bleed / body.bleed_threshhold)
		#print_debug("After: ", body.bleed)
	elif body is NonInteractableEvent:
		## half of remaining bleed for events?
		body.bleed += ((body.applied_bleed + 1) - (body.bleed / body.bleed_threshhold)) / 2
