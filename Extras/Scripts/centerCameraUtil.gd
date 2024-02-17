@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var camera = get_scene().get_node("Camera2D") as Camera2D
	var playspace = get_scene().get_node("PlaySpace") as Control
	var default_camera_width = float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	camera.global_position = playspace.global_position + playspace.size/2
	camera.zoom = default_camera_width/(playspace.size.x + 128 * 4) * Vector2.ONE
	camera.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	
