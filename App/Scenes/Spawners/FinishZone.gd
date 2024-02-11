extends Area2D

var finish_button = preload("res://App/Scenes/Spawners/finish_counter_icon.tscn")
@export var next_scene_path = "res://App/Scenes/CutScenes/acquire_new_units.tscn"

enum States { WAITING, LISTENING }
var State = States.WAITING

func _on_area_entered(area):
	if area.owner != null and area.owner.is_in_group("Units"):
		var unit = area.owner
		if unit.get("unit_info"):
			if not $CompletedUnitCounters.has_node(unit.unit_info.name):
				# add a new icon
				var new_unit_counter = finish_button.instantiate()
				new_unit_counter.activate(unit.unit_info)
				$CompletedUnitCounters.add_child(new_unit_counter)
			$CompletedUnitCounters.get_node(unit.unit_info.name).add_unit()
			
		if area.owner.has_method("_on_finish_line_crossed"):
			area.owner._on_finish_line_crossed()

func _process(_delta):
	if State == States.LISTENING and Engine.get_process_frames() % 10 == 0:
		var units_remaining = get_unit_count_on_field()
		if units_remaining == 0:
			print("Level Complete!")
			SceneLoader.load_scene(next_scene_path)
		


	

func get_unit_count_on_field():
	var num_units = get_tree().get_nodes_in_group("Units").size()
	
	return num_units
	
func _on_last_unit_sent():
	# start checking the field to see if there are any units remaining alive
	State = States.LISTENING
