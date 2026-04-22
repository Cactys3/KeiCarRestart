extends Node2D
class_name EntityParticles
## Handles Status/Particle Effect visuals for all entities that have them

@export var status_scale: Vector2 = Vector2(1, 1)
@export_group("Toggle Effects")
@export var enabled_burn: bool = true
@export var enabled_frost: bool = true
@export var enabled_poison: bool = true
@export var enabled_bleed: bool = true
@export var enabled_shock: bool = true
@export var enabled_wet: bool = true

@onready var burn: Node2D = $Burn
@onready var frost: Node2D = $Frost
@onready var poison: Node2D = $Poison
@onready var bleed: Node2D = $Bleed
@onready var shock: Node2D = $Shock
@onready var wet: Node2D = $Wet

func _ready() -> void:
	scale = status_scale

func toggle_burn(value: bool) -> void:
	burn.visible = value
func toggle_frost(value: bool) -> void:
	frost.visible = value
func toggle_poison(value: bool) -> void:
	poison.visible = value
func toggle_bleed(value: bool) -> void:
	bleed.visible = value
	bleed.get_child(0).play("default")
func toggle_shock(value: bool) -> void:
	shock.visible = value
func toggle_wet(value: bool) -> void:
	wet.visible = value
