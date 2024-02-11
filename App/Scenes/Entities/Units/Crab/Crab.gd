extends BaseUnit


func get_path_points(origin : Vector2) -> Array[Vector2]:
	return super(origin)
	var retval : Array[Vector2] = [origin]
	for i in 100:
		if (i % 2) == 0:
			retval.append(retval[-1] + Vector2(128, 0))
		if (i % 4) == 1:
			retval.append(retval[-1] + Vector2(0, 128))
		if (i % 4) == 3:
			retval.append(retval[-1] + Vector2(0, -128))
	return retval

func attack_tower(tower):
	super.attack_tower(tower)
	tower = tower as Node2D
	if (tower.global_position.y - global_position.y) > 32:
		$BottomSwipeAttackFX.swipe()
	if (tower.global_position.y - global_position.y) < -32:
		$TopSwipeAttackFX.swipe()
