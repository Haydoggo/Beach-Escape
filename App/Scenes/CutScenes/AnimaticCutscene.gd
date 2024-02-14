extends Control

#@export_file("*.tscn") var next_scene_path : String
#var next_scene_path
enum States { RUNNING, ENDING }
var State : States = States.RUNNING

func _ready():
	$AnimationPlayer.play("RESET")
	#next_scene_path = Globals.get_next_level()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET":
		$AnimationPlayer.play("animatic_intro")
	elif anim_name == "animatic_intro":
		Globals.load_next_level()
		#if next_scene_path != "":
			#SceneLoader.load_scene(next_scene_path)

func _input(event):
	if State == States.RUNNING:
		if Input.is_action_just_pressed("ui_cancel"):
			State = States.ENDING
			$AnimationPlayer.seek(10.8, true)
		elif Input.is_action_just_pressed("ui_accept"):
			seek_next_keyframe()
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				seek_next_keyframe()
				
func seek_next_keyframe():
	var seek_points = [ 0, 3.5, 6, 8, 9.5, 10.8 ]
	var current_point = 0
	for i in seek_points.size():
		if $AnimationPlayer.current_animation_position > seek_points[i]:
			current_point = i
	if current_point +1 >= seek_points.size()-1:
		State = States.ENDING
	else:
		$AnimationPlayer.seek(seek_points[min(current_point+1, seek_points.size()-1)])
