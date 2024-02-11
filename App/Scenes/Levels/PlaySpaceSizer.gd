@tool
extends ReferenceRect

const LANE_SCENE = preload("res://App/Scenes/Spawners/Lane.tscn")

@export var play_space_size := Vector2i(8, 4):
	set(v):
		if not is_node_ready():
			return
		play_space_size = v
		size = Vector2(play_space_size) * tile_size
		for lane in $Lanes.get_children():
			lane.name = "something" # allows for consistent naming of new nodes
			lane.queue_free()
		for i in play_space_size.y:
			var lane = LANE_SCENE.instantiate()
			lane.position.x = tile_size/2
			lane.position.y = tile_size/2 + tile_size * i
			$Lanes.add_child(lane, true)
			lane.owner = owner

@export var snap : bool:
	set(v):
		play_space_size = Vector2i((size/tile_size).round())

@export_category("Scaling")
@export var tile_size = 128
@export var texture_tile_size = 1952 :
	set(v):
		if not owner.is_node_ready():
			return
		texture_tile_size = v
		var scale_factor = float(tile_size) / texture_tile_size
		$Scaler.scale = Vector2.ONE * scale_factor
		print(scale_factor)
		$Scaler.anchor_right = 1/scale_factor
		$Scaler.anchor_bottom = 1/scale_factor
		$Scaler.anchor_left = 0
		$Scaler.anchor_top = 0
