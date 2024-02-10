class_name BaseUnit extends Node2D

@export var unit_info : UnitInfo
@onready var attack_region: Area2D = $AttackRegion

var path : Array[Vector2] = []
var path_position := 0 # tracks the index of the path 
var health : float


func _ready() -> void:
	path = get_path_points(global_position)
	health = unit_info.health


# override this method for path generation
func get_path_points(origin : Vector2) -> Array[Vector2]:
	var points : Array[Vector2] = []
	for point in unit_info.path:
		points.append(point + origin)
	return points


func move():
	path_position += 1
	# end of the path
	if path_position >= path.size():
		queue_free()
		return
	var next_position = path[path_position]
	var tween = create_tween()
	tween.tween_property(self, "global_position", next_position, 0.3).set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(move_end)


# can override for custom attack patterns
func move_end():
	attack()


func attack():
	for area in attack_region.get_overlapping_areas():
		var tower #: BaseTower <-- They're not all BaseTowers anymore
		if area.owner and area.owner.is_in_group("EnemyTowers"):
			tower = area.owner
		else:
			continue
		if tower.has_method("_on_hit"):
			tower._on_hit(unit_info.melee_attack)


func _on_hit(attack_packet : AttackPacket):
	health -= attack_packet.damage
	if health <= 0:
		queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			move()

func _on_finish_line_crossed(): # signal from FinishZone
	queue_free()
