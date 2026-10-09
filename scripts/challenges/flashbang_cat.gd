extends CanvasLayer

@export var allCats: Array[Control] = []
@onready var cat_scene: PackedScene = preload("uid://c8tq6x8eucdlx")

var max_new_cat_timer: float = 0.0
var current_timer: float = 0.0
var level: int = 0
var is_flashed: bool = false

func _ready() -> void:
	level = ChallengeManager.get_challange_level("flashbang_cat")
	match level:
		1: max_new_cat_timer = 7.5
		2: max_new_cat_timer = 5.0
		3: max_new_cat_timer = 3.0
	
	if level > 0:
		reset_timer()

func _process(delta: float) -> void:
	if level == 0 or is_flashed: return
	
	current_timer -= delta
	
	if current_timer <= 0.0:
		spawn_new_cat()
		reset_timer()

func reset_timer() -> void:
	current_timer = randf_range(max(1.0, max_new_cat_timer - 2.0), max_new_cat_timer)

func got_flashed(time: float, exploded_cat: Control) -> void:
	is_flashed = true
	
	for cat in allCats:
		if is_instance_valid(cat) and cat != exploded_cat:
			cat.queue_free()
	
	allCats.clear()
	
	var pause_time = max(0.5, time - 1)
	await get_tree().create_timer(pause_time).timeout 
	is_flashed = false

func spawn_new_cat() -> void:
	var newcat: Control = cat_scene.instantiate()
	add_child(newcat)
	allCats.append(newcat)
