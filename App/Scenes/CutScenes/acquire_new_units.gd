extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for unit_metadata in Globals.unit_metadata:
		var num_remaining = Globals.surviving_units[unit_metadata.name]
		while (num_remaining > 0):
			num_remaining -= 1
			spawn_unit(unit_metadata.packed_scene_path)
	
func spawn_unit(scene_path):
	var new_unit = load(scene_path).instantiate()
	var size = get_viewport_rect().size
	new_unit.global_position = Vector2(randf_range(10, size.x-10), randf_range(10, size.y-10))
	add_child(new_unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
