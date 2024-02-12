extends Node2D

@export var attack_packet : AttackPacket



func _on_tick():
	attack_units_in_my_zone()
	
func attack_units_in_my_zone():
	var present_enemies = get_local_enemies()
	for enemy in present_enemies:
		if enemy.has_method("_on_hit"):
			enemy._on_hit(attack_packet)
			print(owner.name + " attacked " + enemy.name)
	
	
func get_local_enemies():
	var candidates = $Area2D.get_overlapping_areas()
	var present_enemies = []
	for candidate in candidates:
		if candidate.is_in_group("Units"):
			present_enemies.push_back(candidate)
		elif candidate.owner and candidate.owner.is_in_group("Units"):
			present_enemies.push_back(candidate.owner)
	return present_enemies
