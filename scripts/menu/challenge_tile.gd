extends PanelContainer

signal challenge_changed()
signal tooltip_show(key: String)
signal tooltip_hide()

@export var challenge_key: String = ""
@export var max_level: int = 3
var current_level: int = 0
var icon_path: String = ""

@onready var current_level_label: Label = $HBoxContainer/Right/VBoxContainer/CurrentLevelLabel
@onready var texture_rect: TextureRect = $HBoxContainer/Left/TextureRect

func _ready() -> void:
	update_display()

func setup(key: String, level: int) -> void:
	challenge_key = key
	max_level = level
	icon_path = "res://resources/sprites/challenge_icons/" + challenge_key + ".png"
	
	current_level = ChallengeManager.challenges.get(challenge_key, 0)
func _on_left_mouse_entered() -> void:
	emit_signal("tooltip_show", challenge_key)

func _on_left_mouse_exited() -> void:
	emit_signal("tooltip_hide")

func update_display() -> void:
	if ResourceLoader.exists(icon_path):
		texture_rect.texture = load(icon_path)
	else:
		print("not found image for:", challenge_key, " ")
	current_level_label.text = str(current_level)
	
	var newModulate: Color
	
	
	if current_level == 0:
		newModulate = Color(0.3, 0.3, 0.3, 1.0)
	else:
		newModulate = Color(1.0, 1.0, 1.0, 1.0)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", newModulate, 0.1)

func update_points(added_points: int) -> void:
	ChallengeManager.add_to_current_score(added_points)

func _on_panel_container_up_pressed() -> void:
	var temp = current_level
	current_level = min(current_level + 1, max_level)
	ChallengeManager.challenges[challenge_key] = current_level
	emit_signal("challenge_changed")
	ChallengeManager.active_preset = ""
	update_display()

func _on_panel_container_down_pressed() -> void:
	current_level = max(current_level - 1, 0)
	ChallengeManager.challenges[challenge_key] = current_level
	emit_signal("challenge_changed")
	ChallengeManager.active_preset = ""
	update_display()


func refresh_from_manager() -> void:
	current_level = ChallengeManager.challenges.get(challenge_key, 0)
	update_display()
