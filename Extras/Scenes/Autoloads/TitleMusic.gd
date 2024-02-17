extends Node


func play_music():
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("fade_in"):
		$AnimationPlayer.play("fade_in")
	

func stop_music():
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("fade_out"):
		$AnimationPlayer.play("fade_out")
