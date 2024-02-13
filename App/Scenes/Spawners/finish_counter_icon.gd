extends BoxContainer
var unit_count = 0
var required_unit_count = 0

func activate(unit_info):
	self.name = unit_info.name.to_pascal_case()
	$UnitIcon.texture = unit_info.icon
	update_text()

func add_unit():
	unit_count += 1
	update_text()
	Globals.surviving_units[self.name] = unit_count

func update_text():
	if required_unit_count > 0:
		$UnitCount.text = "%d/%d" % [unit_count, required_unit_count]
		if unit_count < required_unit_count:
			$UnitCount.modulate = Color.DARK_RED
		else:
			$UnitCount.modulate = Color.LAWN_GREEN
	else:
		$UnitCount.text = str(unit_count)
