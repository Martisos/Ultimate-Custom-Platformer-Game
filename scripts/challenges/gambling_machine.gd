extends CanvasLayer

@onready var container: Control = $Control
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var icon_1: TextureRect = $Control/HBoxContainer/Icon1
@onready var icon_2: TextureRect = $Control/HBoxContainer/Icon2
@onready var icon_3: TextureRect = $Control/HBoxContainer/Icon3

@export var skull_icon: Texture
@export var other_icons: Array[Texture] = []

var player: CharacterBody2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	
	play_gambling_sequence()

func play_gambling_sequence() -> void:
	var tween = create_tween().set_parallel(false)
	tween.tween_property(container, "position:y", 25.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(roll_slots)
	tween.tween_interval(1.5)
	tween.tween_property(container, "position:y", -25.0, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	

func roll_slots() -> void:
	var is_death_roll: bool = randf() < 0.05
	var used_textures: Array[Texture] = []
	
	if is_death_roll and skull_icon:
		icon_1.texture = skull_icon
		icon_2.texture = skull_icon
		icon_3.texture = skull_icon
		print("JAAAACKPOOOOT")
		
		if player: player.die("HIT A JACKPOT")
	else:
		for i in range(0, 3):
			print(i)
		icon_1.texture = other_icons.pick_random()
		icon_2.texture = other_icons.pick_random()
		icon_3.texture = other_icons.pick_random()
			
