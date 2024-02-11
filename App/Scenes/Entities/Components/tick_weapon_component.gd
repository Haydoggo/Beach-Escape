extends Node2D

@export var ticks_between_shots : int = 0
@export var ticks_between_magazines : int = 2
@export var lag_before_projectile_spawn : float = 0.4
@export var magazine_size : int = 3
@export var projectile : PackedScene = load("res://App/Scenes/Entities/Projectiles/SandProjectile.tscn")
var shots_remaining = magazine_size
var tick_at_last_shot : int = -1
var current_tick : int = -1

enum States { IDLE, RECOIL, RELOAD, DEAD }
var State = States.IDLE
var active : bool = false

var actor # owner node. typically BaseTower

# Called when the node enters the scene tree for the first time.
func _ready():
	actor = owner

func activate():
	active = true
	
func deactivate():
	active = false

func spawn_projectile():
	var new_projectile = projectile.instantiate()
	# TODO: add a targeting lead based on the velocity of the target and projectile
	add_sibling(new_projectile)
	new_projectile.global_position = $MuzzleLocation.global_position
	new_projectile.activate(Vector2.from_angle(actor.turret_rotation))

	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("shoot_all_towers"):
		_on_tick()

func shoot():
	tick_at_last_shot = current_tick
	shots_remaining -= 1
	print("Shoot")
	if actor.has_method("shoot"):
		actor.shoot()
	await get_tree().create_timer(lag_before_projectile_spawn).timeout
	spawn_projectile()
	if shots_remaining == 0:
		State = States.RELOAD
		shots_remaining = magazine_size
	else:
		State = States.RECOIL

func _on_tick():
	current_tick += 1
	if active:
		if State == States.IDLE:
			shoot()
		elif State == States.RECOIL:
			if current_tick > tick_at_last_shot + ticks_between_shots:
				shoot()
		elif State == States.RELOAD:
			if current_tick > tick_at_last_shot + ticks_between_magazines:
				shoot()
				
