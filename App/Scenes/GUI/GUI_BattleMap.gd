extends CanvasLayer

# move some of the gui methods here?

func _ready():
	show() # we likely want it hidden in the inspector most of the time

func show_unit_info_card(unitInfo):
	$UnitInfoCard.popup(unitInfo)

func hide_unit_info_card():
	$UnitInfoCard.close()

func show_level_win():
	$LevelWin/AnimationPlayer.play("LevelPassed")


func _on_next_level_pressed() -> void:
	Globals.load_next_level()
	print("next please")
