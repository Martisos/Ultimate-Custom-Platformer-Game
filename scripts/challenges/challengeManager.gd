extends Node

var challenges: Dictionary = {
	"ice_floor": 0, #0-3
	"rigid_jump": 0, #0-1
	"popups": 0, #0-3
	"wanna_keep_playing": 0, #0-3
	"mirror": 0, #0-3
	"random_shaders": 0, #0-3
	"fall_damage": 0, #0-3
	"random_animations": 0, #0-3
	"immortal_snail": 0, #0-3
	"flashbang_cat": 3, #0-3
}

var is_popup_open: bool = false

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)
