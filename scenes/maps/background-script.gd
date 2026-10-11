extends Node2D

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var color_rect: ColorRect = $ColorRect


func _process(delta: float) -> void:
	color_rect.global_position.x = camera.global_position.x - 300
	color_rect.global_position.y = camera.global_position.y - 300
