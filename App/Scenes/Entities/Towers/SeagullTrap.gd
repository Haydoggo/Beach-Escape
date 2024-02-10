extends Node2D

enum States { IDLE, MOVING, DYING, DEAD }
var State = States.IDLE
@export var speed = 150.0
var direction : int = 1
@export var attack_packet : AttackPacket
@export var health_max : float = 50.0
var health = health_max

# Called when the node enters the scene tree for the first time.
func _ready():
	idle()
	update_health_bar()
	
func idle():
	State = States.IDLE
	$IdleTimer.start()
	$Path2D/PathFollow2D/Seagull.play("idle")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MOVING:
		$Path2D/PathFollow2D.progress += speed * delta * direction
		if direction == 1 and $Path2D/PathFollow2D.progress_ratio > 0.98:
			$Path2D/PathFollow2D/Seagull.flip_h = true
			direction = -1
			idle()
		elif direction == -1 and $Path2D/PathFollow2D.progress_ratio < 0.02:
			direction = 1
			$Path2D/PathFollow2D/Seagull.flip_h = false
			idle()
		

func _on_idle_timer_timeout():
	if State == States.IDLE:
		$Audio/SqwawkSFX.play()
		State = States.MOVING
		$Path2D/PathFollow2D/Seagull.play("fly")

func can_attack():
	var ready_and_able = true
	if State in [States.DYING, States.DEAD]:
		ready_and_able = false
	elif not $ReloadTimer.is_stopped:
		ready_and_able = false
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
	
