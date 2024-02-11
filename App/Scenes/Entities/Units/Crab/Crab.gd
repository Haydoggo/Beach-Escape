extends BaseUnit

func attack_tower(tower):
	super.attack_tower(tower)
	tower = tower as Node2D
	if (tower.global_position.y - global_position.y) > 32:
		$BottomSwipeAttackFX.swipe()
	if (tower.global_position.y - global_position.y) < -32:
		$TopSwipeAttackFX.swipe()
