extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var i : int = 0
	remove_dummy_buttons()
	for level_path in Globals.level_paths:
		if not "win_screen" in level_path:
			i += 1
			var level_button : Button = Button.new()
			level_button.pressed.connect(self._on_level_selected.bind(level_path))
			level_button.custom_minimum_size = Vector2(256, 64)
			level_button.text = "Level " + str(i)
			$VBoxContainer.add_child(level_button)

func remove_dummy_buttons():
	for button in $VBoxContainer.get_children():
		if button is Button and "Dummy" in button.name:
			button.queue_free()

func _on_level_selected(level_path):
	SceneLoader.load_scene(level_path)


func _on_back_to_main_pressed():
	SceneLoader.load_scene("res://Extras/Scenes/Menus/MainMenu/MainMenu.tscn")
