extends Node

var challenges: Dictionary = {
	"ice_floor": 3,
	"rigid_jump": 1,
	"popups": 3,
	"timer": 0
}

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)
