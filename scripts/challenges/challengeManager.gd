extends Node

var challenges: Dictionary = {
	"ice_floor": 3,
	"rigid_jump": 1,
	"popups": 3,
	"wanna_keep_playing": 3,
	"mirror": 3,
	"random_shaders": 3,
}

var is_popup_open: bool = false

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)
