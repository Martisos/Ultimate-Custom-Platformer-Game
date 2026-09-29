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
var shader_timer: float = 0.0
var next_shader_time: float = 0.0
var is_shader_active: bool = false
var shader_duration: float = 5.0
var current_active_shader: String = ""

var avaiable_shaders: Array[String] = [
	#"grayscale",
	#"invert_colors",
	"zoom_blur"
]

func _process(delta: float) -> void:
	_process_mirror(delta)
	_process_random_shaders(delta)

func _ready() -> void:
	reset_all_shaders()
	
	mirror_level = ChallengeManager.get_challange_level("mirror")
	if mirror_level > 0:
		set_next_mirror_time()
		
	# Inicjalizacja Random Shaders
	shaders_level = ChallengeManager.get_challange_level("random_shaders")
	if shaders_level > 0:
		set_next_shader_time()


# --MIRROR--


func _process_mirror(delta: float) -> void:
	if mirror_level == 0:
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
	set_next_mirror_time()

func set_next_mirror_time() -> void:
	match mirror_level:
		1: next_mirror_event_time = randf_range(12.0, 18.0)
		2: next_mirror_event_time = randf_range(6.0, 10.0)
		3: next_mirror_event_time = randf_range(1.0, 5.0)

func set_mirror(state: bool) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("mirror_x", state)


# --RANDOM SHADERS--


func _process_random_shaders(delta: float) -> void:
	if shaders_level == 0:
		return
	
	shader_timer += delta
	
	if not is_shader_active:
		if shader_timer >= next_shader_time:
			start_random_shader()
	else:
		if shader_timer >= shader_duration:
			stop_random_shader()

func start_random_shader() -> void:
	current_active_shader = avaiable_shaders.pick_random()
	print(current_active_shader)
	set_shader_param(current_active_shader, true)
	
	is_shader_active = true
	shader_timer = 0.0
	
	shader_duration = randf_range(3.0, 10.0)

func stop_random_shader() -> void:
	if current_active_shader != "":
		set_shader_param(current_active_shader, false)
		current_active_shader = ""
	
	is_shader_active = false
	shader_timer = 0.0
	set_next_shader_time()

func set_next_shader_time() -> void:
	match shaders_level:
		1: next_shader_time = randf_range(20.0, 25.0)
		2: next_shader_time = randf_range(15.0, 20.0)
		3: next_shader_time = randf_range(5.0, 12.5)

func set_shader_param(param_name: String, value: bool) -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter(param_name, value)


func reset_all_shaders() -> void:
	set_mirror(false)
	for shader in avaiable_shaders:
		set_shader_param(shader, false)
