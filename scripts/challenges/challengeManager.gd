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
	"immortal_snail": 3, #0-3
	"flashbang_cat": 0, #0-3
	"flashlight": 0, #0-3
	"lag": 0, #0-3
	"dead_pixels": 0,#0-3
	"gambling": 0, #0-3
}

var high_score: int = 0
const SAVE_PATH = "user://savegame.cfg"

var is_popup_open: bool = false

func set_challenge_level(name: String, level: int) -> void:
	for challenge in challenges:
		if challenge == name:
			challenges[challenge] = level

func _ready() -> void:
	load_game()
	print(high_score)
	#set_challenges_to_max()

func set_challenges_to_max() -> void:
	for challenge in challenges:
		if challenge == "rigid_jump":
			challenges[challenge] = 1
		challenges[challenge] = 3
		print(challenge)

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)

# -- saving loading --

func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	
	config.save(SAVE_PATH)

func load_game() -> void:
	var config = ConfigFile.new()
	
	var err = config.load(SAVE_PATH)
	if err != OK:
		print("first time playing - debug")
		return
	
	high_score = config.get_value("game", "high_score", 0)
