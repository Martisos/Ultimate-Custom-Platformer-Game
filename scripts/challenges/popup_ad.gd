extends CanvasLayer

@export var ad_images: Array[Texture2D] = []

@onready var ad_container: Control = $AdContainer
@onready var ad_image: TextureRect = $AdContainer/AdImage
@onready var close_button: Button = $AdContainer/CloseButton

var player: CharacterBody2D = null
var timer: float = 0.0
var next_ad_time: float = 0.0
var ad_active: bool = false
var popup_level: int = 0

func _ready() -> void:
	ad_container.visible = false
	
	popup_level = ChallengeManager.get_challange_level("popups")
	
	if popup_level > 0:
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		set_next_ad_time()

func _process(delta: float) -> void:
	if popup_level == 0 or ad_active:
		return
		
	timer += delta
	
	if timer >= next_ad_time:
		if player and player.is_on_floor():
			show_ad()

func set_next_ad_time() -> void:
	match popup_level:
		1:
			print("level 1")
			next_ad_time = randf_range(12.0, 15.0)
			print(next_ad_time)
		2:
			print("level 2")
			next_ad_time = randf_range(8.0, 12.0)
			print(next_ad_time)
		3: 
			print("level 3")
			next_ad_time = randf_range(3.0, 8.0)
			print(next_ad_time)

func show_ad() -> void:
	ad_active = true
	ChallengeManager.is_popup_open = true
	if ad_images.size() > 0:
		ad_image.texture = ad_images.pick_random()
	
	ad_container.visible = true

func _on_close_button_pressed() -> void:
	ad_container.visible = false
	ad_active = false
	ChallengeManager.is_popup_open = false
	timer = 0.0
	set_next_ad_time()
