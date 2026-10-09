extends Control

@export var speed_array: Array[float] = [0.0, 0.0]
var speed: float = 0.0

@onready var flash_bang_rect: ColorRect = $CanvasLayer/FlashBang

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var sprites_list: Array[Texture] = []
@onready var sprite: Sprite2D = $Sprite2D
var going_left: bool = true

var starting_x: int = 0

var flashbang_time: float = 0.0

func _ready() -> void:
	
	flash_bang_rect.modulate.a = 0.0
	var level: int = ChallengeManager.get_challange_level("flashbang_cat")
	if level == 0: queue_free()
	match level:
		1:
			speed_array = [55.0, 75.0]
			flashbang_time = 1.0
		2:
			speed_array = [80.0, 100.0]
			flashbang_time = 1.5
		3:
			speed_array = [110.0, 130.0]
			flashbang_time = 2.5
	
	speed = randf_range(speed_array[0], speed_array[1])
	
	sprite.texture = sprites_list.pick_random()
	going_left = randf() < 0.5
	
	if going_left:
		sprite.flip_h = false
		starting_x = 640
	else:
		sprite.flip_h = true
		starting_x = -82
	
	global_position.x = starting_x
	global_position.y = randi_range(0, 296)

func _process(delta: float) -> void:
	if going_left:
		global_position.x -= speed * delta
		if(global_position.x <= starting_x - 250):
			flashbang()
	else:
		global_position.x += speed * delta
		if(global_position.x >= starting_x + 250):
			flashbang()


func flashbang() -> void:
	if get_parent().has_method("got_flashed"):
		get_parent().got_flashed(flashbang_time, self)
	
	set_process(false)
	sprite.visible = false
	flash_bang_rect.modulate.a = 1.0
	await get_tree().create_timer(flashbang_time / 2).timeout
	var tween = create_tween()
	tween.tween_property(flash_bang_rect, "modulate:a", 0.0, flashbang_time / 2)
	await tween.finished
	queue_free()


func _on_mouse_entered() -> void:
	set_process(false)
	animation_player.stop()
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
