extends BaseLevel


func _ready() -> void:
	
	current_available_units.clear()
	for unit in Globals.unit_metadata:
		var uc = UnitCount.new()
		uc.unit_info = unit
		uc.count = 5
		current_available_units.append(uc)
	super._ready()
