extends Node2D
class_name AudioManager
## Each sound is an export variable i make of a custom class
## Setup specifics of the sound (randomness, specific audio file, audio name, etc) inside the export
## Keep track of playing statistics (num of times currently playin the sound effect) inside that variable
## Call play(variable) using a call to AudioManager.Play(AudioManager.SoundEffectVariable)
static var instance: AudioManager
@export var XP_COLLECT: Sound = Sound.new()
## Check instance
func _ready() -> void:
	if instance != null:
		push_error("Multiple AudioManagers Detected!")
	else:
		instance = self
## Play
func play(sound: Sound, location: Vector2) -> void:
	## Ensure Concurrent Limit
	if sound.concurrent_count > sound.concurrent_limit:
		print("Didn't play sound \"", sound.clip_name , "\"", " due to exceeded concurrent_limit")
		return
	else:
		print(sound.concurrent_count, " ", sound.concurrent_limit)
	## Setup the player
	var player
	if sound.spatial_audio:
		player = AudioStreamPlayer2D.new()
		GameManager.instance.audio_parent.add_child(player)
		player.global_position = location
	else:
		player = AudioStreamPlayer.new()
		GameManager.instance.add_child(player)
	player.stream = sound.clip
	player.volume_db = sound.volume
	player.pitch_scale = sound.pitch
	if sound.pitch_variance != 0:
		player.pitch_scale += randf_range(-sound.pitch_variance, sound.pitch_variance)
	if sound.volume_variance != 0:
		player.volume_db += randf_range(-sound.volume_variance, sound.volume_variance)
	## Increment
	sound.increment_concurrent()
	## Connect Signals 
	player.finished.connect(sound.decrement_concurrent)
	player.finished.connect(player.queue_free)
	player.play()
