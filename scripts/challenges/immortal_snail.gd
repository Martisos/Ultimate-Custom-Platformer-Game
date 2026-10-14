extends Area2D

var speed: float = 0.0
var player: CharacterBody2D = null
var level: int = 0

func _ready() -> void:
	level = ChallengeManager.get_challange_level("immortal_snail")
	
	if level == 0:
		queue_free()
		return
	
	match level:
		1: speed = 12.5
		2: speed = 17.5
		3: speed = 21.5
	
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	
func _process(delta: float) -> void:
	if player and !player.is_dead:
		var direction = global_position.direction_to(player.global_position)
		global_position += direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die("Touched by an Immortal Snail")
