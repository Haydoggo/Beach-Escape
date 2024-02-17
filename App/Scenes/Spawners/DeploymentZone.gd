extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func expand(play_space_size, deployment_area_width, tile_size):
	var collision_shape = $CollisionShape2D
	collision_shape.shape.size = Vector2(deployment_area_width * tile_size, play_space_size.y * tile_size)
	collision_shape.position = collision_shape.shape.size / 2.0
	$ColorRect.size = collision_shape.shape.size - Vector2(32,32)
	$DeploymentZonePanel.size = collision_shape.shape.size - Vector2(44,64)
	$DeploymentZonePanel.position += Vector2(12,12)


func _on_mouse_entered():
	$SelectedTileCursor.activate()


func _on_mouse_exited():
	$SelectedTileCursor.deactivate()
