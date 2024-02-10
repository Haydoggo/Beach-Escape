extends BaseUnit


func get_path_points(origin : Vector2) -> Array[Vector2]:
	return super(origin)
	# create a straight line, one tile every index
	var retval : Array[Vector2] = [origin]
	for i in 100:
		var next_pos = retval[-1] + Vector2(128, 0)
		retval.append(next_pos)
		retval.append(next_pos)
	return retval

func move():
	super.move()
	if (path_position % 2) == 0:
		create_tween().tween_property(self, "scale:x", 0.5, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	else:
		create_tween().tween_property(self, "scale:x", 1, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
