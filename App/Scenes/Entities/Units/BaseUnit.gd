class_name BaseUnit extends Node2D

@export var unit_info : UnitInfo
@onready var attack_region: Area2D = $AttackRegion
@onready var health_component: Node2D = $HealthComponent
@onready var tower_check: ShapeCast2D = $TowerCheck
@onready var swipe_attack_fx: Path2D = $SwipeAttackFX
@onready var blood_fx: CPUParticles2D = $BloodFX

var squashers : Array[Squasher]
var path_index := 0 # tracks the index of the path 
var moisture : int
var is_bleeding = false
var is_slow = false
var slow_counter = 0
var is_captive = false
var is_dying = false


func _ready() -> void:
	squashers.append_array(find_children("", "Squasher"))
	
	health_component.health_max = unit_info.health
	health_component.health = unit_info.health
	health_component.update_health_bar()
	
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("spawn"):
		$AnimationPlayer.play("spawn")


# override this method for path generation
func get_path_points(origin : Vector2) -> Array[Vector2]:
	var points : Array[Vector2] = []
	for point in unit_info.path:
		points.append(point + origin)
	return points


func _on_tick():
	if is_captive or is_dying:
		return
	if is_bleeding:
		do_drying()
	if is_slow:
		if (slow_counter % 2) == 0:
			pass # wobble or something
		else:
			do_movement()
		slow_counter += 1
	else:
		do_movement()


func do_movement():
	var next_position = global_position + unit_info.path[path_index].rotated(rotation)
	
	var stopped = false
	for col in get_objects_in_path(next_position):
		if col.is_in_group("BlockerHitbox"):
			on_blocked(next_position)
			stopped = true
		elif col.is_in_group("EnemyTowerHitbox"):
			attack_tower(col.owner)
			stopped = true
	
	if not stopped:
		move_forward(next_position)
		path_index += 1
		path_index %= unit_info.path.size()
	
	


func get_objects_in_path(next_position) -> Array[Node]:
	var retval : Array[Node] = []
	tower_check.global_position = next_position
	tower_check.force_shapecast_update()
	for i in tower_check.get_collision_count():
		retval.append(tower_check.get_collider(i))
	return retval


func move_forward(pos : Vector2):
	if pos == global_position:
		return
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", pos, 0.3)
	for squasher in squashers:
		tween.parallel().tween_callback(squasher.do_squash)


func on_blocked(target_position : Vector2):
	disable_collision_areas() # we know we're going to die on the rock so we don't want other attacks to hit
	var spawn_blocked_fx = func():
		var blocked_fx = preload("res://App/Scenes/Props/BlockedFX.tscn").instantiate()
		add_sibling(blocked_fx)
		blocked_fx.global_position = global_position
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.15).set_ease(Tween.EASE_IN)
	tween.tween_callback(spawn_blocked_fx)
	tween.tween_property(self, "global_position", global_position, 0.15).set_ease(Tween.EASE_OUT)
	
	#tween.tween_callback(do_drying)
	
	await tween.finished
	health_component.health = 0 # don't do _on_hit to avoid red flash
	health_component.update_health_bar()
	begin_dying()
	
	# tween.tween_property(self, "rotation", rotation - PI/2, 0.2).set_ease(Tween.EASE_IN_OUT)



func attack_tower(tower):
	if tower.has_method("_on_hit"):
		tower._on_hit(unit_info.melee_attack)
	swipe_attack_fx.look_at(tower.global_position)
	swipe_attack_fx.swipe()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", tower.global_position, 0.15).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", global_position, 0.15).set_ease(Tween.EASE_OUT)
	await tween.finished
	#tween.tween_callback(do_drying)


func do_drying():
	var dry_fx = preload("res://App/Scenes/Props/DryFX.tscn").instantiate()
	add_sibling(dry_fx)
	dry_fx.global_position = global_position
	
	
	var dry_damage = AttackPacket.new()
	dry_damage.damage = 20
	_on_hit(dry_damage)


func _on_hit(attack_packet : AttackPacket):
	if attack_packet.damage_type == AttackPacket.damage_types.BLEED:
		is_bleeding = true
	if attack_packet.damage_type == AttackPacket.damage_types.GLUE:
		is_slow = true
	health_component._on_hit(attack_packet)
	if attack_packet.damage > 0:
		create_tween().tween_property(self, "modulate", Color.WHITE, 0.3).from(Color.RED)


func begin_dying():
	is_dying = true
	disable_collision_areas()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel()
	tween.tween_property(self, "global_position", global_position + Vector2.UP * Globals.tile_size, 0.5)
	tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	queue_free()


func _on_finish_line_crossed(): # signal from FinishZone
	queue_free()

func _on_captured():
	is_captive = true
	disable_collision_areas()
	visible = false

func _on_released(num_squares_to_move_forward, damage_on_release):
	is_captive = false
	hurt_yourself(damage_on_release)
	position = position + (Vector2.RIGHT * Globals.tile_size * num_squares_to_move_forward)
	enable_collision_areas()
	visible = true
	
func hurt_yourself(damage):
	var ap = AttackPacket.new()
	ap.damage = damage
	_on_hit(ap)

func disable_collision_areas():
	for area in find_children("", "Area2D"):
		area.set_deferred("monitoring", false)
		area.set_deferred("monitorable", false)
	
func enable_collision_areas():
	for area in find_children("", "Area2D"):
		area.set_deferred("monitoring", true)
		if area != attack_region:
			area.set_deferred("monitorable", true)

