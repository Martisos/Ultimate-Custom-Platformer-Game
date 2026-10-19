extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("You won")
		var score_earned = ChallengeManager.return_current_points()
		
		check_preset_done()
		
		if score_earned > ChallengeManager.high_score:
			ChallengeManager.high_score = score_earned
			ChallengeManager.is_new_high_score = true
		
		get_tree().change_scene_to_file("res://scenes/menu/win_screen.tscn")

func check_preset_done() -> void:
	if ChallengeManager.active_preset != "":
		var current_preset = ChallengeManager.active_preset
		ChallengeManager.complete_preset(current_preset)
