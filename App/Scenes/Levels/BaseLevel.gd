class_name BaseLevel extends Node2D

const UNIT_COUNT = &"unit_info"
const UNIT_BUTTON = preload("res://App/Scenes/Levels/UnitButton.tscn")

@export var available_units : Array[UnitCount]

signal last_unit_sent()
var last_unit_notification_emitted : bool = false


func _ready() -> void:
	Globals.current_level = self
	var shortcut_keycode = KEY_1
	for unit_count in available_units:
		add_unit_button(unit_count, shortcut_keycode)
		shortcut_keycode += 1
	%UnitButtons.get_child(0).pressed.emit() # Select first button
	if has_node("FinishZone") and $FinishZone.has_method("_on_last_unit_sent"):
		last_unit_sent.connect($FinishZone._on_last_unit_sent)


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
	

func _on_unit_spawned(): # signal comes from Lanes
	if get_num_units_remaining() == 0:
		if not last_unit_notification_emitted:
			last_unit_sent.emit()
			print("Last unit sent")
			last_unit_notification_emitted = true


func get_num_units_remaining():
	var total = 0
	#for unit_count : UnitCount in available_units:
	for button in %UnitButtons.get_children():
		total += button.unit_count.count
	return total
