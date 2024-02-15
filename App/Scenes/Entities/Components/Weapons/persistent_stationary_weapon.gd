extends Node2D

@export var attack_packet : AttackPacket



func _on_tick():
	attack_units_in_my_zone()
	
func attack_units_in_my_zone():
	var present_enemies = get_local_enemies()
	if not present_enemies.is_empty():
		for enemy in present_enemies:
			if enemy.has_method("_on_hit"):
				enemy._on_hit(attack_packet)
		if owner.has_method("_on_attacked"):
			owner._on_attacked()
	
func get_local_enemies():
	var candidates = $Area2D.get_overlapping_areas()
	var present_enemies = []
	for candidate in candidates:
		if candidate.is_in_group("Units"):
			present_enemies.push_back(candidate)
		elif candidate.owner and candidate.owner.is_in_group("Units"):
			present_enemies.push_back(candidate.owner)
	return present_enemies
