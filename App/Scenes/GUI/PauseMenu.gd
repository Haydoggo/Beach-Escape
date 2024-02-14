extends Panel

func _ready():
	hide()


func _unhandled_input(_event):
	if not visible and Input.is_action_just_pressed("ui_cancel"):
		self.show()
		get_tree().set_pause(true)
	elif visible and Input.is_action_just_pressed("ui_cancel"):
		self.hide()
		get_tree().set_pause(false)


func _on_return_to_game_pressed():
	self.hide()
	get_tree().set_pause(false)


func _on_restart_level_pressed():
	print("Level Restarting")
	self.hide()
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	#Globals.restart_level()
