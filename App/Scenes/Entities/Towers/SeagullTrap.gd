@tool

extends Node2D

enum States { IDLE, MOVING, DYING, DEAD }
var State = States.IDLE
@export var speed = 150.0
var direction : int = 1
@export var attack_packet : AttackPacket
@export var health_max : float = 50.0
var health = health_max

enum travel_types { WALK, FLY }
@export var travel_type : travel_types = travel_types.WALK

var ticks : int = 0
var tick_at_last_stop : int = 0
var tick_at_start_move : int = 0
@export var move_steps_without_attacking : int = 1
@export var num_ticks_to_stay_in_each_location : int = 2

var seagull_position_last_frame : Vector2


func _ready():
	if Engine.is_editor_hint():
		colorize_seagulls()
	else:
		hide_waypoints()
		await get_tree().create_timer(0.5).timeout
		delayed_ready()



func delayed_ready():
	# wait for other birds to arrive in the scene
	build_path()
	idle()
	update_health_bar()


func colorize_seagulls():
	if not is_top_bird():
		set_modulate(Color.DARK_OLIVE_GREEN)
	else:
		set_modulate(Color.WHITE)


func is_top_bird():
	var top_bird = true
	var seagulls = get_tree().get_nodes_in_group("Seagulls").duplicate()
	seagulls.erase(self)
	for seagull in seagulls:
		if is_instance_valid(seagull) and seagull.get_index() < get_index():
			top_bird = false
	return top_bird


func build_path():
	if is_top_bird():
		var curve = Curve2D.new()
		
		var waypoints = get_tree().get_nodes_in_group("Seagulls")
		for waypoint in waypoints:
			curve.add_point(to_local(waypoint.global_position))
		$Path2D.curve = curve

func hide_waypoints():
	if not is_top_bird():
		visible = false
	else:
		visible = true

func idle():
	State = States.IDLE
	#$IdleTimer.start()
	$Path2D/PathFollow2D/Seagull.play("idle")
	


func can_attack():
	var ready_and_able = true
	if State in [States.DYING, States.DEAD]:
		ready_and_able = false
	#elif not $ReloadTimer.is_stopped:
		#ready_and_able = false
	return ready_and_able
	
	
func _on_area_2d_area_entered(area):
	if can_attack():
		if area.owner != null and area.owner.is_in_group("Units"):
			if area.owner.has_method("_on_hit"):
				area.owner._on_hit(attack_packet)
				idle()
				$ReloadTimer.start()


func _on_hit(attackPacket):
	if $IFramesTimer.is_stopped() and not State in [ States.DYING, States.DEAD ]:
		health -= attackPacket.damage
		update_health_bar()
		if health <= 0:
			begin_dying()
		else:
			$IFramesTimer.start()

func update_health_bar():
	$Path2D/PathFollow2D/Seagull/HealthBar.max_value = health_max
	$Path2D/PathFollow2D/Seagull/HealthBar.value = health

func begin_dying():
	$Path2D/PathFollow2D/Seagull.play("die")
	State = States.DYING
	await get_tree().create_timer(5).timeout
	queue_free()

func move_next():
	$Path2D/PathFollow2D/Seagull.play("fly")
	
	var block_size = 128
	
	var tween = create_tween()
	var path = $Path2D
	var progress = $Path2D/PathFollow2D.progress
	tween.tween_property($Path2D/PathFollow2D, "progress", progress+(direction * block_size), 0.3).set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(_on_move_end)


func _on_move_end():
	$Path2D/PathFollow2D/Seagull.play("idle")
	if direction == 1 and $Path2D/PathFollow2D.get_progress_ratio() > 0.9:
		direction = -1
	elif direction == -1 and $Path2D/PathFollow2D.get_progress_ratio() < 0.1:
		direction = 1

func _on_tick():
	if is_top_bird():
		move_next()
