class_name BaseUnit extends Node2D

@export var unit_info : UnitInfo
@onready var attack_region: Area2D = $AttackRegion
@onready var health_component: Node2D = $HealthComponent
@onready var tower_check: ShapeCast2D = $TowerCheck
@onready var swipe_attack_fx: Path2D = $SwipeAttackFX


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
	var blocked = false
	tower_check.global_position = next_position
	tower_check.force_shapecast_update()
	for i in tower_check.get_collision_count():
		var col = tower_check.get_collider(i) as Node
		if col.is_in_group("BlockerHitbox"):
			blocked = true
		elif col.is_in_group("EnemyTowerHitbox"):
			attack_tower(col.owner)
			attacking = true
	
	# movement
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	if blocked:
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "rotation", 0.1, 0.1)
		tween.tween_property(self, "rotation", -0.1, 0.2)
		tween.tween_property(self, "rotation", 0, 0.1)
	elif attacking:
		tween.tween_property(self, "global_position", next_position, 0.15).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "global_position", global_position, 0.15).set_ease(Tween.EASE_OUT)
	else:
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", next_position, 0.3)
	
	path_index += 1
	path_index %= unit_info.path.size()


func attack_tower(tower):
	if tower.has_method("_on_hit"):
		tower._on_hit(unit_info.melee_attack)
	swipe_attack_fx.look_at(tower.global_position)
	swipe_attack_fx.swipe()


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
