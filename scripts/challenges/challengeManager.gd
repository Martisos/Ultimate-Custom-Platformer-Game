extends Node

var challenges: Dictionary = {
	"ice_floor": 0,
	"rigid_jump": 0,
	"popups": 0,
	"wanna_keep_playing": 0,
	"mirror": 2,
}

var is_popup_open: bool = false

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)
