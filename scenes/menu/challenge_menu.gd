extends Control

var high_score: int = 0
var tile_scene: PackedScene = preload("uid://vfxwxu6qiqim")

@onready var tooltip: PanelContainer = $Tooltip
@onready var label_current_score_number: Label = $"Container/RightPanel/VBoxContainer/RightBottomPanel/VBoxContainer/HBoxContainer/Actual Score/LabelCurrentScoreNumber"
@onready var grid_container: GridContainer = $Container/GridContainer
@onready var label_high_score_number: Label = $Container/RightPanel/VBoxContainer/RightBottomPanel/VBoxContainer/HBoxContainer/Highscore/LabelHighScoreNumber

func _ready() -> void:
	_on_any_challenge_changed()
	var all_challenges: Dictionary = ChallengeManager.return_all_challenges()
	for challenge in all_challenges:
		var newTile = tile_scene.instantiate()
		
		newTile.challenge_changed.connect(_on_any_challenge_changed)
		newTile.tooltip_show.connect(_tooltip_show)
		newTile.tooltip_hide.connect(_tooltip_hide)
		
		newTile.setup(challenge, all_challenges[challenge])
		grid_container.add_child(newTile)
	sync_high_score()
	
func sync_high_score() -> void:
	high_score = ChallengeManager.high_score
	label_high_score_number.text = str(high_score)

func _on_any_challenge_changed() -> void:
	ChallengeManager.update_current_points()
	label_current_score_number.text = str(ChallengeManager.return_current_points())

func _tooltip_show(key: String) -> void:
	if tooltip and tooltip.get_children().size() > 0:
		var data = Menudatabase.menu_data[key]
		var label = tooltip.get_children()[0]
		label.text = "[font_size=16]" + data["title"] + " \n[font_size=10]" + data["desc"]
		tooltip.show()

func _tooltip_hide() -> void:
	tooltip.hide()

func _on_start_button_pressed() -> void:
	ChallengeManager.save_game()
	get_tree().change_scene_to_file("res://scenes/maps/world_1.tscn")
