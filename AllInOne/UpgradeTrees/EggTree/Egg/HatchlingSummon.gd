extends Summon
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
const EXTRA_FRAME: int = 7
const NEUTRAL_FRAME: int = 6
const BURN_FRAME: int = 0
const BLEED_FRAME: int = 4
const SHOCK_FRAME: int = 3
const WET_FRAME: int = 1
const POISON_FRAME: int = 2
const FROST_FRAME: int = 5
var status_type: EggUpgrade.Versions = EggUpgrade.Versions.neutral
## Sets the hatchling status type given the type
func set_type(type: EggUpgrade.Versions):
	status_type = type
	match type:
		EggUpgrade.Versions.neutral:
			anim.frame = NEUTRAL_FRAME
		EggUpgrade.Versions.burn:
			anim.frame = BURN_FRAME
		EggUpgrade.Versions.bleed:
			anim.frame = BLEED_FRAME
		EggUpgrade.Versions.frost:
			anim.frame = FROST_FRAME
		EggUpgrade.Versions.wet:
			anim.frame = WET_FRAME
		EggUpgrade.Versions.poison:
			anim.frame = POISON_FRAME
		EggUpgrade.Versions.shock:
			anim.frame = SHOCK_FRAME
		_:
			anim.frame = EXTRA_FRAME
			printerr("Trying to set Hatchling Summon Status Type but invalid type: ", type)
## Set the type of the dragon projectile we spawn
func shoot_projectile() -> Projectile:
	var ret = super()
	ret.set_type(status_type)
	return ret
