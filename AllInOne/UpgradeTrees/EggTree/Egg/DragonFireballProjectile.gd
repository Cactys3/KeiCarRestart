extends Projectile
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
## Sets the hatchling status type given the type
func set_type(type: EggUpgrade.Versions):
	if !status:
		status = StatusEffects.new()
	match type:
		EggUpgrade.Versions.neutral:
			anim.frame = NEUTRAL_FRAME
		EggUpgrade.Versions.burn:
			status.applies_burn = true
			anim.frame = BURN_FRAME
		EggUpgrade.Versions.bleed:
			status.applies_bleed = true
			anim.frame = BLEED_FRAME
		EggUpgrade.Versions.frost:
			status.applies_frost = true
			anim.frame = FROST_FRAME
		EggUpgrade.Versions.wet:
			status.applies_wet = true
			anim.frame = WET_FRAME
		EggUpgrade.Versions.poison:
			status.applies_poison = true
			anim.frame = POISON_FRAME
		EggUpgrade.Versions.shock:
			status.applies_shock = true
			anim.frame = SHOCK_FRAME
		_:
			anim.frame = EXTRA_FRAME
			printerr("Trying to set Hatchling Summon Status Type but invalid type: ", type)
