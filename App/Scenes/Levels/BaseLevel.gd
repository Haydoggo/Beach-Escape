class_name BaseLevel extends Node2D

const UNIT_COUNT = &"unit_info"
const UNIT_BUTTON = preload("res://App/Scenes/Levels/UnitButton.tscn")

@export var available_units : Array[UnitCount]

signal last_unit_sent()
var last_unit_notification_emitted : bool = false

func _ready() -> void:
	Globals.current_level = self
	add_unit_buttons()


func add_unit_buttons():
	var shortcut_keycode = KEY_1
	if available_units.size() == 0:
		generate_available_units_from_global()

	for unit_count in available_units:
		add_unit_button(unit_count, shortcut_keycode)
		shortcut_keycode += 1
	%UnitButtons.get_child(0).pressed.emit() # Select first button
	if has_node("FinishZone") and $FinishZone.has_method("_on_last_unit_sent"):
		last_unit_sent.connect($FinishZone._on_last_unit_sent)

func generate_available_units_from_global():
	for unit_type in Globals.unit_metadata:
		var new_unit_count = UnitCount.new()
		new_unit_count.unit_info = unit_type
		new_unit_count.count = Globals.surviving_units[unit_type.name]
		available_units.push_back(new_unit_count)
		

func add_unit_button(unit_count : UnitCount, shortcut_keycode : int):
	var button = UNIT_BUTTON.instantiate()
	%UnitButtons.add_child(button)
	button.text = str(unit_count.count)
	button.icon = unit_count.unit_info.icon
	button.unit_count = unit_count
	button.pressed.connect(button_pressed.bind(button))
	button.get_node("Button").mouse_entered.connect(button_hovered.bind(unit_count.unit_info))
	button.get_node("Button").mouse_exited.connect(button_mouse_exited)
	unit_count.count_updated.connect(func():
		button.text = str(unit_count.count))
	button.shortcut_keycode = shortcut_keycode


func button_pressed(button : UnitButton):
	$FriendlyUnitSpawner.current_unit_count = button.unit_count
	
func button_hovered(unit_info : UnitInfo):
	%ButtonHoverTextPopout.popup( unit_info.description )

func button_mouse_exited():
	%ButtonHoverTextPopout.close()

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


func _on_tick_timer_timeout() -> void:
	get_tree().call_group("Units", "_on_tick")
	get_tree().call_group("EnemyTowers", "_on_tick")
	get_tree().call_group("Lanes", "_on_tick")
