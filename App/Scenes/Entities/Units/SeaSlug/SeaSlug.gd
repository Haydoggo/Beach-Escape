extends BaseUnit

@onready var upper_attack_check: ShapeCast2D = $TowerCheck/UpperAttackCheck
@onready var lower_attack_check: ShapeCast2D = $TowerCheck/LowerAttackCheck

func get_objects_in_attack_zones(next_position : Vector2) -> Array[Node]:
	tower_check.global_position = next_position
	var retval : Array[Node] = []
	for tc in [upper_attack_check, lower_attack_check]:
		tc.force_shapecast_update()
		for i in tc.get_collision_count():
			retval.append(tc.get_collider(i))
	return retval

func attack_tower(tower : BaseTower):
	super.attack_tower(tower)
	move_forward(tower.global_position)

func _on_tick():
	var next_position = global_position + unit_info.path[path_index]
	
	var stopped = false
	
	#first we check if there's anyone to attack
	for col in get_objects_in_attack_zones(next_position):
		if col.is_in_group("EnemyTowerHitbox"):
			attack_tower(col.owner)
			stopped = true
			break
	
	# then we check if there's space to move forward
	if not stopped:
		for col in get_objects_in_path(next_position):
			if col.is_in_group("BlockerHitbox") or col.is_in_group("EnemyTowerHitbox"):
				on_blocked()
				stopped = true
	
	# then we try to move forward
	if not stopped:
		move_forward(next_position)
	
	path_index += 1
	path_index %= unit_info.path.size()