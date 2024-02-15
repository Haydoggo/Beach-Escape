extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(int(Globals.arcade_difficulty_level * 1.5)):
		spawn_hook()

func spawn_hook():
	var hook_scene = load("res://App/Scenes/CutScenes/procreate/ocean_hook.tscn").instantiate()
	add_child(hook_scene)
	var pos_x = get_viewport_rect().size.x * randf_range(0.25, 0.5)
	var pos_y = get_viewport_rect().size.y * randf_range(0.25, 0.75)
	hook_scene.global_position = Vector2(pos_x, pos_y)
	
