extends Control

@onready var container: Control = $Background/Container

@onready var game_over_label: Label = $Background/Container/VBoxContainer/GameOverLabel
@onready var cause_label: Label = $Background/Container/VBoxContainer/CauseLabel
@onready var again_button: Button = $Background/Container/VBoxContainer/AgainButton
@onready var menu_button: Button = $Background/Container/MenuButton
@onready var current_points_label: Label = $Background/Container/CurrentPointsLabel


var cause: String = ""
var points: int = 0

var original_menu_button_position: Vector2 = Vector2(550, 364)
var original_current_points_label_position: Vector2 = Vector2(15, 362)

var x = Vector2(15, 362)

func _ready() -> void:
	
	menu_button.global_position = original_menu_button_position
	current_points_label.global_position = original_current_points_label_position
	
	game_over_label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	cause_label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	again_button.modulate = Color(1.0, 1.0, 1.0, 0.0)
	again_button.disabled = true
	
	
	cause = ChallengeManager.death_cause
	points = ChallengeManager.current_score
	sync_text()
	await get_tree().create_timer(0.5).timeout
	start_animations()

func sync_text() -> void:
	cause_label.text = cause
	current_points_label.text = "Current Score: " + str(points)

func start_animations() -> void:
	var game_over_label_tween = create_tween()
	game_over_label_tween.tween_property(game_over_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2).set_ease(Tween.EASE_OUT)
	await game_over_label_tween.finished
	
	var cause_tween = create_tween()
	cause_tween.tween_property(cause_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1).set_ease(Tween.EASE_OUT)
	await cause_tween.finished
	
	again_button.disabled = false
	var other_tween = create_tween().set_parallel(true)
	other_tween.tween_property(again_button,"modulate",
	Color(1.0, 1.0, 1.0, 1.0),0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	other_tween.tween_property(menu_button, "position",
	original_menu_button_position + Vector2(0, -50), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	other_tween.tween_property(current_points_label, "position",
	original_current_points_label_position + Vector2(0, -50), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func _on_again_button_pressed() -> void:
	ChallengeManager.is_new_high_score = false
	ChallengeManager.save_game()
	get_tree().change_scene_to_file("res://scenes/maps/world_1.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/challenge_menu.tscn")
