@tool
extends Event
@export var can_damage: bool = false
@export var cooldown: float = 5
@export var damage: float = 10
@export var stun: float = 0
@export var slow: float = 0
@export var knockback: float = 0
@export var buildup: float = 0
@export var status: StatusEffects = StatusEffects.new()
@export var foreground: Array[Node2D]
@export var background: Array[Node2D]

@export var anims: Array[AnimatedSprite2D]
@export var each_frame_is_alternative_art: bool = false
@export var randomly_roll_alternative_art: bool = false

var stopwatch: float = 100

func _ready() -> void:
	super()
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

func _on_damage_area_body_entered(body: Node2D) -> void:
	if can_damage && stopwatch >= cooldown:
		stopwatch = 0
		GameManager.instance.player.damage(Attack.new(Attack.AttackTypes.map_hazard, damage, global_position, buildup, status, self, stun, slow, knockback))
