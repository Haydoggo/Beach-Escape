extends BaseUnit

func get_path_points(origin : Vector2) -> Array[Vector2]:
	# create a straight line, one tile every index
	var retval : Array[Vector2] = [origin]
	for i in 100:
		retval.append(retval[-1] + Vector2(128, 0))
	return retval
