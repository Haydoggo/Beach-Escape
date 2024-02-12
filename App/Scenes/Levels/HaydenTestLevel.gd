extends BaseLevel


func _ready() -> void:
	for unit in Globals.unit_metadata:
		var uc = UnitCount.new()
		uc.unit_info = unit
		uc.count = 20
		available_units.append(uc)
	super._ready()
