extends BaseLevel


func _ready() -> void:
	
	available_units.clear()
	for unit in Globals.unit_metadata:
		var uc = UnitCount.new()
		uc.unit_info = unit
		uc.count = 5
		available_units.append(uc)
	super._ready()
