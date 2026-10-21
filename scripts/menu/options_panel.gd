extends CanvasLayer

@onready var control: Control = $Control
@onready var container: Control = $Control/Container
@onready var music_slider: HSlider = $Control/Container/VBoxContainer/MusicVolume/MusicSlider
@onready var sfx_slider: HSlider = $Control/Container/VBoxContainer/SFXVolume/SFXSlider
@onready var menu_button: Button = $Control/Container/VBoxContainer/HBoxContainer/MenuButton

var music_bus: int
var sfx_bus: int

var music_volume: float = 1.0
var sfx_volume: float = 1.0

var can_show: bool = true

func _ready() -> void:
	control.hide()
	
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if control.visible:
			hide_panel()
		else:
			if get_tree().current_scene.name == "ChallengeMenu":
				menu_button.hide()
				show_panel()
			elif get_tree().current_scene.name == "World1":
				menu_button.show()
				show_panel()

func show_panel() -> void:
	if can_show:
		sfx_slider.value = sfx_volume
		music_slider.value = music_volume
		control.show()
		control.mouse_filter = Control.MOUSE_FILTER_STOP
		get_tree().paused = true

func hide_panel() -> void:
	control.hide()
	ChallengeManager.save_game()
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().paused = false


func _on_continue_button_pressed() -> void:
	hide_panel()

func _on_menu_button_pressed() -> void:
	control.hide()
	TransitionScreen.change_scene("res://scenes/menu/challenge_menu.tscn")

func _on_music_slider_value_changed(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(max(value, 0.001)))
	AudioServer.set_bus_mute(music_bus, value == 0.0)

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(max(value, 0.001)))
