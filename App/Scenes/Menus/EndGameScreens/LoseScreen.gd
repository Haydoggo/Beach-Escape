extends Control

const COUNTER_SCENE = preload("res://App/Scenes/Spawners/finish_counter_icon.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.game_mode == Globals.game_modes.PUZZLE:
		$RequiredUnitsDisplay.show()
		%DescriptionLabel.text = "You didn't free all the\nrequired fishes"
		%Retry.show()
		for unit_count in Globals.current_requirements:
			var counter = COUNTER_SCENE.instantiate()
			%Units.add_child(counter)
			counter.unit_count = Globals.arrived_units[unit_count.unit_info.name]
			counter.required_unit_count = unit_count.count
			counter.activate(unit_count.unit_info)
			await get_tree().create_timer(0.3).timeout
	elif Globals.game_mode == Globals.game_modes.ARCADE:
		$RequiredUnitsDisplay.hide()
		%DescriptionLabel.text = "You ran out of fish!"
		%Retry.hide()

func _on_retry_pressed() -> void:
	SceneLoader.load_scene(Globals.current_level_path)


func _on_menu_pressed() -> void:
	SceneLoader.load_scene("res://Extras/Scenes/Menus/MainMenu/MainMenu.tscn")
