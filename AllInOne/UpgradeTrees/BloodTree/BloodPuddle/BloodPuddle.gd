extends Trap
## Anything that comes into contact gets bled
var bleed_to_apply: float = 2
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func activate(body: Node2D):
	super(body)
	var bleed = bleed_to_apply
	if parent:
		bleed += parent.bleed_apply
	## Try damage method, then try bleed var
	if body.has_method("damage"):
		status.applies_bleed = true
		var attack: Attack = Attack.new(Attack.AttackTypes.upgrade_trap, self, global_position, status, GlobalStats.StatsList.new(0), GlobalStats.StatsList.new(0))
		attack.slow = 15 # 15% ms slow
		attack.temporary_base_stats.set_stat(GlobalStats.BLEED_APPLY, bleed)
		attack.temporary_base_stats.set_stat(GlobalStats.DAMAGE, 12)
		body.damage(attack)
		print("Attacked success")
	if "bleed" in body:
		body.bleed += bleed
		print("var success")
