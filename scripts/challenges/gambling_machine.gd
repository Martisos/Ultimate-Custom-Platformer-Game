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
	tween.tween_callback(func(): roll_slots_sequentially())
	tween.tween_interval(4.5)
	tween.tween_property(container, "position:y", -200.0, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)



func roll_slots_sequentially() -> void:
	var is_death_roll: bool = randf() < 0.05
	var slots: Array = h_box_container.get_children()
	
	if is_death_roll and skull_icon:
		for slot: TextureRect in slots:
			for i in range(0, 10):
				slot.texture = other_icons.pick_random()
				await get_tree().create_timer(0.1).timeout
			slot.texture = skull_icon
		
		await get_tree().create_timer(0.5).timeout
		if player: 
			player.die("HIT A JACKPOT (3 Skulls)")
			
	else:
		var drawn_textures: Array[Texture] = []
		
		for index in range(slots.size()):
			var slot: TextureRect = slots[index]
			
			for i in range(0, 10):
				slot.texture = other_icons.pick_random()
				await get_tree().create_timer(0.1).timeout
				
			var final_texture = other_icons.pick_random()
			
			if index == 2 and drawn_textures[0] == drawn_textures[1]:
				while final_texture == drawn_textures[0]:
					final_texture = other_icons.pick_random()
			else:
				while drawn_textures.has(final_texture) and other_icons.size() > 2:
					final_texture = other_icons.pick_random()
			
			drawn_textures.append(final_texture)
			slot.texture = final_texture
