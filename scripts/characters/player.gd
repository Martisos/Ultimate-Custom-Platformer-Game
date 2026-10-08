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

var fall_time: float = 0.0
var max_fall_time: float = INF

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dead: bool = false

func _ready() -> void:
	apply_modifiers()
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	
	if is_dead: return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
		
		if velocity.y > 0:
			fall_time += delta
			print(fall_time)
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
		
		if fall_time >= max_fall_time:
			die("Fall Damage (Dark souls style)")
		else:
			trigger_land_squash()
			fall_time = 0.0
			
	was_in_air = not is_on_floor()
	
	update_animation()

func trigger_land_squash() -> void:
	sprite.scale = Vector2(1.2, 0.8)
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		get_tree().reload_current_scene()

func update_animation() -> void:
	if is_dead: return
	
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
	var ice_lvl = ChallengeManager.get_challange_level("ice_floor")
	if ice_lvl > 0:
		friction = friction / (ice_lvl * 4.5)
		acceleration = acceleration / (ice_lvl * 3.5)
	
	#fall damage
	var fall_damage_level = ChallengeManager.get_challange_level("fall_damage")
	match fall_damage_level:
		1: max_fall_time = 1.0
		2: max_fall_time = 0.6
		3: max_fall_time = 0.39
		_: max_fall_time = INF

func die(reason: String = "") -> void:
	if is_dead: return
	is_dead = true
	
	velocity = Vector2.ZERO
	print("Died: ", reason)
	
	if reason == "Fall Damage (Dark souls style)":
		animation_player.play("death")
	else:
		get_tree().reload_current_scene()
