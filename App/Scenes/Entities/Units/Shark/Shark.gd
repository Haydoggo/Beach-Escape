extends BaseUnit


func attack_tower(tower):
	super.attack_tower(tower)
	move_forward(tower.global_position)
