extends Node

var level: int = 0
var timer: float = 0.0
var next_time: float = 10.0

@onready var gambling_scene: PackedScene = preload("uid://bc1ak8jcm5e71")

func _ready() -> void:
	level = ChallengeManager.get_challange_level("gambling")
	if level > 0:
		set_next_time()

func _process(delta: float) -> void:
	if level == 0: return
	timer += delta
	
	if timer >= next_time:
		spawn_machine()
		timer = 0.0
		set_next_time()


func spawn_machine() -> void:
	var machine = gambling_scene.instantiate()
	get_tree().current_scene.add_child(machine)

func set_next_time():
	match level:
		1: next_time = randf_range(12.5, 15)
		2: next_time = randf_range(7.5, 12.5)
		3: next_time = randf_range(5, 7.5)
