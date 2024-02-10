@tool
class_name UnitCount extends Resource

signal count_updated

@export var unit_info : UnitInfo:
	set(v):
		unit_info = v
		update_name()

@export var count : int:
	set(v):
		count = v
		count_updated.emit()
		update_name()

func update_name():
	resource_name = "%d %s" % [count, unit_info.name]
