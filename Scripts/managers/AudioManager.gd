extends Node2D
class_name AudioManager
## Each sound is an export variable i make of a custom class (not necessarily an export of 'AudioManager'
## Setup specifics of the sound (randomness, specific audio file, audio name, etc) inside the export
## Keep track of playing statistics (num of times currently playin the sound effect) inside that variable
## Call play(variable) using a call to AudioManager.Play(AudioManager.SoundEffectVariable)
static var instance: AudioManager
var playing_sounds: Array[Sound]
@export var XP_COLLECT: Sound = Sound.new()
@export var WALKING_SOUND: Sound = Sound.new()
@export var UI_PRESS: Sound = Sound.new()
## Check instance
func _ready() -> void:
	if instance != null:
		push_error("Multiple AudioManagers Detected!")
	else:
		instance = self
## Play
func play(sound: Sound, location: Vector2) -> void:
	## Check if single_instance and still playing
	if sound.single_instance && sound.audio_stream_player != null:
		## the 'audio_stream_player' not being null means it hasn't finished playing
		## Current Functionality: Stop the sound and replay from the begining
		sound.decrement_concurrent(sound.audio_stream_player)
	## Ensure Concurrent Limit
	if sound.concurrent_count > sound.concurrent_limit:
		#print_debug("Didn't play sound \"", sound.clip_name , "\"", " due to exceeded concurrent_limit")
		return
	## Setup the player
	var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	if sound.spatial_audio:
		add_child(player)#GameManager.instance.audio_parent.add_child(player)
		player.global_position = location
		player.attenuation = sound.falloff
	else:
		add_child(player)
		player.attenuation = 0
	player.stream = sound.clip
	player.volume_db = sound.volume
	player.pitch_scale = sound.pitch
	if sound.pitch_variance != 0:
		player.pitch_scale += randf_range(-sound.pitch_variance, sound.pitch_variance)
	if sound.volume_variance != 0:
		player.volume_db += randf_range(-sound.volume_variance, sound.volume_variance)
	## Increment
	sound.increment_concurrent(player)
	## Connect Signals 
	if sound.loops:
		player.finished.connect(sound.loop.bind(player))
	else:
		player.finished.connect(sound.decrement_concurrent.bind(player))
	player.play()
	#print_debug("Play: ", sound.clip_name, " Volume: ", player.volume_db)
## Pause
func pause(sound: Sound):
	pass
## Stop
func stop(sound: Sound):
	pass
