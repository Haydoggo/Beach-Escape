extends Control



func _on_button_pressed():
	SceneLoader.load_scene("res://Extras/Scenes/Menus/MainMenu/MainMenu.tscn")
	TitleMusic.play_music()
	

