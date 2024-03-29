class_name BaseLevel extends Node2D


const UNIT_COUNT = &"unit_info"
const UNIT_BUTTON = preload("res://App/Scenes/Levels/UnitButton.tscn")

@export var available_units : Array[UnitCount]
var current_available_units : Array[UnitCount]
@export var required_units_for_win : Array[UnitCount]

signal last_unit_sent()
var last_unit_notification_emitted : bool = false

var unit_buttons : Container
var button_hover_text_popup : Panel
@onready var GUI = $UI
var friendly_unit_spawner : Node
@onready var fish_container = $UnitContainer
@onready var play_space = $PlaySpace
var user_instructions

var total_units : int
var music_level : int
var units_spawned : int = 0

func _init():
	Globals.current_level = self

func _enter_tree() -> void:
	for unit_count in available_units:
		if is_instance_valid(unit_count):
			current_available_units.append(unit_count.duplicate())
	
func _ready() -> void:
	Globals.current_level_path = scene_file_path
	Globals.current_requirements = required_units_for_win # for lose screen
	friendly_unit_spawner = find_child("FriendlyUnitSpawner")
	user_instructions = find_child("HelpSystem")
	#unit_stats_card = find_child("UnitInfoCard")
	add_unit_buttons()
	total_units = get_num_units_remaining()
	#if user_instructions != null and user_instructions.has_method("popup"):
		#user_instructions.popup()

func _process(_delta):
	var units_remaining = get_num_units_remaining()
	if units_remaining < (total_units * 0.66) and music_level == 0:
		fade_in_music("fade2")
		music_level += 1
	if units_remaining < (total_units * 0.33) and music_level == 1:
		fade_in_music("fade3")
		music_level += 1

func add_unit_buttons():
	unit_buttons = find_child("UnitButtons")
	button_hover_text_popup = find_child("ButtonHoverTextPopup")
	remove_dummy_buttons() # dummy button left in for ui sizing in inspector
	var shortcut_keycode = KEY_1
	if current_available_units.size() == 0:
		generate_available_units_from_global()

	for unit_count in current_available_units:
		if unit_count and unit_count.count > 0:
			add_unit_button(unit_count, shortcut_keycode)
			shortcut_keycode = (shortcut_keycode + 1) as Key
	select_first_available_button()
	if has_node("FinishZone") and $FinishZone.has_method("_on_last_unit_sent"):
		last_unit_sent.connect($FinishZone._on_last_unit_sent)

func select_first_available_button():
	# added to prevent selecting invalid buttons
	for button in unit_buttons.get_children():
		if is_instance_valid(button) and button is UnitButton and button.unit_count.count > 0:
			button.select()
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
			current_available_units.push_back(new_unit_count)
		

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
	#GUI.show_unit_info_card(button.unit_count.unit_info)
	
	if button and button.unit_count and button.unit_count.unit_info:
		if button.unit_count.unit_info.name == "Seahorse":
			
			%SeahorseBlocker.enable()
			%CrabBlocker.disable()
		elif button.unit_count.unit_info.name == "Crab":
			%CrabBlocker.enable()
			%SeahorseBlocker.disable()
		else:
			%CrabBlocker.disable()
			%SeahorseBlocker.disable()
		
			
func button_hovered(unit_info : UnitInfo):
	
	button_hover_text_popup.popup( unit_info.description )
	GUI.show_unit_info_card(unit_info)

func button_mouse_exited():
	button_hover_text_popup.close()
	GUI.hide_unit_info_card()

func _on_tower_hovered(description):
	button_hover_text_popup.popup(description)
	
func _on_tower_mouse_exited():
	button_hover_text_popup.close()




func _on_unit_spawned(): # signal comes from FriendlyUnitSpawner
	units_spawned += 1
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
	if units_spawned == 3:
		user_instructions.set_text("Continue placing units in the deployment zone.")
	if units_spawned >= 0: # testing a design where player has to place multiple spawns in the deployment zone before they start moving.
		var synchronized_groups = [ 
				"Units",
				"EnemyTowers",
				"EnemyTraps",
				"Lanes",
				"TimedComponents",
				]
		for group_name in synchronized_groups:
			get_tree().call_group(group_name, "_on_tick")

	if play_space.has_method("_on_tick"):
		play_space._on_tick()


func fade_in_music(fade : String) -> void:
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation(fade):
		$AnimationPlayer.play(fade)

func is_inside_playspace(point : Vector2) -> bool:
	return play_space.is_inside_rect(point)
	
