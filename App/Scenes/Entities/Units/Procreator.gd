extends Area2D

var unit_info : UnitInfo

enum States { IDLE, HOVER, DRAGGING, PROCREATING, HIDING, DYING, DEAD }
var State = States.IDLE :
	set(value): # might be useful
		State = value
		_on_state_changed(value)
	get:
		return State



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
func _process(_delta):
	if State == States.DRAGGING:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("drag_procreator"):
			State = States.IDLE
			
func _unhandled_input(_event):
	if State == States.HOVER:
		if Input.is_action_just_pressed("drag_procreator"):
			State = States.DRAGGING
			get_viewport().set_input_as_handled()
	

func _on_area_entered(area):
	if State == States.DRAGGING:
		if area.get("unit_info") and area.unit_info.name == unit_info.name:
			State = States.PROCREATING
			area.State = area.States.PROCREATING
			print("Procreating")
			Globals.surviving_units[unit_info.name] += 3 # two parents and one baby
			
	


func _on_mouse_entered():
	if State == States.IDLE:
		State = States.HOVER
		


func _on_mouse_exited():
	if State == States.HOVER:
		State = States.IDLE
		
