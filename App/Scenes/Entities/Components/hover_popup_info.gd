extends Node2D

var mouse_over : bool = false
var time_at_hover_start : int = 0 #msec
var hover_popup_delay : int = 300 #msec

signal hovered
signal mouse_exited

enum States { IDLE, LISTENING, HOVERING }
var State = States.IDLE :
	set(value):
		State = value
		#$StateLabel.text = States.keys()[value]


func _ready():
	await get_tree().create_timer(0.5).timeout
	# wait for current_level ancestor to load
	delayed_ready()
	
func delayed_ready():
	hovered.connect(Globals.current_level._on_tower_hovered)
	mouse_exited.connect(Globals.current_level._on_tower_mouse_exited)

func _process(_delta):
	if State == States.LISTENING:
		if mouse_over and Time.get_ticks_msec() > time_at_hover_start + hover_popup_delay:
			if owner and owner.get("description"):
				hovered.emit(owner.description)
				State = States.HOVERING


func _on_area_2d_mouse_entered():
	if State == States.IDLE:
		mouse_over = true
		time_at_hover_start = Time.get_ticks_msec()
		State = States.LISTENING
	


func _on_area_2d_mouse_exited():
	mouse_over = false
	if State == States.HOVERING:
		if owner and owner.get("description"):
			mouse_exited.emit()
		State = States.IDLE
	elif State == States.LISTENING:
		State = States.IDLE
		
	
