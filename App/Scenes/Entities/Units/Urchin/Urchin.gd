extends BaseUnit


func move_forward(position):
	super.move_forward(position)
	if (path_index % 2) == 0:
		create_tween().tween_property(self, "scale:x", 0.5, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	else:
		create_tween().tween_property(self, "scale:x", 1, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
