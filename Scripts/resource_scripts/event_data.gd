extends Resource
## 
class_name EventData

@export var event_scene: PackedScene
@export var event_minimap_icon: Texture2D
@export var event_name: String = "unset"
enum EventTypes {unset, OnlyArt, DamagableEvent, InteractableEvent, UpgradePickup, MetaPickup}
@export var event_type: EventTypes = EventTypes.unset
@export var event_description: String = "unset"
@export var event_center_offset: Vector2
@export var event_size: Vector2

## Create and return the event scene
func create_event() -> Event:
	var scene: Event = event_scene.instantiate()
	scene.event_name = event_name
	scene.event_type = event_type
	scene.event_description = event_description
	scene.event_center_offset = event_center_offset
	scene.event_size = event_size
	scene.data = self
	return scene
