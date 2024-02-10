extends BoxContainer
var unit_count = 0

func activate(unit_info):
	self.name = unit_info.name
	$UnitIcon.texture = unit_info.icon
	$UnitCount.text = str(unit_count)

func add_unit():
	unit_count += 1
	$UnitCount.text = str(unit_count)
	Globals.surviving_units[self.name] = unit_count
