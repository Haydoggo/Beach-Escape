@tool
extends ReferenceRect

@export var deployment_area_width : int = 3:
	set(value):
		deployment_area_width = value
		expand_deployment_area()

@export var play_space_size := Vector2i(8, 4):
	set(v):
		if not is_node_ready():
			return
		play_space_size = v
		size = Vector2(play_space_size) * tile_size
		expand_deployment_area()

@export var snap : bool:
	set(v):
		play_space_size = Vector2i((size/tile_size).round())

@export_category("Scaling")
@export var tile_size = 128
@export var texture_tile_size = 1952 :
	set(v):
		if not(is_node_ready() and owner.is_node_ready()):
			return
		texture_tile_size = v
		var scale_factor = float(tile_size) / texture_tile_size
		$Scaler.scale = Vector2.ONE * scale_factor
		print(scale_factor)
		$Scaler.anchor_right = 1/scale_factor
		$Scaler.anchor_bottom = 1/scale_factor
		$Scaler.anchor_left = 0
		$Scaler.anchor_top = 0

func expand_deployment_area():
	var collision_shape = $DeploymentZone/CollisionShape2D
	collision_shape.shape.size = Vector2(deployment_area_width * tile_size, play_space_size.y * tile_size)
	collision_shape.position = collision_shape.shape.size / 2.0
	$DeploymentZone/ColorRect.size = collision_shape.shape.size
	$DeploymentZone/DeploymentZoneTitle.size.x = collision_shape.shape.size.x
	$Borders/BottomBorder.position.y = (play_space_size.y + 0.25) * tile_size

func _ready():
	if not Engine.is_editor_hint(): # in-game only
		Globals.tile_size = tile_size
		snap = true
		expand_deployment_area() 	# make sure changes are applied to scenes that haven't
								# been opened in editor since update to code
