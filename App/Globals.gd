## Store stuff here to persist between levels

extends Node

var level_paths = [
	"res://App/Scenes/Levels/FirstLevel.tscn",
	"res://App/Scenes/Levels/SecondLevel.tscn",
]

var current_level_index : int = -1 # so get_next_level() returns 0 on first call
var current_level : BaseLevel

var unit_metadata : Array[UnitInfo] = [
	load("res://App/Scenes/Entities/Units/Crab/CrabInfo.tres"),
	load("res://App/Scenes/Entities/Units/Fish/FishInfo.tres"),
	load("res://App/Scenes/Entities/Units/Urchin/UrchinInfo.tres"),
]

var surviving_units = {
	"Fish" : 4,
	"Crab" : 4,
	"Urchin" : 4,
} # key is the name of the units, value is the int count


func load_next_level():
	current_level_index += 1
	if current_level_index < level_paths.size():
		SceneLoader.load_scene(level_paths[current_level_index])
	else:
		printerr("Global.gd: current_level_index out of bounds in load_next_level")
