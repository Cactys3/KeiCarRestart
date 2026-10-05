extends TextureRect
class_name CharacterSheet
@onready var character_portrait: TextureRect = $CharacterPortrait
## Stat Labels
@onready var movespeed: Label = $Movespeed/Label
@onready var health: Label = $Health/Label
@onready var shield: Label = $Shield/Label
@onready var luck: Label = $Luck/Label
@onready var mogul: Label = $Mogul/Label
@onready var xp: Label = $XP/Label
@onready var thorns: Label = $Thorns/Label
@onready var stance: Label = $Stance/Label
@onready var magnetize: Label = $Magnetize/Label
@onready var revives: Label = $Revives/Label
@onready var regen: Label = $Regen/Label
@onready var ghostly: Label = $Ghostly/Label
@onready var difficulty: Label = $Difficulty/Label
@onready var labels: Array[Label] = [movespeed, health, shield, luck, mogul, xp, thorns, stance, magnetize, revives, regen, ghostly, difficulty]
var showing: bool = true

func _ready() -> void:
	var label_settings: LabelSettings = LabelSettings.new()
	label_settings.font_color = Color.WHITE.lerp(Color("b10000"), 0.3)
	label_settings.font_size = 16
	for label in labels:
		label.label_settings = label_settings
		label.text = "0"
	call_deferred("reset_ui")
func reset_ui():
	print(GameManager.instance.player.character_name)
	character_portrait.texture = GameManager.instance.player.data.character_sheet_icon
	Statics.changed_stats()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
## Hide and Show augment sheet
func _pull_tab_pressed():
	if showing:
		position += Vector2(size.x, 0)
	else:
		position += Vector2(-size.x, 0)
	showing = !showing
## Sets the Tab UI for the given stat
func set_stat(stat: String, value: String):
	match stat:
		GlobalStats.HP:
			health.text = value
		GlobalStats.MOVESPEED:
			movespeed.text = value
		GlobalStats.SHIELD:
			shield.text = value
		GlobalStats.LUCK:
			luck.text = value
		GlobalStats.MOGUL:
			mogul.text = value
		GlobalStats.XP:
			xp.text = value
		GlobalStats.THORNS:
			thorns.text = value
		GlobalStats.STANCE:
			stance.text = value
		GlobalStats.MAGNETIZE:
			magnetize.text = value
		GlobalStats.REVIES:
			revives.text = value
		GlobalStats.REGEN:
			regen.text = value
		GlobalStats.GHOSTLY:
			ghostly.text = value
		GlobalStats.DIFFICULTY:
			difficulty.text = value
