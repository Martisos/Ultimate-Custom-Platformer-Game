extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 100.0
@export var acceleration: float = 2000.0
@export var friction: float = 1800.0


@export var max_jump_velocity: float = -250.0
@export var min_jump_velocity: float = -25.0

# -- FALLING --
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0
var was_in_air: bool = false

var direction
var current_anim: String = ""

# -- FALL DAMAGE --
var fall_time: float = 0.0
var max_fall_time: float = INF

# -- RANDOM ANIMATIONS --
var random_anim_level: int = 0
var random_anim_timer: float = 0.0
var is_random_anim_active: bool = false
var current_troll_anim: String = ""
var available_random_anims: Array[String] = ["jump_up", "jump_down", "walk", "idle", "death"]

# -- RANDOM FLIP --
var random_flip_timer: float = 0.0
var is_random_flip_active: bool = false
var current_troll_flip: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


var is_dead: bool = false

func _ready() -> void:
	apply_modifiers()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if !is_dead:
			coyote_timer -= delta
			if velocity.y > 0:
				fall_time += delta
			else:
				fall_time = 0.0
	else:
		if !is_dead:
			coyote_timer = coyote_time
			fall_time = 0.0
		
	if is_dead:
		move_and_slide()
		return
	
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		velocity.y  = max_jump_velocity
		coyote_timer = 0.0
		fall_time = 0.0
	
	if ChallengeManager.get_challange_level("rigid_jump") == 0:
		if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity
		
		
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		
		if not is_random_flip_active:
			sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	if is_random_flip_active:
		sprite.flip_h = current_troll_flip
	
	move_and_slide()
	
	if was_in_air and is_on_floor():
		
		if fall_time >= max_fall_time:
			print(fall_time)
			die("Fall Damage (Dark souls style)")
		else:
			trigger_land_squash()
			fall_time = 0.0
			
	was_in_air = not is_on_floor()
	
	process_random_animations(delta)
	process_random_flip(delta)
	update_animation()


func process_random_animations(delta: float) -> void:
	if random_anim_level == 0: return
	
	random_anim_timer -= delta
	
	if not is_random_anim_active:
		if random_anim_timer <= 0.0:
			is_random_anim_active = true
			current_troll_anim = available_random_anims.pick_random()
			random_anim_timer = randf_range(0.5, 1.5)
	else:
		if random_anim_timer <= 0.0:
			is_random_anim_active = false
			set_next_random_anim_time()
			set_next_random_flip_time()

func process_random_flip(delta: float) -> void:
	if random_anim_level == 0: return
	
	random_flip_timer -= delta
	
	if !is_random_flip_active:
		if random_flip_timer <= 0.0:
			is_random_flip_active = true
			current_troll_flip = randf() < 0.5
			
			if random_anim_level == 3:
				random_flip_timer = 0.1
			else:
				random_flip_timer = 0.5
	else:
		if random_flip_timer <= 0.0:
			is_random_flip_active = false
			set_next_random_flip_time()
			

func set_next_random_anim_time() -> void:
	match random_anim_level:
		1: random_anim_timer = randf_range(2.0, 5.0)
		2: random_anim_timer = randf_range(1.0, 3.0)
		3: random_anim_timer = randf_range(0.2, 0.8)

func set_next_random_flip_time() -> void:
	match random_anim_level:
		1: random_flip_timer = randf_range(1.0, 3.0)
		2: random_flip_timer = randf_range(0.5, 2.0)
		3: random_flip_timer = randf_range(0.2, 0.5)

func trigger_land_squash() -> void:
	sprite.scale = Vector2(1.2, 0.8)
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)



func update_animation() -> void:
	if is_dead: return
	
	var target_anim: String = ""
	
	if not is_on_floor():
		velocity
		
		if velocity.y < 0:
			target_anim = "jump_up"
		else:
			target_anim = "jump_down"
	elif direction != 0:
		target_anim = "walk"
	else:
		target_anim = "idle"
	
	if is_random_anim_active:
		target_anim = current_troll_anim
	
	if current_anim != target_anim:
		current_anim = target_anim
		animation_player.play(target_anim)


func apply_modifiers() -> void:
	#ice
	var ice_lvl = ChallengeManager.get_challange_level("ice_floor")
	if ice_lvl > 0:
		friction = friction / (ice_lvl * 4.5)
		acceleration = acceleration / (ice_lvl * 3.5)
	
	#fall damage
	var fall_damage_level = ChallengeManager.get_challange_level("fall_damage")
	match fall_damage_level:
		1: max_fall_time = 0.41
		2: max_fall_time = 0.37
		3: max_fall_time = 0.34
		_: max_fall_time = INF
	
	#random animations & flips
	random_anim_level = ChallengeManager.get_challange_level("random_animations")
	if random_anim_level > 0:
		set_next_random_anim_time()
		set_next_random_flip_time()
	
	
func die(reason: String = "") -> void:
	if is_dead: return
	is_dead = true
	
	ChallengeManager.death_cause = reason
	
	var animation_death_deaths : Array[String] = [
		"Fall Damage (Dark souls style)",
		"Touched by an Immortal Snail"
	]
	
	velocity.x = 0 
	print("Died: ", reason)
	
	if animation_death_deaths.has(reason):
		animation_player.play("death")
		await get_tree().create_timer(1.5).timeout
	TransitionScreen.change_scene("res://scenes/menu/death_screen.tscn")
