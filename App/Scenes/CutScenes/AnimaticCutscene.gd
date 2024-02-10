extends Control

@export_file("*.tscn") var next_scene_path : String
enum States { RUNNING, ENDING }
var State : States = States.RUNNING

func _ready():
	$AnimationPlayer.play("RESET")
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET":
		$AnimationPlayer.play("animatic_intro")
	elif anim_name == "animatic_intro":
		if next_scene_path != "":
			SceneLoader.load_scene(next_scene_path)

func _unhandled_input(_event):
	if State == States.RUNNING:
		if Input.is_action_just_pressed("ui_cancel"):
			State == States.ENDING
			$AnimationPlayer.seek(10.8, true)
		elif Input.is_action_just_pressed("ui_accept"):
			var seek_points = [ 0, 3.5, 6, 8, 9.5, 10.8 ]
			var current_point = 0
			for i in seek_points.size():
				if $AnimationPlayer.current_animation_position > seek_points[i]:
					current_point = i
			if current_point +1 >= seek_points.size()-1:
				State == States.ENDING
			else:
				$AnimationPlayer.seek(seek_points[min(current_point+1, seek_points.size()-1)])
			
