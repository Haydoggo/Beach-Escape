extends Node2D

@export var lanes_container : Node
var current_lane_id : int
var current_lane_node



@export var units : Array[UnitInfo] # assume each unit scene also has an icon texture

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	if lanes_container == null:
		lanes_container = get_tree().get_root().find_child("Lanes")
	current_lane_id = 0
	global_position = lanes_container.get_child(current_lane_id).global_position

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_down"):
		switch_lane(1)
	elif Input.is_action_just_pressed("move_up"):
		switch_lane(-1)
	for unit_idx in range(units.size()):
		if Input.is_action_just_pressed("spawn_unit_"+str(unit_idx)):
			current_lane_node.queue_spawn(units[unit_idx])



func switch_lane(direction):
	var lanes = lanes_container.get_children()
	current_lane_id = (current_lane_id + direction) % lanes.size()
	global_position = lanes[current_lane_id].global_position
	current_lane_node = lanes_container.get_child(current_lane_id)
	

