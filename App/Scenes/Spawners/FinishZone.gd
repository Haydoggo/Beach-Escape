extends Area2D

var finish_button = preload("res://App/Scenes/Spawners/finish_counter_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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

	
