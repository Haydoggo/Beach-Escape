## Towers are mostly static. They have a turret which may or may not rotate.

## Requirements: AnimationPlayer node with shoot and hurt animations


class_name BaseTower extends Node2D

@export var projectile : PackedScene
enum turret_types { STATIC, ROTATING, MELEE_AOE }
@export var turret_type = turret_types.STATIC

var active_target
var turret_rotation : float # radians from Vector2.RIGHT
var rotation_speed : float = 3.14159

@export var shots_per_magazine : int = 3
var shots_remaining : int = 3

@export var health_max : float = 20.0
var health : float = health_max

enum States { INITIALIZING, ACTIVE, DYING, DEAD }
var State = States.INITIALIZING

@export var animation_player : Node


func _ready():
	
	if turret_type == turret_types.ROTATING:
		$Debug/RotationViz.visible = true
	elif turret_type == turret_types.STATIC:
		$Debug/RotationViz.visible = false
	elif turret_type == turret_types.MELEE_AOE:
		$Debug/RotationViz.visible = false
		


	turret_rotation = PI # Vector2.LEFT
	State = States.ACTIVE

func _unhandled_input(_event):
	if Input.is_action_just_pressed("shoot_all_towers"):
		shoot()
	if Input.is_action_just_pressed("hurt_towers"):
		_on_hit(AttackPacket.new())

func _process(delta):
	if turret_type == turret_types.ROTATING:
		if active_target != null and is_instance_valid(active_target):
			turret_rotation = lerp(turret_rotation, global_position.angle_to_point(active_target.global_position), rotation_speed * delta)
			$Debug/RotationViz.rotation = turret_rotation


func shoot():
	if State != States.ACTIVE:
		return
	
	if shots_remaining > 0:
		shots_remaining -= 1
		if animation_player != null and animation_player.has_animation("shoot"):
			animation_player.play("shoot")
	else:
		$ReloadTimer.start()

func spawn_projectile():
	var new_projectile = projectile.instantiate()
	# TODO: add a targeting lead based on the velocity of the target and projectile
	add_sibling(new_projectile)
	new_projectile.global_position = $MuzzleLocation.global_position
	new_projectile.activate(Vector2.from_angle(turret_rotation))
	$RecoilTimer.start()
	

func _on_activation_triggers_body_entered(body):
	if State == States.ACTIVE:
		if active_target == null or not is_instance_valid(active_target):
			if body.is_in_group("Units"):
				active_target = body
				call_deferred("shoot")


func _on_recoil_timer_timeout():
	if State == States.ACTIVE:
		call_deferred("shoot")


func _on_reload_timer_timeout():
	if State == States.ACTIVE:
		shots_remaining = shots_per_magazine
		if active_target != null:
			call_deferred("shoot")


func _on_activation_triggers_area_entered(area):
	if State == States.ACTIVE:
		if active_target == null or not is_instance_valid(active_target):
			if area.owner != null and area.owner.is_in_group("Units"):
				active_target = area
				call_deferred("shoot")


func _on_activation_triggers_area_exited(area):
	if not is_instance_valid(active_target):
		# they're gone already?
		choose_new_target()
	elif area.owner != null and area.owner == active_target:
		choose_new_target()
	

func choose_new_target():
	var candidates = $ActivationTriggers.get_overlapping_areas()
	if candidates.size() > 0:
		active_target = get_closest(candidates)
	else:
		active_target = null
	
func get_closest(nodeList):
	var candidates = nodeList.duplicate()
	candidates.sort_custom(sort_ascending)
	return candidates[0]
	
func sort_ascending(a, b):
	var a_dist = global_position.distance_squared_to(a.global_position)
	var b_dist = global_position.distance_squared_to(b.global_position)
	return a_dist < b_dist

func _on_hit(attackPacket : AttackPacket):
	if animation_player != null and animation_player.has_animation("hurt"):
		$AnimationPlayer.play("hurt")
	else:
		var tween = create_tween()
		var current_rotation = $Sprite2D.rotation
		tween.tween_property($Sprite2D, "rotation", current_rotation + 0.3, 0.33)
		tween.tween_property($Sprite2D, "rotation", current_rotation, 0.1)
	$HealthComponent._on_hit(attackPacket)


func begin_dying():
	State = States.DYING
	var tween = create_tween()
	var current_scale = $Sprite2D.scale
	tween.tween_property($Sprite2D, "scale", Vector2(current_scale.x, current_scale.y * 1.2), 0.2)
	tween.tween_property($Sprite2D, "scale", Vector2(current_scale.x, 0.01), 0.5)
	await tween.finished
	queue_free()
	
