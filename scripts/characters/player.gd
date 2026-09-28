extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 100.0
@export var acceleration: float = 2000.0
@export var friction: float = 1800.0


@export var max_jump_velocity: float = -275.0
@export var min_jump_velocity: float = -25.0


@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0

var direction
var was_in_air: bool = false
var current_anim: String = ""

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	apply_modifiers()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time
	
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		velocity.y  = max_jump_velocity
		coyote_timer = 0.0
	
	if ChallengeManager.get_challange_level("rigid_jump") == 0:
		if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity
	
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.flip_h = (direction < 0)
		
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	move_and_slide()
	
	if was_in_air and is_on_floor():
		trigger_land_squash()
	
	was_in_air = not is_on_floor()
	
	update_animation()

func trigger_land_squash() -> void:
	sprite.scale = Vector2(1.2, 0.8)
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func update_animation() -> void:
	var target_anim: String = ""
	
	if not is_on_floor():
		if velocity.y < 0:
			target_anim = "jump_up"
		else:
			target_anim = "jump_down"
	elif direction != 0:
		target_anim = "walk"
	else:
		target_anim = "idle"
	
	if current_anim != target_anim:
		current_anim = target_anim
		animation_player.play(target_anim)

func apply_modifiers() -> void:
	# ice floor
	var ice_lvl = ChallengeManager.get_challange_level("ice_floor")
	if ice_lvl > 0:
		friction = friction / (ice_lvl * 4.5)
		acceleration = acceleration / (ice_lvl * 3.5)

func die(reason: String = "") -> void:
	print("Died: ", reason)
	get_tree().reload_current_scene()
