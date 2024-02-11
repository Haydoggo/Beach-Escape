class_name BaseUnit extends Node2D

@export var unit_info : UnitInfo
@onready var attack_region: Area2D = $AttackRegion
@onready var health_component: Node2D = $HealthComponent


var path : Array[Vector2] = []
var path_position := 0 # tracks the index of the path 


func _ready() -> void:
	path = get_path_points(global_position)
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
	path_position += 1
	# end of the path
	if path_position >= path.size():
		queue_free()
		return
	var next_position = path[path_position]
	var tween = create_tween()
	tween.tween_property(self, "global_position", next_position, 0.3).set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(_on_move_end)


# can override for custom attack patterns
func _on_move_end():
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
