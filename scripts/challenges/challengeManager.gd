extends Node

var challenges: Dictionary = {
	"ice_floor": 3,
	"rigid_jump": 0,
	"popups": 0,
	"timer": 0
}

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)
