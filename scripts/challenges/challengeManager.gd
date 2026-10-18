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
	"flashbang_cat": 0, #0-3
	"flashlight": 0, #0-3
	"lag": 0, #0-3
	"dead_pixels": 0,#0-3
	"gambling": 0, #0-3
	"visual_effects": 3 #0-3
}

var high_score: int = 0
var current_score: int = 0
const SAVE_PATH = "user://savegame.cfg"

var is_popup_open: bool = false

func update_current_points() -> void:
	current_score = 0
	print("---------")
	for challenge in challenges:
		print("first if")
		if Menudatabase.menu_data.has(challenge):
			print("second if")
			var data = Menudatabase.menu_data[challenge]
			var points: int = data["points"]
			var aditional_points = points * challenges[challenge]
			current_score += aditional_points
			print(aditional_points)

func return_current_points() -> int:
	return current_score

func return_all_challenges() -> Dictionary:
	var returningDict: Dictionary = {}
	for challenge in challenges:
		if challenge == "rigid_jump":
			returningDict[challenge] = 1
			continue
		returningDict[challenge] = 3
	return returningDict

func set_challenge_level(name: String, level: int) -> void:
	for challenge in challenges:
		if challenge == name:
			challenges[challenge] = level

func reset_current_score() -> void:
	current_score = 0

func add_to_current_score(points: int) -> void:
	current_score += points

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
	
	for key in challenges.keys():
		config.set_value("challenges", key, challenges[key])
	
	config.save(SAVE_PATH)

func load_game() -> void:
	var config = ConfigFile.new()
	
	var err = config.load(SAVE_PATH)
	if err != OK:
		print("first time playing - debug")
		return
	
	for key in challenges.keys():
		challenges[key] = config.get_value("challenges", key, 0)
	
	high_score = config.get_value("game", "high_score", 0)
