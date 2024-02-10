extends Node2D

const UNIT_COUNT = &"unit_info"
const UNIT_BUTTON = preload("res://App/Scenes/Levels/UnitButton.tscn")

@export var available_units : Array[UnitCount]

func _ready() -> void:
	var shortcut_keycode = KEY_1
	for unit_count in available_units:
		add_unit_button(unit_count, shortcut_keycode)
		shortcut_keycode += 1
	%UnitButtons.get_child(0).pressed.emit() # Select first button


func add_unit_button(unit_count : UnitCount, shortcut_keycode : int):
	var button = UNIT_BUTTON.instantiate()
	%UnitButtons.add_child(button)
	button.text = str(unit_count.count)
	button.icon = unit_count.unit_info.icon
	button.unit_count = unit_count
	button.pressed.connect(button_pressed.bind(button))
	unit_count.count_updated.connect(func():
		button.text = str(unit_count.count))
	button.shortcut_keycode = shortcut_keycode


func button_pressed(button : UnitButton):
	$FriendlyUnitSpawner.current_unit_count = button.unit_count
