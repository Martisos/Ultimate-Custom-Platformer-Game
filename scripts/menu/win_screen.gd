extends Control

@onready var did_it_label: Label = $DidItLabel

@onready var container: Control = $Container
@onready var congrats_label: RichTextLabel = $Container/CongratsLabel
@onready var score_label: Label = $Container/ScoreLabel
@onready var new_highscore_label: Label = $Container/NewHighscoreLabel

var texts: Array[String] = [
	"[center][b][font_size=20]GOOD JOB![/font_size][/b][/center]",
	"[center][b][font_size=24]FANTASTIC![/font_size][/b][/center]",
	"[center][b][font_size=28]AMAZING![/font_size][/b][/center]",
	"[center][b][font_size=34]PERFECT![/font_size][/b][/center]",
	"[center][b][font_size=40]UNBEATABLE![/font_size][/b][/center]"
]

var score: int = 0
var current_displayed_score: int = 0
var timer: float = 0.0
var max_time: float = 0.05

var timer_score: float = 0.0
var max_timer_score: float = 0.3

var can_count: bool = false
var animation_done: bool = false

func _ready() -> void:
	score = ChallengeManager.current_score
	if ChallengeManager.is_new_high_score: new_highscore_label.show()
	print(score, " - win score")
	print(current_displayed_score, " - win current score")
	
	score_label.text = str(0)
	container.hide()
	start_did_it_animation()

func start_did_it_animation() -> void:
	did_it_label.show()
	var start_position_y = did_it_label.global_position.y
	did_it_label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(did_it_label, "position:y", start_position_y - 30, 2)
	tween.tween_property(did_it_label, "modulate", Color(1.0, 1.0, 1.0, 1), 1)
	await tween.finished
	did_it_label.hide()
	container.show()
	set_timer()
	can_count = true

func _process(delta: float) -> void:
	if animation_done or !can_count: return
	timer -= delta
	timer_score -= delta
	
	
	if current_displayed_score >= score:
		current_displayed_score = score
		animation_done = true
		go_to_menu()
		return
	
	if timer <= 0:
		current_displayed_score += 10
		timer = max_time
		update_text()
	
	if timer_score <= 0 and ChallengeManager.is_new_high_score:
		toggle_highscore_text()
		timer_score = max_timer_score
		
func toggle_highscore_text() -> void:
	var is_visible: bool = new_highscore_label.visible
	new_highscore_label.visible = !is_visible

func go_to_menu() -> void:
	await get_tree().create_timer(6.5).timeout
	ChallengeManager.save_game()
	get_tree().change_scene_to_file("res://scenes/menu/challenge_menu.tscn")

func update_text() -> void:
	var mat = congrats_label.material as ShaderMaterial
	
	if current_displayed_score >= 4250:
		congrats_label.text = texts[4]
		if mat:
			mat.set_shader_parameter("color1", Color(0.922, 0.854, 0.32, 1.0))
			mat.set_shader_parameter("color2", Color(0.773, 0.752, 0.473, 1.0))
			mat.set_shader_parameter("speed", 5.0)
			
	elif current_displayed_score >= 3400:
		congrats_label.text = texts[3]
		if mat:
			mat.set_shader_parameter("color1", Color(0.5, 0.0, 1.0))
			mat.set_shader_parameter("color2", Color(1.0, 0.044, 0.724, 1.0))
			mat.set_shader_parameter("speed", 5.0)
			
	elif current_displayed_score >= 2500:
		congrats_label.text = texts[2]
		if mat:
			mat.set_shader_parameter("color1", Color(0.0, 0.5, 1.0))
			mat.set_shader_parameter("color2", Color(0.0, 1.0, 1.0))
			mat.set_shader_parameter("speed", 5.0)
			
	elif current_displayed_score >= 1200:
		congrats_label.text = texts[1]
		if mat:
			mat.set_shader_parameter("color1", Color(0.0, 1.0, 0.0))
			mat.set_shader_parameter("color2", Color(0.95, 1.0, 0.235, 1.0))
			mat.set_shader_parameter("speed", 4.0)
			
	else:
		congrats_label.text = texts[0]
		if mat:
			mat.set_shader_parameter("color1", Color(0.5, 0.5, 0.5))
			mat.set_shader_parameter("color2", Color(1.0, 1.0, 1.0))
			mat.set_shader_parameter("speed", 3.0)
	
	score_label.text = str(current_displayed_score)
	

func set_timer() -> void:
	timer = max_time
	if ChallengeManager.is_new_high_score:
		timer_score = max_timer_score
