extends Marker2D

var queued_units = []
var max_queue_size : int = 5


func spawn(unit_info : UnitInfo):
	var new_unit = unit_info.packed_scene.instantiate()
	assert( $QueuedUnits.get_child_count() > 0)
	add_child(new_unit)
	new_unit.global_position = global_position
	$QueuedUnits.get_child(0).queue_free() # remove the icon


func _on_spawn_timer_timeout():
	if queued_units.size() > 0:
		spawn(queued_units.pop_front())
	for child in get_children():
		if child is BaseUnit:
			child.move()


func queue_spawn(unit_info : UnitInfo):
	if queued_units.size() < max_queue_size:
		var icon = TextureRect.new()
		icon.texture = unit_info.icon
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.custom_minimum_size = Vector2(128,128)
		$QueuedUnits.add_child(icon)
		queued_units.push_back(unit_info)
		return true
	else:
		return false
