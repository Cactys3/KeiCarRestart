@tool
extends CPUParticles2D
@export_category("PointLight2D")
@export var enabled: bool = true :
	set(value):
		enabled = value
		if light:
			light.enabled = enabled
@export_range(0, 16) var energy: float = 0.5 :
	set(value):
		energy = value
		if light:
			light.energy = energy
@export_range(0.01, 50) var texture_scale: float = 0.5 :
	set(value):
		texture_scale = value
		if light:
			light.texture_scale = texture_scale
@export var light_texture: Texture2D = preload("uid://d1m1idlbdun46") :
	set(value):
		light_texture = value
		if light:
			light.texture = light_texture
@export var light_color: Color = Color.WHITE :
	set(value):
		light_color = value
		if light:
			light.color = light_color
@export var shadow: bool = false :
	set(value):
		shadow = value
		if light:
			light.shadow_enabled = shadow
@export var light: PointLight2D :
	set(value):
		light = value
		if light:
			light.enabled = enabled
			light.energy = energy
			light.texture_scale = texture_scale
			light.texture = light_texture
			light.color = light_color
			light.shadow_enabled = shadow
func _ready():
	if light:
		light.enabled = enabled
		light.energy = energy
		light.texture_scale = texture_scale
		light.texture = light_texture
		light.color = light_color
		light.shadow_enabled = shadow

func _process(delta: float) -> void:
	emitting = is_visible_in_tree()
