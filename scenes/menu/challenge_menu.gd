extends Control

var high_score: int = 0
var tile_scene: PackedScene = preload("uid://vfxwxu6qiqim")

@onready var grid_container: GridContainer = $Container/GridContainer

func _ready() -> void:
	high_score = ChallengeManager.high_score
	var all_challenges: Dictionary = ChallengeManager.return_all_challenges()
	for challenge in all_challenges:
		var newTile = tile_scene.instantiate()
		newTile.challenge_key = challenge
		newTile.max_level = all_challenges[challenge]
		grid_container.add_child(newTile)
	
func _on_start_button_pressed() -> void:
	ChallengeManager.save_game()
	get_tree().change_scene_to_file("res://scenes/maps/world_1.tscn")
