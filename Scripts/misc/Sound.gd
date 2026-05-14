extends Resource
## yo
class_name Sound

@export var clip: AudioStream
@export var clip_name: String
## Number of this sound that can be played at the same time
@export var concurrent_limit: int = 3
@export_range(-80.0, 24.0) var volume: float = 0.0
@export_range(0.01, 4) var pitch: float = 1.0
## Randomness up or down of this sound's volume
@export var volume_variance: float = 0.0
## Randomness up or down of this sound's pitch
@export var pitch_variance: float = 0.0
## Is this sound 2D? ie: change volume based on distance from player
@export var spatial_audio: bool = true
## Number of this sound currently playing
var concurrent_count: int = 0

func increment_concurrent():
	concurrent_count += 1
func decrement_concurrent():
	concurrent_count -= 1
