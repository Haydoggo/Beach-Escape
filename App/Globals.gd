## Store stuff here to persist between levels

extends Node

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




