extends Button
signal preset_selected(preset_name: String)

@onready var label: Label = $Label
var button_name: String = ""
var button_title: String = ""
var color: Color = Color("d9d9d9")
var is_beaten: bool = false

func _ready() -> void:
	label.text = button_title
	label.set("theme_override_colors/font_color", color)

func setup(name: String, title: String, beaten: bool) -> void:
	button_name = name
	button_title = title
	is_beaten = beaten
	if !is_beaten: color = Color("d9d9d9")
	else: color = Color("7cc487ff")

func _on_pressed() -> void:
	ChallengeManager.load_preset(button_name)
	emit_signal("preset_selected", button_name)

func change_color() -> void:
	await get_tree().create_timer(0.01).timeout
	if ChallengeManager.active_preset == button_name:
		color = Color(0.129, 0.365, 1.0, 1.0)
	elif is_beaten:
		color = Color("7cc487ff")
	else:
		color = Color("d9d9d9")
	
	label.set("theme_override_colors/font_color", color)
