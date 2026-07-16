extends Ability
## Make sure to override to set correct type
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.melee
func _ready() -> void:
	collider.disabled = true
	super()
func _process(delta: float) -> void:
	super(delta)

## Melee flurry of punches
## Hits once per small flurry with a low knockback hit
## After those are done, hits with a final high knockback hit

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
var punches: Array[String] = ["1", "2", "3", "4", "5"]
var pause: String = "pause"
var heavy_punch: bool = false

## TODO: implement punch speed based on attackspeed_stat
## TODO: ability cd based on melee cooldown buff?
func trigger():
	for punch in punches:
		AttackedObjects.clear()
		## If last punch, heavy punch
		if punches.find(punch) == punches.size() - 1:
			heavy_punch = true
		else:
			heavy_punch = false
		## Punch
		anim.play(punch)
		collider.disabled = false
		await anim.animation_finished
		## Pause
		anim.play(pause)
		collider.disabled = true
		await anim.animation_finished
	## Super emits AbilityFinished
	super()
func handle_attack(attack: Attack):
	## Last punch does heavy knockback
	if heavy_punch:
		attack.temporary_base_stats.add_to_stat(GlobalStats.DAMAGE, 15)
		attack.temporary_base_stats.add_to_stat(GlobalStats.WEIGHT, 10)
	super(attack)
