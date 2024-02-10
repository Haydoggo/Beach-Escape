extends Node2D

const UNIT_COUNT = &"unit_info"

@export var available_units : Array[UnitCount]

func _ready() -> void:
	var shortcut_number = 1
	var button_group = ButtonGroup.new()
	for unit_count in available_units:
		var button = add_unit_button(unit_count, shortcut_number)
		button.button_group = button_group
		shortcut_number += 1
	%UnitButtons.get_child(0).pressed.emit() # Select first button


func add_unit_button(unit_count : UnitCount, shortcut_number : int) -> Button:
	var button = Button.new()
	button.focus_mode = Control.FOCUS_NONE
	button.text = str(unit_count.count)
	button.expand_icon = true
	button.icon = unit_count.unit_info.icon
	button.set_meta(UNIT_COUNT, unit_count)
	button.pressed.connect(button_pressed.bind(button))
	button.toggle_mode = true
	unit_count.count_updated.connect(func():
		button.text = str(unit_count.count))
	%UnitButtons.add_child(button)
	
	var shortcut = Shortcut.new()
	var shortcut_event = InputEventKey.new()
	shortcut_event.keycode = KEY_1 + shortcut_number-1
	shortcut_event.pressed = true
	shortcut.events.append(shortcut_event)
	button.shortcut = shortcut
	
	return button


func button_pressed(button : Button):
	var unit_count = button.get_meta(UNIT_COUNT) as UnitCount
	$FriendlyUnitSpawner.current_unit_count = unit_count
