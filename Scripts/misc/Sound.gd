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
## Can this Sound only play one instance at a time?
@export var single_instance: bool = false
var audio_stream_player: AudioStreamPlayer2D
var multiple_audio_stream_players: Array[AudioStreamPlayer2D]
## Number of this sound currently playing
var concurrent_count: int = 0
func increment_concurrent(player: AudioStreamPlayer2D) -> void:
	concurrent_count += 1
	if single_instance:
		audio_stream_player = player
	else:
		multiple_audio_stream_players.append(player)
func decrement_concurrent(player: AudioStreamPlayer2D) -> void:
	concurrent_count -= 1
	if single_instance:
		audio_stream_player = null
	else:
		multiple_audio_stream_players.erase(player)
	player.queue_free()
## Pause all instances of this sound
func pause() -> void:
	if single_instance:
		audio_stream_player.stop()
	else:
		for player in multiple_audio_stream_players:
			player.stop()
## Resumes all instances of this sound
func resume() -> void:
	if single_instance:
		audio_stream_player.play()
	else:
		for player in multiple_audio_stream_players:
			player.play()
