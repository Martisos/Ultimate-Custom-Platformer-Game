extends Control

@onready var congrats_label: RichTextLabel = $CongratsLabel
@onready var score_label: Label = $ScoreLabel
@onready var new_highscore_label: Label = $NewHighscoreLabel

var texts: Array[String] = ["GREAT JOB!", "FANTASTIC!", "AMAZING!", "PERFECT!", "UNBEATABLE!"]

var score: int = 0
var current_displayed_score: int = 0
var timer: float = 0.0
var max_time: float = 0.03

var animation_done: bool = false

func _ready() -> void:
	score = ChallengeManager.current_score
	new_highscore_label.hide()
	if ChallengeManager.is_new_high_score: new_highscore_label.show()
	print(score, " - win score")
	print(current_displayed_score, " - win current score")
	set_timer()


func _process(delta: float) -> void:
	if animation_done: return
	timer -= delta
	
	if current_displayed_score >= score:
		current_displayed_score = score
		animation_done = true
		go_to_menu()
		return
	
	if timer <= 0:
		current_displayed_score += 10
		timer = max_time
		update_text()

func go_to_menu() -> void:
	await get_tree().create_timer(3.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu/challenge_menu.tscn")

func update_text() -> void:
	if current_displayed_score >= 4200:
		congrats_label.text = texts[4]
	elif current_displayed_score >= 3500:
		congrats_label.text = texts[3]
	elif current_displayed_score >= 2500:
		congrats_label.text = texts[2]
	elif current_displayed_score >= 1200:
		congrats_label.text = texts[1]
	else:
		congrats_label.text = texts[0]
	
	score_label.text = str(current_displayed_score)
	

func set_timer() -> void:
	timer = max_time
