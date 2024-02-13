class_name BaseLevel extends Node2D

const UNIT_COUNT = &"unit_info"
const UNIT_BUTTON = preload("res://App/Scenes/Levels/UnitButton.tscn")

@export var available_units : Array[UnitCount]
@export var required_units_for_win : Array[UnitCount]

signal last_unit_sent()
var last_unit_notification_emitted : bool = false

var unit_buttons : Container
var button_hover_text_popup : Panel
var friendly_unit_spawner : Node
@onready var fish_container = $UnitContainer

func _init():
	Globals.current_level = self

func _enter_tree() -> void:
	# annoying workaround to allow reloading these values on scene reload
	for i in available_units.size():
		if is_instance_valid(available_units[i]):
			available_units[i] = available_units[i].duplicate()
	
func _ready() -> void:
	friendly_unit_spawner = find_child("FriendlyUnitSpawner")
	add_unit_buttons()


func add_unit_buttons():
	unit_buttons = find_child("UnitButtons")
	button_hover_text_popup = find_child("ButtonHoverTextPopup")
	remove_dummy_buttons() # dummy button left in for ui sizing in inspector
	var shortcut_keycode = KEY_1
	if available_units.size() == 0:
		generate_available_units_from_global()

	for unit_count in available_units:
		if unit_count and unit_count.count > 0:
			add_unit_button(unit_count, shortcut_keycode)
			shortcut_keycode = (shortcut_keycode + 1) as Key
	select_first_available_button()
	if has_node("FinishZone") and $FinishZone.has_method("_on_last_unit_sent"):
		last_unit_sent.connect($FinishZone._on_last_unit_sent)

func select_first_available_button():
	# added to prevent selecting invalid buttons
	var button_selected = null
	for button in unit_buttons.get_children():
		if is_instance_valid(button) and button is UnitButton and button.unit_count.count > 0:
			button.pressed.emit() # Select first button
			button_selected = button
			return
	
func remove_dummy_buttons():
	if unit_buttons.get_child_count() > 0:
		for dummy_button in unit_buttons.get_children():
			if dummy_button is UnitButton:
				dummy_button.queue_free()

func generate_available_units_from_global():
	for unit_type in Globals.unit_metadata:
		if Globals.surviving_units.has(unit_type.name):
			var new_unit_count = UnitCount.new()
			new_unit_count.unit_info = unit_type
			new_unit_count.count = Globals.surviving_units[unit_type.name]
			available_units.push_back(new_unit_count)
		

func add_unit_button(unit_count : UnitCount, shortcut_keycode : int):
	if unit_count == null:
		return

	var button = UNIT_BUTTON.instantiate()
	unit_buttons.add_child(button)
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
	friendly_unit_spawner.selected_unit_button = button.unit_count

	
func button_hovered(unit_info : UnitInfo):
	
	button_hover_text_popup.popup( unit_info.description )
	
func button_mouse_exited():
	button_hover_text_popup.close()

func _on_tower_hovered(description):
	button_hover_text_popup.popup(description)
	
func _on_tower_mouse_exited():
	button_hover_text_popup.close()

func _on_unit_spawned(): # signal comes from FriendlyUnitSpawner
	if get_num_units_remaining() == 0:
		if not last_unit_notification_emitted:
			last_unit_sent.emit()
			print("Last unit sent")
			last_unit_notification_emitted = true
	if friendly_unit_spawner.selected_unit_button.count == 0:
		select_first_available_button()

func get_num_units_remaining():
	var total = 0
	#for unit_count : UnitCount in available_units:
	for button in unit_buttons.get_children():
		total += button.unit_count.count
	return total


func _on_tick_timer_timeout() -> void:
	var synchronized_groups = [ 
			"Units",
			"EnemyTowers",
			"EnemyTraps",
			"Lanes",
			]
	for group_name in synchronized_groups:
		get_tree().call_group(group_name, "_on_tick")
	#get_tree().call_group("Units", "_on_tick")
	#get_tree().call_group("EnemyTowers", "_on_tick")
	#get_tree().call_group("Lanes", "_on_tick")
