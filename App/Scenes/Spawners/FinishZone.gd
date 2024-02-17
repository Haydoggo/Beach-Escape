extends Area2D

const finish_button = preload("res://App/Scenes/Spawners/finish_counter_icon.tscn")
@export var next_scene_path = "res://App/Scenes/CutScenes/procreate_acquire_new_units.tscn"

enum States { WAITING, LISTENING }
var State = States.WAITING
@onready var level : BaseLevel = owner
var arrived_units = {} # key is String name, value is int count

func _ready() -> void:
	$CompletedUnitCounters/PreviewFinishCounter.free()
	Globals.arrived_units = arrived_units
	for unit_info in Globals.unit_metadata:
		arrived_units[unit_info.name] = 0
	for unit_count in level.required_units_for_win:
		var new_unit_counter = finish_button.instantiate()
		new_unit_counter.required_unit_count = unit_count.count
		new_unit_counter.activate(unit_count.unit_info)
		$CompletedUnitCounters.add_child(new_unit_counter)
		await get_tree().create_timer(0.3).timeout

func _on_area_entered(area):
	if area.owner != null and area.owner.is_in_group("Units"):
		var unit = area.owner
		if unit.get("unit_info"):
			if not $CompletedUnitCounters.has_node(unit.unit_info.name.to_pascal_case()):
				# add a new icon
				var new_unit_counter = finish_button.instantiate()
				new_unit_counter.activate(unit.unit_info) # sets the name
				$CompletedUnitCounters.add_child(new_unit_counter)
			$CompletedUnitCounters.get_node(unit.unit_info.name.to_pascal_case()).add_unit()
			arrived_units[unit.unit_info.name] += 1
			
		if area.owner.has_method("_on_finish_line_crossed"):
			area.owner._on_finish_line_crossed()

func _process(_delta):
	if State == States.LISTENING and Engine.get_process_frames() % 10 == 0:
		var units_remaining = get_unit_count_on_field()
		if units_remaining == 0:
			
			if has_enough_units_to_win():
				if Globals.game_mode == Globals.game_modes.PUZZLE:
					print("Level Complete!")
					Globals.load_next_level()
				else:
					SceneLoader.load_scene("res://App/Scenes/CutScenes/procreate_acquire_new_units.tscn")
				#SceneLoader.load_scene(next_scene_path)
			else:
				await get_tree().create_timer(1).timeout
				SceneLoader.load_scene("res://App/Scenes/Menus/EndGameScreens/LoseScreen.tscn")


func has_enough_units_to_win() -> bool:
	if Globals.game_mode == Globals.game_modes.PUZZLE:
		# count the specific types of fish and compare with level designer's requirements for that level
		for required_unit_count in level.required_units_for_win:
			if arrived_units[required_unit_count.unit_info.name] < required_unit_count.count:
				return false
		return true # if you made it this far, you've met the requirements
	elif Globals.game_mode == Globals.game_modes.ARCADE:
		# need at least 2 fish to proceed to procreation minigame
		var at_least_one_mating_pair_remains = false
		for unit_name in arrived_units.keys():
			if arrived_units[unit_name] >= 2:
				at_least_one_mating_pair_remains = true
		return at_least_one_mating_pair_remains
	
	else:
		printerr("FinishZone.gd: invalid game_mode")
		return false
	

func get_unit_count_on_field():
	var confirmed_units = []
	var possible_units = get_tree().get_nodes_in_group("Units")
	for fish in possible_units:
		if is_instance_valid(fish) and !fish.is_captive:
			confirmed_units.push_back(fish)
	$DebugInfo/RemainingFish.text = str(confirmed_units.size()) + " fish remaining"
	return confirmed_units.size()
	
func _on_last_unit_sent(): # from BaseLevel
	# start checking the field to see if there are any units remaining alive
	State = States.LISTENING
