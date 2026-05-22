extends Event
class_name NonInteractableEvent
@export_category("Defense")
@export var hurtbox: Area2D
@export var can_be_damaged: bool = false
@export var can_be_knockbacked:bool = false
@export var can_be_stunned:bool = false
@export var multiply_hp_by_minute: bool = true
@export var drop_on_death: PackedScene
@export var xp_on_death: int = 10
@export var hp: float = 100
@export var can_have_status_effect: bool = false
@export var immune_to_burn: bool = false
@export var immune_to_frost: bool = false
@export var immune_to_poison: bool = false
@export var immune_to_bleed: bool = false
@export var immune_to_shock: bool = false
@export var immune_to_wet: bool = false
@export var burn_threshhold: float = 1
@export var frost_threshhold: float = 1
@export var poison_threshhold: float = 1
@export var bleed_threshhold: float = 1
@export var shock_threshhold: float = 1
@export var wet_threshhold: float = 1
@export_category("Offense")
@export var hitbox: Area2D
@export var can_damage: bool = false
@export var only_damage_player: bool = true
@export var cooldown: float = 5
@export var attack_damage: float = 10
@export var stun: float = 0
@export var slow: float = 0
@export var knockback: float = 0
@export var buildup: float = 0
@export var status: StatusEffects = StatusEffects.new()
@export_category("Etc")
@export var foreground: Array[Node2D]
@export var background: Array[Node2D]
@export var anims: Array[AnimatedSprite2D]
@export var each_frame_is_alternative_art: bool = false
@export var randomly_roll_alternative_art: bool = false
@export var particles: EntityParticles = null

var curr_health: float = 1000
var stopwatch: float = 100
##
var burn: float = 0
var frost: float = 0
var poison: float = 0
var bleed: float = 0
var shock: float = 0
var wet: float = 0
##
var is_burning: bool = false:
	get():
		return burn >= burn_threshhold
var is_frosted: bool = false:
	get():
		return applied_frost > 0
var is_poisoned: bool = false:
	get():
		return poison >= poison_threshhold
## is_bleeding means that this enemy has has a blood proc in the past (and it hasn't been removed)
var is_bleeding: bool = false:
	get():
		## Has applied bleed
		return applied_bleed > 0
var is_shocked: bool = false:
	get():
		return shock >= shock_threshhold
var is_wet: bool = false:
	get():
		return wet >= wet_threshhold
# count for how many times status have been applied
var applied_burn: int = 0
var applied_frost: int = 0
var applied_poison: int = 0
var applied_bleed: int = 0
var applied_shock: int = 0
var applied_wet: int = 0
##
var frost_movespeed_reduction: float = 0
var shock_defense_reduction: float = 0

func _ready() -> void:
	super()
	if hurtbox:
		hurtbox.area_entered.connect(_hurtbox_entered)
		hurtbox.body_entered.connect(_hurtbox_entered)
	if hitbox:
		hitbox.area_entered.connect(_hitbox_entered)
		hitbox.body_entered.connect(_hitbox_entered)
	if multiply_hp_by_minute:
		curr_health = hp * max(1, time / 60)
	else:
		curr_health = hp
	if each_frame_is_alternative_art && randomly_roll_alternative_art:
		if anims[0]:
			var frame = randi_range(0, anims[0].sprite_frames.get_frame_count(anims[0].animation))
			for anim in anims:
				if anim:
					anim.frame = randi_range(0, frame)
func _process(delta: float) -> void:
	if can_damage && stopwatch <= cooldown:
		stopwatch += delta
	global_position = round(global_position)
	if can_have_status_effect:
		status_process(delta)
func setup(new_time: float, new_level: float, new_chunk: Vector2):
	super(new_time, new_level, new_chunk)
	if foreground:
		for animation in foreground:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_foreground_parent)
			animation.set_deferred("global_position", global_pos)
	if background:
		for animation in background:
			var global_pos: Vector2 = animation.global_position
			animation.reparent(GameInstance.instance.event_background_parent)
			animation.set_deferred("global_position", global_pos)
func _hurtbox_entered(body: Node2D) -> void:
	pass
func _hitbox_entered(body: Node2D) -> void:
	if can_damage && stopwatch >= cooldown:
		if (!only_damage_player || body.is_in_group("player")) && "can_be_damaged" in body && body.get("can_be_damaged") && body.has_method("damage"):
			stopwatch = 0
			var attack: Attack = Attack.new(Attack.AttackTypes.map_hazard, self, global_position, status, null, null)
			attack.simple_setup(attack_damage, knockback)
			GameManager.instance.player.damage(attack)
func damage(attack: Attack):
	if GameInstance.is_game_over:
		return
	## Apply Status Effect Changes (doesn't apply status effect effects yet)
	burn += attack.get_burn()
	frost += attack.get_frost()
	poison += attack.get_poison()
	bleed += attack.get_bleed()
	shock += attack.get_shock()
	wet += attack.get_wet()

	## Calculate Damage
	var attack_damage: float = attack.get_damage()
	var shock_damage: float = 0
	var wet_damage: float = 0
	
	## Shock
	if attack.status.applies_shock:
		shock_damage = get_shock_damage()
	## Wet
	if attack.status.applies_wet:
		wet_damage = get_wet_damage()
	## The Attack
	var total_damage: float = attack_damage + wet_damage + shock_damage
	var damage_taken = total_damage
	if damage_taken > 0:
		GameManager.instance.EnemyDamaged.emit(self, attack)
		curr_health -= damage_taken
	if false:
		print("Add Burn: ", attack.get_burn(), " Applied: ", attack.status.applies_burn)
		print("Add Frost: ", attack.get_frost(), " Applied: ", attack.status.applies_frost)
		print("Add Poison: ", attack.get_poison(), " Applied: ", attack.status.applies_poison)
		print("Add Bleed: ", attack.get_bleed(), " Applied: ", attack.status.applies_bleed)
		print("Add Shock: ", attack.get_shock(), " Applied: ", attack.status.applies_shock)
		print("Add Wet: ", attack.get_wet(), " Applied: ", attack.status.applies_wet)
	## Apply Stun and Knockback
	if attack.get_stun() > 0 && can_be_stunned:
			pass#stun_time_left = attack.get_stun()
			#stunned = true
			#linear_velocity = Vector2.ZERO
	if can_be_knockbacked && attack.get_knockback() != 0:
		pass
		#if stun_time_left < 1 && can_be_stunned:
			#stun_time_left = 0.2
			#stunned = true
		#apply_knockback(attack.position, attack.get_knockback())
	if attack_damage > 0:
		display_damage(attack_damage, attack.attack_color)
	if shock_damage > 0:
		display_damage(shock_damage, Color.GOLD)
	if wet_damage > 0:
		display_damage(wet_damage, Color.BLUE)
	## Die.
	check_death(attack)
func die():
	if get_parent():
		get_parent().remove_child(self)
	for node in foreground:
		node.queue_free()
	for node in background:
		node.queue_free()
	for node in anims:
		node.queue_free()
	queue_free()
var half_second_cd: float = 0
var second_cd: float = 0
var two_second_cd: float = 0
## Handles Processing Status Effect defense and effects
func status_process(delta: float) -> void:
	## Don't process if we don't even have particle effects
	if !particles:
		return
	## Only process status effects every half second
	if half_second_cd >= 0.5:
		half_second_cd = 0
	else:
		half_second_cd += delta
		return
	var second: bool = false
	var two_second: bool = false
	var most_recent_attack: Attack 
	second_cd += 0.5 # half a second has passed
	if second_cd >= 1:
		second_cd = 0
		second = true
	two_second_cd += 0.5 # half a second has passed
	if two_second_cd >= 2:
		two_second_cd = 0
		two_second = true
	## BURN: Burn every 1 second, damage based on how many times over threshold
	if !is_burning:
		applied_burn = 0
		#burn_anim.stop()
		particles.toggle_burn(false)
	elif !immune_to_burn:
		if second:
			most_recent_attack = proc_burn()
			## Death
			if check_death(most_recent_attack):
				return
	## FROST: Lower Movespeed based on frost
	if !immune_to_frost:
		if (frost / frost_threshhold) > (applied_frost + 1):
			most_recent_attack = proc_frost()
			## Death
			if check_death(most_recent_attack):
				return
	if !is_frosted:
		#frost_anim.stop()
		particles.toggle_frost(false)
		frost_movespeed_reduction = 0
	## POISON: Take damage every 2 seconds
	if !is_poisoned:
		applied_poison = 0
		#poison_anim.stop()
		particles.toggle_poison(false)
	elif !immune_to_poison:
		if two_second:
			most_recent_attack = proc_poison()
			## Death
			if check_death(most_recent_attack):
				return
	## BLEED: do nothing until bleed threshold reached, then big damage, then raise bleed threshold
	if !immune_to_bleed:
		if (bleed / bleed_threshhold) > (applied_bleed + 1):
			print("bleed proc: ",(bleed / bleed_threshhold), " > " , applied_bleed + 1)
			most_recent_attack = proc_bleed()
			## Death
			if check_death(most_recent_attack):
				return
	if !is_bleeding:
		#bleed_anim.stop()
		particles.toggle_bleed(false)
	## SHOCK:
	if !is_shocked:
		applied_shock = 0
		shock_defense_reduction = 0
		#shock_anim.stop()
		particles.toggle_shock(false)
	elif !immune_to_shock:
		if applied_shock != floor(shock / shock_threshhold):
			proc_shock()
	## WET:
	if !is_wet:
		applied_wet = 0
		#wet_anim.stop()
		particles.toggle_wet(false)
	elif !immune_to_wet:
		if applied_wet != floor(wet / wet_threshhold):
			proc_wet()
## Have we died
func check_death(attack: Attack) -> bool:
	if curr_health <= 0:
		GameManager.instance.EventKilled.emit(self, attack)
		die()
		return true
	return false
## Proc Status
func proc_burn() -> Attack:
	if particles:
		particles.toggle_burn(true)
		#burn_anim.play("default")
	## Do the math
	var current_burn_damage: float = get_burn_damage()
	var attack: Attack = make_status_attack(current_burn_damage, StatusEffects.StatusTypes.burn)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BurnDamage.emit(current_burn_damage, self)
	applied_burn += 1
	curr_health -= current_burn_damage
	## Do the display dmg
	display_damage(current_burn_damage, Color.RED)
	return attack
func proc_frost() -> Attack:
	if particles:
		particles.toggle_frost(true)
		#frost_anim.play("default")
	applied_frost = floor(frost / frost_threshhold)
	frost_movespeed_reduction = get_frost_movespeed_reduction()
	## Do the math
	var current_frost_damage: float = get_frost_damage()
	var attack: Attack = make_status_attack(current_frost_damage, StatusEffects.StatusTypes.frost)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.FrostDamage.emit(current_frost_damage, self)
	applied_frost += 1
	curr_health -= current_frost_damage
	## Do the display dmg
	display_damage(current_frost_damage, Color.LIGHT_CYAN)
	## Raise the threshold
	frost_threshhold *= Statics.enemy_frost_threshold_multiplier
	return attack
func proc_poison() -> Attack:
	if particles:
		particles.toggle_poison(true)
		#poison_anim.play("default")
	## Do the math
	var current_poison_damage: float = get_poison_damage()
	var attack: Attack = make_status_attack(current_poison_damage, StatusEffects.StatusTypes.poison)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.PoisonDamage.emit(current_poison_damage, self)
	applied_poison += 1
	curr_health -= current_poison_damage
	## Do the display dmg
	display_damage(current_poison_damage, Color.GREEN)
	return attack
func proc_bleed() -> Attack:
	if particles:
		particles.toggle_bleed(true)
		#bleed_anim.play("default")
	## Do the math
	# does x percent of health each bleed proc
	var current_bleed_damage: float = get_bleed_damage()
	var attack: Attack = make_status_attack(current_bleed_damage, StatusEffects.StatusTypes.bleed)
	GameManager.instance.EnemyDamaged.emit(self, attack)
	GameManager.instance.BleedDamage.emit(current_bleed_damage, self)
	applied_bleed += 1
	curr_health -= current_bleed_damage
	## Do the display dmg
	display_damage(current_bleed_damage, Color.ORANGE_RED)
	## Raise bleed threshold
	bleed_threshhold *= Statics.enemy_bleed_threshold_multiplier
	return attack
func proc_shock():
	if particles:
		particles.toggle_shock(true)
		#shock_anim.play("default")
	applied_shock = floor(shock / shock_threshhold)
	shock_defense_reduction = get_shock_defense_reduction()
func proc_wet():
	if particles:
		particles.toggle_wet(true)
		#wet_anim.play("default")
	applied_wet = floor(wet / wet_threshhold)
## Get Damages
func get_burn_damage() -> float:
	return GlobalStats.get_stat(GlobalStats.BURN_DAMAGE)
func get_frost_movespeed_reduction() -> float:
	## -base * number of times threshold has been reached
	return -1 * (frost / frost_threshhold) * Statics.enemy_frost_movespeed_reduction
func get_frost_damage() -> float:
	return curr_health * (GlobalStats.get_stat(GlobalStats.FROST_DAMAGE) / 100)
func get_shock_defense_reduction() -> float:
	## base * number of times threshold has been reached
	return (shock / shock_threshhold) * Statics.enemy_shock_defense_reduction
func get_bleed_damage() -> float:
	return hp * (GlobalStats.get_stat(GlobalStats.BLEED_DAMAGE) / 100)
func get_poison_damage() -> float:
	# 1/4 of max health for each time above threshold
	var mulitplier: float = floor(poison / poison_threshhold)
	return hp * GlobalStats.get_stat(GlobalStats.POISON_DAMAGE) * mulitplier
func get_shock_damage() -> float:
	return GlobalStats.get_stat(GlobalStats.SHOCK_DAMAGE)
func get_wet_damage() -> float:
	return GlobalStats.get_stat(GlobalStats.WET_DAMAGE)
## Makes a status effect attack to attack self (when a status effect damages this enemy)
func make_status_attack(status_damage: float, type: StatusEffects.StatusTypes) -> Attack:
	## Report what type of status effect it was
	var status_effects: StatusEffects
	if type == StatusEffects.StatusTypes.burn:
		status_effects = StatusEffects.new()
		status_effects.applies_burn = true
	if type == StatusEffects.StatusTypes.frost:
		status_effects = StatusEffects.new()
		status_effects.applies_frost = true
	if type == StatusEffects.StatusTypes.poison:
		status_effects = StatusEffects.new()
		status_effects.applies_poison = true
	if type == StatusEffects.StatusTypes.bleed:
		status_effects = StatusEffects.new()
		status_effects.applies_bleed = true
	if type == StatusEffects.StatusTypes.shock:
		status_effects = StatusEffects.new()
		status_effects.applies_shock = true
	if type == StatusEffects.StatusTypes.wet:
		status_effects = StatusEffects.new()
		status_effects.applies_wet = true
	## Make attack
	var attack: Attack = Attack.new(Attack.AttackTypes.enemy_status, null, global_position, status_effects, null, null)
	attack.simple_setup(status_damage, 0)
	return attack
## Makes a PopupText for the given damage and color, Color.TRANSPARENT for random color
func display_damage(damage_value: float, color: Color):
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	if color == Color.TRANSPARENT:
		dmg_text.setup(str(int(round(damage_value))), damage_value + randi_range(-5, 5), WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10))
	else:
		dmg_text.setup_color(str(int(round(damage_value))), damage_value + randi_range(-5, 5), WindowManager.instance.convert_small_position(global_position), 1.5, Vector2(10, 10), color)
