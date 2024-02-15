extends TextureRect

func _ready() -> void:
	deferred_ready.call_deferred()

func deferred_ready():
	if get_tree().get_first_node_in_group("Backdrop") == self:
		reparent(get_tree().root)
		get_parent().move_child(self, 0)
		get_tree().root.child_entered_tree.connect(on_scene_loaded)
	else:
		queue_free()

func on_scene_loaded(scene : Node):
	if scene is BaseLevel:
		queue_free()
