extends CharacterBody2D

@export var speed: float = 250.0
@export var acceleration: float = 2000.0
@export var friction: float = 1800.0


@export var max_jump_velocity: float = -420.0
@export var min_jump_velocity: float = -100.0


@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time
	
	if Input.is_action_pressed("jump") and coyote_timer > 0.0:
		velocity.y  = max_jump_velocity
		coyote_timer = 0.0
	
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	move_and_slide()
