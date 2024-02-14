extends Area2D

var unit_info : UnitInfo

var velocity : Vector2
var desired_direction : Vector2
var speed : float = 65.0
var turnaround_chance = 0.075 # per second

enum States { IDLE, HOVER, DRAGGING, PROCREATING, HIDING, DYING, DEAD }
var State = States.IDLE :
	set(value): # might be useful
		State = value
		_on_state_changed(value)
	get:
		return State



# Called when the node enters the scene tree for the first time.
func _ready():
	
	speed = randf_range(50, 100)
	set_desired_direction()
	wiggle()
	pass # Replace with function body.

func set_desired_direction():
	var center_screen = get_viewport_rect().size/2
	var direction = global_position.direction_to(center_screen)
	var deviation = 1.2
	direction = direction.rotated(randf_range(-deviation, deviation))
	velocity = direction * speed

func wiggle():
	var tween = create_tween()
	var magnitude = randf_range(-0.4, 0.4) # radians
	var duration = randf_range(0.6, 0.65)
	tween.tween_property($Sprite2D, "rotation", magnitude, duration )
	tween.tween_callback(self.wiggle)

func _on_state_changed(state):
	if state == States.HOVER:
		expand()
	else:
		resume_normal_size()
	if state == States.PROCREATING:
		tween_offscreen()
		
func expand():
	scale = Vector2.ONE * 1.1
	set_modulate(Color.DARK_RED)
	
func resume_normal_size():
	scale = Vector2.ONE
	set_modulate(Color.WHITE)
	
func tween_offscreen():
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2.RIGHT * 1900, 0.67)

func can_procreate():
	if State in [States.IDLE, States.HOVER, States.DRAGGING]:
		return true
	else:
		return false
		

func activate(unitInfo):
	unit_info = unitInfo
	$Sprite2D.texture = unitInfo.icon
	$Sprite2D.scale = Vector2.ONE * ( 128.0 / unitInfo.icon.get_height() )
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed_multiplier = 1.0
	if not $IFramesTimer.is_stopped():
		speed_multiplier = 4.0
	
	if State == States.DRAGGING:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("drag_procreator"):
			State = States.IDLE
	elif State == States.IDLE:
		global_position += velocity * speed_multiplier * delta
		if is_outside_viewport():
			queue_free()
		if randf() < turnaround_chance * delta:
			set_desired_direction()
			
		
func is_outside_viewport():
	return !get_viewport_rect().has_point(global_position)

			
func _unhandled_input(_event):
	if State == States.HOVER:
		if Input.is_action_just_pressed("drag_procreator"):
			State = States.DRAGGING
			get_viewport().set_input_as_handled()
	

func _on_area_entered(area):
	if State == States.DRAGGING:
		if area.get("unit_info") and area.unit_info.name == unit_info.name:
			procreate(area)
			
func procreate(area):
	State = States.PROCREATING
	area.State = area.States.PROCREATING
	
	if not Globals.surviving_units.has(unit_info.name):
		Globals.surviving_units[unit_info.name] = 1 # 1 bonus because 3 can never beget more than 3 if the breeding pairs disappear
	Globals.surviving_units[unit_info.name] += 3 # two parents and one baby
	Globals.surviving_units[unit_info.name] = min(Globals.max_units_per_type, Globals.surviving_units[unit_info.name])
	


func _on_mouse_entered():
	
	if State == States.IDLE and $IFramesTimer.is_stopped():
		State = States.HOVER
		


func _on_mouse_exited():
	if State == States.HOVER:
		State = States.IDLE
		

func start_iframes():
	$IFramesTimer.start()
	
	
func _on_i_frames_timer_timeout():
	pass # Replace with function body.
