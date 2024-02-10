## Towers are mostly static. They have a turret which may or may not rotate.

class_name BaseTower extends Node2D

@export var projectile : PackedScene
enum turret_types { STATIC, ROTATING, AoE }
@export var turret_type = turret_types.STATIC

var active_target
var turret_rotation : float # radians from Vector2.RIGHT

func _ready():
	if turret_type == turret_types.ROTATING:
		$CircularActivationTrigger.monitoring = true
		$LinearActivationTrigger.enabled = false
	else:
		$CircularActivationTrigger.monitoring = false
		$LinearActivationTrigger.enabled = true

	turret_rotation = PI

func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot_all_towers"):
		shoot()
	

func shoot():
	var new_projectile = projectile.instantiate()
	# TODO: add a targeting lead based on the velocity of the target and projectile
	add_sibling(new_projectile)
	new_projectile.global_position = global_position
	if active_target != null and is_instance_valid(active_target):
		new_projectile.activate(global_position.direction_to(active_target.global_position))
	else:
		new_projectile.activate(Vector2.from_angle(turret_rotation))



func _on_circular_activation_trigger_body_entered(body):
	if turret_type == turret_types.ROTATING:
		# if you're not currently tracking a unit, start now
		if active_target == null or not is_instance_valid(active_target):
			if body.is_in_group("Units"):
				active_target = body
				shoot()

