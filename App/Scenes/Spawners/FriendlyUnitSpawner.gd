extends Node2D

@export var lanes_container : Node
@export var units : Array[UnitInfo] # assume each unit scene also has an icon texture
var current_lane_node
var current_unit_count : UnitCount
@onready var path_preview: Line2D = $PathPreview


# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	if lanes_container == null:
		lanes_container = get_tree().get_root().find_child("Lanes")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_selected_unit"):
		queue_spawn_selected()

func _process(_delta: float) -> void:
	var closest_lane = lanes_container.get_child(0) as Node2D
	for lane_node in (lanes_container.get_children() as Array[Node2D]):
		var m_pos = get_global_mouse_position()
		if m_pos.distance_to(lane_node.global_position) < m_pos.distance_to(closest_lane.global_position):
			closest_lane = lane_node
	switch_to_lane(closest_lane)


func queue_spawn_selected():
	if current_unit_count.count > 0 and\
	current_lane_node.queue_spawn(current_unit_count.unit_info):
		current_unit_count.count -= 1


func switch_to_lane(lane_node : Node2D):
	path_preview.clear_points()
	for point in current_unit_count.unit_info.path:
		path_preview.add_point(point)
	current_lane_node = lane_node
	global_position = lane_node.global_position
