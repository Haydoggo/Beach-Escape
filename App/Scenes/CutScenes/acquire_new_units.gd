extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for unit_metadata in Globals.unit_metadata:
		var num_remaining = Globals.surviving_units[unit_metadata.name]
		while (num_remaining > 0):
			num_remaining -= 1
			spawn_unit(unit_metadata)
	
func spawn_unit(unit_metadata):
	var new_unit = load("res://App/Scenes/Entities/Units/Procreator.tscn").instantiate()
	var screen_size = get_viewport_rect().size
	new_unit.global_position = Vector2(randf_range(10, screen_size.x-10), randf_range(10, screen_size.y-10))
	new_unit.activate(unit_metadata)
	add_child(new_unit)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
