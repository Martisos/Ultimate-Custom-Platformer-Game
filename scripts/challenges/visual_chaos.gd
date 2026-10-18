extends CanvasLayer

@onready var firework_rect: ColorRect = $FireworkRect

var level: int = 0
var timer: float = 0.0
var next_event_time: float = 0.0
var is_active: bool = false


func _ready() -> void:
	level = ChallengeManager.get_challange_level("visual_effects")
	
	if level == 0:
		queue_free()
		return
	
	firework_rect .hide()
	set_next_firework_time()


func _process(delta: float) -> void:
	if level == 0: return
	
	timer += delta
	
	if !is_active:
		if timer >= next_event_time:
			start_fireworks()
	else:
		if timer >= 5.0:
			stop_fireworks()

func start_fireworks() -> void:
	is_active = true
	timer = 0.0
	firework_rect.show()
	
	var mat = firework_rect.material as ShaderMaterial
	
	match level:
		1:
			mat.set_shader_parameter("firework_count", 10)
			mat.set_shader_parameter("particle_count", 35)
		2:
			mat.set_shader_parameter("firework_count", 30)
			mat.set_shader_parameter("particle_count", 40)
		3:
			mat.set_shader_parameter("firework_count", 45)
			mat.set_shader_parameter("particle_count", 50)

func stop_fireworks() -> void:
	is_active = false
	timer = 0.0
	firework_rect.hide()
	set_next_firework_time()

func set_next_firework_time() -> void:
	match level:
		1: next_event_time = randf_range(10.0, 12.5)
		2: next_event_time = randf_range(7.5, 10)
		3: next_event_time = randf_range(5.0, 7.5)
