extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("You won")
		var score_earned = ChallengeManager.return_current_points()
		
		if score_earned > ChallengeManager.high_score:
			ChallengeManager.high_score = score_earned
			ChallengeManager.save_game()
			
		get_tree().change_scene_to_file("res://scenes/menu/challenge_menu.tscn")
