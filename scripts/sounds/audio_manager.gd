extends Node

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer2D

func play_music(music_stream: AudioStream) -> void:
	if music_player.stream == music_stream and music_player.playing:
		return
	
	music_player.stream = music_stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(sound_stream: AudioStream) -> void:
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sound_stream
	
	sfx_player.bus = "SFX"
	
	add_child(sfx_player)
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)
