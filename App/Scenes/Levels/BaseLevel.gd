extends Node2D

const UNIT_COUNT = &"unit_info"

@export var available_units : Array[UnitCount]

func _ready() -> void:
	for unit_count in available_units:
		var button = Button.new()
		button.focus_mode = Control.FOCUS_NONE
		button.text = str(unit_count.count)
		button.expand_icon = true
		button.icon = unit_count.unit_info.icon
		button.set_meta(UNIT_COUNT, unit_count)
		button.pressed.connect(button_pressed.bind(button))
		unit_count.count_updated.connect(func():
			button.text = str(unit_count.count))
		%UnitButtons.add_child(button)
	%UnitButtons.get_child(0).pressed.emit() # Select first button


func button_pressed(button : Button):
	var unit_count = button.get_meta(UNIT_COUNT) as UnitCount
	$FriendlyUnitSpawner.current_unit_count = unit_count

func _process(delta: float) -> void:
	var closest_lane = $Lanes.get_child(0) as Node2D
	for lane_node in ($Lanes.get_children() as Array[Node2D]):
		var m_pos = get_global_mouse_position()
		if m_pos.distance_to(lane_node.global_position) < m_pos.distance_to(closest_lane.global_position):
			closest_lane = lane_node
	$FriendlyUnitSpawner.switch_to_lane(closest_lane)
		
