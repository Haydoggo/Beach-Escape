extends BaseUnit

const SWIPE_FX_SCENE = preload("res://App/Scenes/Props/SwipeAttackFX.tscn")

func move_forward(_position):
	super.move_forward(_position)
	if (path_index % 2) == 0:
		create_tween().tween_property(self, "scale:x", 0.5, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	else:
		create_tween().tween_property(self, "scale:x", 1, 0.3).set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	
	for area in attack_region.get_overlapping_areas():
		if not area.is_in_group("EnemyTowerHitbox"):
			continue
		var tower = area.owner as Node2D
		tower._on_hit(unit_info.melee_attack)
		var swipe = SWIPE_FX_SCENE.instantiate()
		add_child(swipe)
		swipe.look_at(tower.global_position)
		
