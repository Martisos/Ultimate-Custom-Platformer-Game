extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("You won")
		var score_earned = 100
		
		if score_earned > ChallengeManager.high_score:
			ChallengeManager.high_score = score_earned
			ChallengeManager.save_game()
			
		get_tree().reload_current_scene()
