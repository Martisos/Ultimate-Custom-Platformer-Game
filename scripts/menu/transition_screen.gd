extends CanvasLayer

@onready var container: Control = $Container
@onready var dark_1: ColorRect = $Container/Dark1
@onready var dark_2: ColorRect = $Container/Dark2
@onready var dark_3: ColorRect = $Container/Dark3

var screen_width: float = 0 

func _ready() -> void:
	screen_width = get_viewport().get_visible_rect().size.x
	
	container.hide()
	
	dark_1.position.x = screen_width
	dark_2.position.x = screen_width
	dark_3.position.x = screen_width

func change_scene(target_scene: String) -> void:
	container.show()
	await to_darkness()
	get_tree().change_scene_to_file(target_scene)
	await from_darkness()
	container.hide()

func to_darkness() -> void:
	dark_1.position.x = screen_width
	dark_2.position.x = screen_width
	dark_3.position.x = screen_width
	
	var tween = create_tween().set_parallel(true)
	var speed: float = 0.3
	
	tween.tween_property(dark_1, "position:x", 0.0, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(dark_2, "position:x", 0.0, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.1)
	tween.tween_property(dark_3, "position:x", 0.0, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.2)
	
	await tween.finished

func from_darkness() -> void:
	var tween = create_tween().set_parallel(true)
	var speed: float = 0.3
	
	
	tween.tween_property(dark_1, "position:x", -screen_width, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(dark_2, "position:x", -screen_width, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.1)
	tween.tween_property(dark_3, "position:x", -screen_width, speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.2)
	
	await tween.finished
