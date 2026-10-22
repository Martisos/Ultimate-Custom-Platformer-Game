extends Node
var active_preset: String = ""

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

var presets: Dictionary = {
	"all_zero": {
		"title" : "Nothing",
		"beaten": false
	},
	"mouse_challenge1": {
		"title" : "Mouse Challenge I",
		"beaten" : false
	},
	"mouse_challenge2": {
		"title" : "Mouse Challenge II",
		"beaten" : false
	}, 
	"mouse_challenge3": {
		"title" : "Mouse Challenge III",
		"beaten" : false
	}, 
	"visual_chaos": {
		"title" : "Visual Chaos",
		"beaten" : false
	}, 
	"slop_platformer": {
		"title" : "Slop Platformer",
		"beaten" : false
	}, 
	"can_not_kill" : {
		"title" : "Can't quite kill you",
		"beaten" : false
	},
	"can_kill" : {
		"title" : "Can quite kill you",
		"beaten" : false
	},
	"all_one": {
		"title" : "All to 1",
		"beaten": false
	},
	"all_two": {
		"title" : "All to 2",
		"beaten": false
	},
	"all_three": {
		"title" : "50 / 20",
		"beaten": false
	},
}

var high_score: int = 0
var is_new_high_score: bool = false
var death_cause: String = ""
var current_score: int = 0
const SAVE_PATH = "user://savegame.cfg"

var is_popup_open: bool = false

var is_resetting: bool = false

func try_reset() -> void:
	if is_resetting: 
		return
		
	is_resetting = true
	
	ChallengeManager.save_game()
	
	TransitionScreen.change_scene("res://scenes/maps/world_1.tscn")
	
	await get_tree().create_timer(1.0).timeout
	is_resetting = false

func update_current_points() -> void:
	current_score = 0
	for challenge in challenges:
		if Menudatabase.menu_data.has(challenge):
			var data = Menudatabase.menu_data[challenge]
			var points: int = data["points"]
			var aditional_points = points * challenges[challenge]
			current_score += aditional_points

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
	#hard_reset()
	load_game()

func set_challenges_to_max() -> void:
	for challenge in challenges:
		if challenge == "rigid_jump":
			challenges[challenge] = 1
		challenges[challenge] = 3

func get_challange_level(name: String) -> int:
	return challenges.get(name, 0)

# -- saving loading --


func save_game() -> void:
	update_current_points()
	var config = ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	
	for key in challenges.keys():
		config.set_value("challenges", key, challenges[key])
	
	for key in presets.keys():
		config.set_value("presets", key, presets[key]["beaten"])
	
	config.set_value("sound", "music", OptionsPanel.music_volume)
	config.set_value("sound", "sfx", OptionsPanel.sfx_volume)
	
	config.save(SAVE_PATH)

func load_game() -> void:
	var config = ConfigFile.new()
	
	var err = config.load(SAVE_PATH)
	if err != OK:
		return
	
	for key in challenges.keys():
		challenges[key] = config.get_value("challenges", key, 0)
	
	for key in presets.keys():
		presets[key]["beaten"] = config.get_value("presets", key, false)
	
	OptionsPanel.music_volume = config.get_value("sound", "music", 1.0)
	OptionsPanel.sfx_volume = config.get_value("sound", "sfx", 1.0)
	
	var m_bus = AudioServer.get_bus_index("Music")
	var s_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(m_bus, linear_to_db(max(OptionsPanel.music_volume, 0.001)))
	AudioServer.set_bus_volume_db(s_bus, linear_to_db(max(OptionsPanel.sfx_volume, 0.001)))
	
	high_score = config.get_value("game", "high_score", 0)

func hard_reset() -> void:
	var config = ConfigFile.new()
	
	for key in challenges.keys():
		config.set_value("challenges", key, 0)
	
	for key in presets.keys():
		config.set_value("presets", key, false)
	
	high_score = 0
	config.set_value("game", "high_score", 0)
	config.save(SAVE_PATH)

# --- PRESETS ---

func set_all_challenges_to(level: int) -> void:
	for key in challenges:
		challenges[key] = level
	save_game()

func load_preset(preset_name: String) -> void:
	set_all_challenges_to(0)
	active_preset = preset_name
	
	match preset_name:
		"all_zero":
			set_all_challenges_to(0)
			active_preset = ""
		"all_one":
			set_all_challenges_to(1)
		"all_two":
			set_all_challenges_to(2)
		"all_three":
			set_all_challenges_to(3)
		"mouse_challenge1":
			challenges["popups"] = 1
			challenges["wanna_keep_playing"] = 1
			challenges["flashbang_cat"] = 2
			challenges["flashlight"] = 1
			challenges["immortal_snail"] = 2
		"mouse_challenge2":
			challenges["popups"] = 3
			challenges["wanna_keep_playing"] = 1
			challenges["flashbang_cat"] = 2
			challenges["flashlight"] = 2
			challenges["immortal_snail"] = 2
		"mouse_challenge3":
			challenges["popups"] = 3
			challenges["wanna_keep_playing"] = 2
			challenges["flashbang_cat"] = 3
			challenges["flashlight"] = 3
			challenges["immortal_snail"] = 3
		"visual_chaos":
			challenges["mirror"] = 3
			challenges["random_shaders"] = 1
			challenges["random_animations"] = 2
			challenges["immortal_snail"] = 3
			challenges["flashbang_cat"] = 2
			challenges["flashlight"] = 3
			challenges["visual_effects"] = 3
			challenges["dead_pixels"] = 3
		"slop_platformer":
			challenges["ice_floor"] = 3
			challenges["rigid_jump"] = 1
			challenges["popups"] = 2
			challenges["fall_damage"] = 3
			challenges["immortal_snail"] = 3
			challenges["lag"] = 2
			challenges["dead_pixels"] = 3
		"can_not_kill":
			challenges["ice_floor"] = 3
			challenges["rigid_jump"] = 1
			challenges["popups"] = 2
			challenges["mirror"] = 2
			challenges["random_shaders"] = 3
			challenges["random_animations"] = 1
			challenges["flashbang_cat"] = 3
			challenges["flashlight"] = 3
			challenges["lag"] = 1
			challenges["dead_pixels"] = 3
			challenges["visual_effects"] = 2
		"can_kill":
			challenges["wanna_keep_playing"] = 3
			challenges["fall_damage"] = 3
			challenges["immortal_snail"] = 3
			challenges["gambling"] = 3

func complete_preset(preset_name: String) -> void:
	if presets.has(preset_name):
		presets[preset_name]["beaten"] = true
		save_game()
