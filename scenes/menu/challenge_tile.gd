extends PanelContainer

@export var challenge_key: String = "ice_floor"
@export var max_level: int = 3
var current_level: int = 0

@onready var current_level_label: Label = $HBoxContainer/Right/VBoxContainer/CurrentLevelLabel
@onready var texture_rect: TextureRect = $HBoxContainer/Left/TextureRect

func _ready() -> void:
	current_level = ChallengeManager.challenges.get(challenge_key, 0)
	print(challenge_key)
	print(ChallengeManager.challenges.get(challenge_key, 0))
	update_display()

func setup(key: String, level: int) -> void:
	challenge_key = key
	max_level = level
	
	if Menudatabase.menu_data.has(key):
		var data = Menudatabase.menu_data[key]
		tooltip_text = data["desc"]
		print(data["desc"])

func _on_left_mouse_entered() -> void:
	print(challenge_key)

func update_display() -> void:
	current_level_label.text = str(current_level)
	
	var newModulate: Color
	
	
	if current_level == 0:
		newModulate = Color(0.3, 0.3, 0.3, 1.0)
	else:
		newModulate = Color(1.0, 1.0, 1.0, 1.0)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", newModulate, 0.1)

func _on_panel_container_up_pressed() -> void:
	current_level = min(current_level + 1, max_level)
	ChallengeManager.challenges[challenge_key] = current_level
	update_display()


func _on_panel_container_down_pressed() -> void:
	current_level = max(current_level - 1, 0)
	ChallengeManager.challenges[challenge_key] = current_level
	update_display()
