extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer2D

func play_music(music_stream: AudioStream) -> void:
	if music_player.stream == music_stream and music_player.playing:
		return
	music_player.bus = "Music"
	
	music_player.stream = music_stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(sound_stream: AudioStream, randomize_pitch: bool = false) -> void:
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sound_stream
	sfx_player.bus = "SFX"
	
	if randomize_pitch:
		sfx_player.pitch_scale = randf_range(0.85, 1.15)
	
	add_child(sfx_player)
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)
