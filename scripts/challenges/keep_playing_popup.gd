extends CanvasLayer

@onready var dialog_window: PanelContainer = $DialogWindow
@onready var left_button: Button = $DialogWindow/VBoxContainer/HBoxContainer/LeftButton
@onready var right_button: Button = $DialogWindow/VBoxContainer/HBoxContainer/RightButton
@onready var question_label: Label = $DialogWindow/VBoxContainer/QuestionLabel

var foreign_languages = [
	{"q": "Chcesz grać dalej?", "yes": "TAK", "no": "NIE"},# PL
	{"q": "Do you want to keep playing?", "yes": "NON'T", "no": "YESN'T"},#Troll eng
	{"q": "Do you want to stop playing?", "yes": "No", "no": "Yes"},#Troll eng
	{"q": "¿Quieres seguir jugando?", "yes": "SÍ", "no": "NO"},# ES
	{"q": "Möchtest du weiterspielen?", "yes": "JA", "no": "NEIN"},# DE
	{"q": "Veux-tu continuer à jouer ?", "yes": "OUI", "no": "NON"},# FR
	{"q": "Vuoi continuare a giocare?", "yes": "SÌ", "no": "NO"},# IT
	{"q": "Vil du fortsette å spille?", "yes": "JA", "no": "NEI"},# NO
	{"q": "ゲームを続けますか？", "yes": "はい", "no": "いいえ"},# JA
	{"q": "你想繼續玩嗎？", "yes": "是", "no": "不"},# ZH-TW
	{"q": "게임을 계속하시겠습니까?", "yes": "네", "no": "아니요"}, # KO
	{"q": "هل تريد الاستمرار في اللعب؟", "yes": "نعم", "no": "لا"},# AR
	{"q": "Thật sự muốn tiếp tục chơi không?", "yes": "CÓ", "no": "KHÔNG"},# VI
	{"q": "Gribi turpināt spēlēt?", "yes": "JĀ", "no": "NĒ"},# LV
	{"q": "Volete perseverare in ludo?", "yes": "ITA", "no": "MINIME"}# LA
]

var english = {"q": "Do you want to keep playing?", "yes": "YES", "no": "NO"}

var timer: float = 0.0
var next_popup_time: float = 0.0
var level: int = 0
var player: CharacterBody2D = null

var is_left_button_correct: bool = true

func _ready() -> void:
	dialog_window.visible = false
	level = ChallengeManager.get_challange_level("wanna_keep_playing")
	
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	
	if level > 0:
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		print("start")
		set_next_time()

func _process(delta: float) -> void:
	if level == 0 or dialog_window.visible:
		return
	
	timer += delta
	if ChallengeManager.is_popup_open:
		return
	
	if timer >= next_popup_time:
		show_dialoge()

func show_dialoge() -> void:
	ChallengeManager.is_popup_open = true
	dialog_window.visible = true
	timer = 0.0
	var lang_data
	
	if randf() < 0.5:
		lang_data = english
	else:
		lang_data = foreign_languages.pick_random()
	
	question_label.text = lang_data["q"]
	
	is_left_button_correct = randf() < 0.5
	
	if is_left_button_correct:
		left_button.text = lang_data["yes"]
		right_button.text = lang_data["no"]
	else:
		left_button.text = lang_data["no"]
		right_button.text = lang_data["yes"]

func set_next_time() -> void:
	match level:
		1:
			next_popup_time = randf_range(15.0, 25.0)
		2:
			next_popup_time = randf_range(10.0, 17.5)
		3:
			next_popup_time = randf_range(5.0, 15.0)
			
	print(level, " ", next_popup_time)

func _on_left_button_pressed() -> void:
	if is_left_button_correct:
		handle_success()
	else:
		handle_death()

func _on_right_button_pressed() -> void:
	if not is_left_button_correct:
		handle_success()
	else:
		handle_death()


func handle_success() -> void:
	dialog_window.visible = false
	ChallengeManager.is_popup_open = false
	set_next_time()

func handle_death() -> void:
	dialog_window.visible = false
	ChallengeManager.is_popup_open = false
	if player:
		player.die("Didn't want to keep playing")
