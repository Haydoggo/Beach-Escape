extends Area2D

var finish_button = preload("res://App/Scenes/Spawners/finish_counter_icon.tscn")

enum States { WAITING, LISTENING }
var State = States.WAITING

func _on_area_entered(area):
	if area.owner != null and area.owner.is_in_group("Units"):
		var unit = area.owner
		if unit.get("unit_info"):
			if $CompletedUnitCounters.has_node(unit.unit_info.name):
				$CompletedUnitCounters.get_node(unit.unit_info.name).add_unit()
			else:
				var new_unit_counter = finish_button.instantiate()
				new_unit_counter.activate(unit.unit_info)
				$CompletedUnitCounters.add_child(new_unit_counter)

func _process(_delta):
	if State == States.LISTENING and Engine.get_process_frames() % 10 == 0:
		var units_remaining = get_unit_count_on_field()
		if units_remaining == 0:
			print("Level Complete!")
		else:
			print("Units remaining: ", units_remaining )


func get_unit_count_on_field():
	var num_units = get_tree().get_nodes_in_group("Units").size()
	return num_units
	
func _on_last_unit_sent():
	# start checking the field to see if there are any units remaining alive
	State = States.LISTENING
