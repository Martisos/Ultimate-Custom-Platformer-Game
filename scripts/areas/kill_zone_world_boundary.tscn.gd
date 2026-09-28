extends Area2D

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("die"):
			body.die("Fall")
