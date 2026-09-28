extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

#--Mirror--
var mirror_level: int = 0
var mirror_timer: float = 0.0
var next_mirror_event_time: float = 0.0
var is_mirrored: bool = false
var mirror_duration: float = 0.0

#--Random Shaders --
var shaders_level: int = 0

func _ready() -> void:
	set_mirror(false)
	mirror_level = ChallengeManager.get_challange_level("mirror")
	if mirror_level == 3:
		set_mirror(true)
	elif mirror_level > 0:
		set_next_time()


func _process(delta: float) -> void:
	if mirror_level == 0 or mirror_level == 3:
		return
	
	mirror_timer += delta
	
	if not is_mirrored:
		if mirror_timer >= next_mirror_event_time:
			start_mirror_event()
	else:
		if mirror_timer >= mirror_duration:
			stop_mirror_event()

func start_mirror_event() -> void:
	set_mirror(true)
	is_mirrored = true
	mirror_timer = 0.0
	
	if mirror_level == 1:
		mirror_duration = randf_range(2.0, 3.5)
	else:
		mirror_duration = randf_range(3.5, 5.0)

func stop_mirror_event() -> void:
	set_mirror(false)
	is_mirrored = false
	mirror_timer = 0.0
	set_next_time()

func set_next_time() -> void:
	match mirror_level:
		1: next_mirror_event_time = randf_range(12.0, 18.0)
		2: next_mirror_event_time = randf_range(6.0, 10.0)

func set_mirror(state: bool) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("mirror_x", state)
