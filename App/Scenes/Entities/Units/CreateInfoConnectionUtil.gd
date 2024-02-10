@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var dir = get_scene().scene_file_path.get_base_dir()
	print(dir)
