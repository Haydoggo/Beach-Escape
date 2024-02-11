class_name BaseUnit extends Node2D

@export var unit_info : UnitInfo
@onready var attack_region: Area2D = $AttackRegion
@onready var health_component: Node2D = $HealthComponent
@onready var tower_check: ShapeCast2D = $TowerCheck


var path_index := 0 # tracks the index of the path 


func _ready() -> void:
	health_component.health_max = unit_info.health
	health_component.health = unit_info.health
	health_component.update_health_bar()


# override this method for path generation
func get_path_points(origin : Vector2) -> Array[Vector2]:
	var points : Array[Vector2] = []
	for point in unit_info.path:
		points.append(point + origin)
	return points


func move_next():
	var next_position = global_position + unit_info.path[path_index]
	
	var attacking = false
	tower_check.force_shapecast_update()
	for i in tower_check.get_collision_count():
		var tower = (tower_check.get_collider(i) as Node).owner
		if tower.is_in_group("EnemyTowers"):
			attack_tower(tower)
			attacking = true
	
	# movement
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	if attacking:
		tween.tween_property(self, "global_position", next_position, 0.15).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "global_position", global_position, 0.15).set_ease(Tween.EASE_OUT)
	else:
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", next_position, 0.3)
		tween.tween_callback(_on_move_end)
	
	path_index += 1
	path_index %= unit_info.path.size()


# can override for custom attack patterns
func _on_move_end():
	return
	attack()


func attack():
	for area in attack_region.get_overlapping_areas():
		var tower #: BaseTower <-- They're not all BaseTowers anymore
		if area.owner and area.owner.is_in_group("EnemyTowers"):
			tower = area.owner
		else:
			continue
		attack_tower(tower)


func attack_tower(tower):
	if tower.has_method("_on_hit"):
		tower._on_hit(unit_info.melee_attack)


func _on_hit(attack_packet : AttackPacket):
	health_component._on_hit(attack_packet)
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.3).from(Color.RED)


func begin_dying():
	queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			move_next()


func _on_finish_line_crossed(): # signal from FinishZone
	queue_free()
