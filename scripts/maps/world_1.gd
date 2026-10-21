extends Node2D

const world_music: AudioStream = preload("uid://ism2k5s7fk8w")

func _ready() -> void:
	AudioManager.play_music(world_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
