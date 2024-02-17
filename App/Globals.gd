## Store stuff here to persist between levels

extends Node

# Puzzle levels are custom hand-crafted puzzles, with specified starting units and completion requirements
# Arcade levels are procedurally generated levels, with increasing difficulty and 
enum game_modes { PUZZLE, ARCADE }
var game_mode = game_modes.PUZZLE
var arcade_difficulty_level = 0 # increments with each arcade level completed
var max_units_per_type : int = 20

var arcade_level_path = "res://App/Scenes/Levels/arcade_level.tscn"

var level_paths = [
	"res://App/Scenes/Levels/Level0.tscn",
	"res://App/Scenes/Levels/Level1.tscn",
	"res://App/Scenes/Levels/Level2.tscn",
	"res://App/Scenes/Levels/Level3.tscn",
	"res://App/Scenes/Levels/FirstLevel.tscn",
	"res://App/Scenes/Levels/SecondLevel.tscn",
	"res://App/Scenes/CutScenes/win_screen.tscn"
]

var current_level_index : int = -1 # so get_next_level() returns 0 on first call
var current_level_path
var current_level : BaseLevel
var arrived_units : Dictionary
var current_requirements : Array[UnitCount]
var tile_size # from playspace sizer

var unit_metadata : Array[UnitInfo] = [
	load("res://App/Scenes/Entities/Units/Crab/CrabInfo.tres"),
	load("res://App/Scenes/Entities/Units/Fish/FishInfo.tres"),
	load("res://App/Scenes/Entities/Units/Urchin/UrchinInfo.tres"),
	load("res://App/Scenes/Entities/Units/Seahorse/SeahorseInfo.tres"),
	load("res://App/Scenes/Entities/Units/Mudfish/MudfishInfo.tres"),
	load("res://App/Scenes/Entities/Units/Shark/SharkInfo.tres"),
	load("res://App/Scenes/Entities/Units/Pufferfish/PufferfishInfo.tres"),
	load("res://App/Scenes/Entities/Units/Octopus/OctopusInfo.tres"),
	load("res://App/Scenes/Entities/Units/SeaSlug/SeaSlugInfo.tres"),
	load("res://App/Scenes/Entities/Units/GoldFish/GoldFishInfo.tres"),
]

var surviving_units = {
	"Fish" : 2,
	"Crab" : 2,
	"Urchin" : 2,
	"Seahorse" : 2,
	"Mudfish" : 0,
	"Shark" : 0,
	"Pufferfish": 0,
	"Octopus" : 0,
	"Sea Slug" : 0,
	"Gold Fish" : 0,
} # key is the name of the units, value is the int count

var tower_paths = {
	"SandCannon":"res://App/Scenes/Entities/Towers/CannonTower.tscn",
	"TackBurst":"res://App/Scenes/Entities/Towers/AoETower2_TackBurst.tscn",
	"Pelican":"res://App/Scenes/Entities/Towers/PelicanTower.tscn",
	"EelGrass":"res://App/Scenes/Entities/Towers/EelGrassGlueTower.tscn",
	"BrokenBottle":"res://App/Scenes/Entities/Towers/BrokenBottle_BleedTower.tscn",
	#"Seagull":"res://App/Scenes/Entities/Towers/SeagullTrap.tscn",
	"SeagullPerch":"res://App/Scenes/Entities/Towers/SeagullPerch.tscn",
	"PitTrap":"res://App/Scenes/Entities/Towers/PitTrap.tscn",
	"Rock":"res://App/Scenes/Entities/Towers/RockObstacle.tscn",
	"FishingHook":"res://App/Scenes/Entities/Towers/NewFishingHook_YeetTower.tscn",
	#"RotatingTower":"res://App/Scenes/Entities/Towers/RotatingTower.tscn",
	#"HandSlap":"res://App/Scenes/Entities/Towers/HandSlapTower.tscn",
}

func load_next_level():
	if game_mode == game_modes.ARCADE:
		arcade_difficulty_level += 1
		SceneLoader.load_scene(arcade_level_path)

	elif game_mode == game_modes.PUZZLE:
		current_level_index += 1
		if current_level_index < level_paths.size():
			SceneLoader.load_scene(level_paths[current_level_index])
		else:
			printerr("Global.gd: current_level_index out of bounds in load_next_level")

func restart_level():
	if game_mode == game_modes.PUZZLE:
		if current_level_index < level_paths.size():
			SceneLoader.load_scene(level_paths[current_level_index])
		else:
			printerr("Global.gd: current_level_index out of bounds in load_next_level")
	elif game_mode == game_modes.ARCADE:
		SceneLoader.load_scene(arcade_level_path)
