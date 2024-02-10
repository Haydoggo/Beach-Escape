class_name UnitCount extends Resource

signal count_updated

@export var unit_info : UnitInfo
@export var count : int:
	set(v):
		count = v
		count_updated.emit()
	
