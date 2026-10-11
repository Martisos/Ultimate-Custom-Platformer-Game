extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var level: int = 0
var radius: float = 0.0

func _ready() -> void:
	level = ChallengeManager.get_challange_level("flashlight")
	
	if level == 0:
		queue_free()
		return
	
	match level:
		1: radius = 175.0
		2: radius = 150.0
		3: radius = 125.0
	
	var screen_size = get_viewport().get_visible_rect().size
	color_rect.material.set_shader_parameter("screen_size", screen_size)
	color_rect.material.set_shader_parameter("radius", radius)

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	color_rect.material.set_shader_parameter("mouse_position", mouse_pos)
