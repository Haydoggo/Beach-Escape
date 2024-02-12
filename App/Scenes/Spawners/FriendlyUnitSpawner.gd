extends Node2D

@export var lanes_container : Node
@export var deployment_zone : Area2D

@export var units : Array[UnitInfo] # assume each unit scene also has an icon texture
var current_lane_node
var selected_unit_button : UnitCount # button bar icons are called unitcount
@onready var path_preview: Line2D = $PathPreview

enum States { INITIALIZING, READY }
var State = States.INITIALIZING

signal unit_spawned

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	if lanes_container == null:
		lanes_container = get_tree().get_root().find_child("Lanes")
	
	await get_tree().create_timer(0.5).timeout
	delayed_ready()

func delayed_ready():
	
	var current_level = Globals.current_level
	if current_level != null and current_level.has_method("_on_unit_spawned"):
		unit_spawned.connect(current_level._on_unit_spawned)
	State = States.READY


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_selected_unit"):
		if is_square_free():
			spawn_unit(selected_unit_button.unit_info)
		#queue_spawn_selected()

func _process(_delta: float) -> void:
	if State == States.READY:
		var closest_lane = lanes_container.get_child(0) as Node2D
		for lane_node in (lanes_container.get_children() as Array[Node2D]):
			var m_pos = get_global_mouse_position()
			if m_pos.distance_to(lane_node.global_position) < m_pos.distance_to(closest_lane.global_position):
				closest_lane = lane_node
		update_path_preview()
		#switch_to_lane(closest_lane)
		
func is_square_free() -> bool:
	var is_free : bool = true
	for area in $Area2D.get_overlapping_areas():
		for group_name in [ "Units", "EnemyTowers", "BlockerHitBox", "EnemyTowerHitBox"]:
			if area.is_in_group(group_name) or (area.owner and area.owner.is_in_group(group_name)):
				is_free = false
	return is_free

func spawn_unit(unit_info : UnitInfo):
	if selected_unit_button.count > 0:
		var new_unit = unit_info.packed_scene.instantiate() as BaseUnit
		#assert( $QueuedUnits.get_child_count() > 0)
		Globals.current_level.get_node("UnitContainer").add_child(new_unit)
		new_unit.global_position = global_position
		#$QueuedUnits.get_child(0).queue_free() # remove the icon
		var tween = new_unit.create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(new_unit, "scale", Vector2.ONE, 0.3).from(Vector2.ZERO)
		selected_unit_button.count -= 1
		unit_spawned.emit()
		
func queue_spawn_selected():
	pass
	#if selected_unit_button.count > 0 and\
	#current_lane_node.queue_spawn(selected_unit_button.unit_info):
		#selected_unit_button.count -= 1


func switch_to_lane(lane_node : Node2D):
	current_lane_node = lane_node
	global_position = lane_node.global_position
	
func update_path_preview():
	if selected_unit_button != null:
		var path = selected_unit_button.unit_info.path
		path_preview.clear_points()
		var point = Vector2.ZERO
		path_preview.add_point(point)
		for i in 100:
			point += path[i % path.size()]
			path_preview.add_point(point)



func _on_area_2d_area_entered(_area):
	pass
