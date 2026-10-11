extends Control

var dead_pixels: Array[Vector2] = []

var pixel_size: Vector2 = Vector2(3.0 , 3.0)

var timer: float = 0.0
var spawn_interval: float = 1.0
var pixels_per_tick: int = 1
var level: int = 0

var screen_size: Vector2

func _ready() -> void:
	level = ChallengeManager.get_challange_level("dead_pixels")
	
	if level == 0:
		get_parent().queue_free()
		return
	
	screen_size = get_viewport_rect().size
	
	match level:
		1:
			spawn_interval = 2.0
			pixels_per_tick = 5
		2:
			spawn_interval = 1.5
			pixels_per_tick = 10
		3:
			spawn_interval = 1
			pixels_per_tick = 3

func _process(delta: float) -> void:
	if level == 0:
		return
	
	timer -= delta
	
	if timer <= 0:
		spawn_new_pixels()
		timer = spawn_interval
		pixels_per_tick += 1

func spawn_new_pixels() -> void:
	for i in range(pixels_per_tick):
		var random_x = randi_range(0, screen_size.x)
		var random_y = randi_range(0, screen_size.y)
		dead_pixels.append(Vector2(random_x, random_y))
	queue_redraw()

func _draw() -> void:
	for pos in dead_pixels:
		draw_rect(Rect2(pos, pixel_size), Color.BLACK)
