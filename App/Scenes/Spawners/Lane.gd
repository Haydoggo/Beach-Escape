extends Marker2D

var queued_units = []
var max_queue_size : int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn(unit_scene):
	var new_unit = unit_scene.instantiate()
	assert( $QueuedUnits.get_child_count() > 0)
	add_child(new_unit)
	new_unit.global_position = global_position
	$QueuedUnits.get_child(0).queue_free() # remove the icon


func _on_spawn_timer_timeout():
	if queued_units.size() > 0:
		spawn(queued_units.pop_front())
		

func queue_spawn(unit_scene):
	if queued_units.size() < max_queue_size:
		# briefly load the scene, so we can grab an icon, then drop it
		var new_unit = unit_scene.instantiate()
		var icon = new_unit.generate_icon()
		$QueuedUnits.add_child(icon)
		queued_units.push_back(unit_scene)
		#$QueuedUnits.move_child(icon, 0)
		new_unit.queue_free()
