extends Control

var hover : bool = false
var persist : bool = false

enum States { CLOSED, MOVING, OPEN }
var State = States.CLOSED

# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInstructions.hide()



func popup():
	if State == States.CLOSED:
		$UserInstructions.show()
		State = States.MOVING
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property($UserInstructions, "position", Vector2(356, 538), 0.33)
		await tween.finished
		if State == States.MOVING:
			State = States.OPEN
			if not persist:
				$AutoCloseTimer.start()
	
	
func close():
	if State == States.OPEN:
		State = States.MOVING
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property($UserInstructions, "position", Vector2(-922, 984), 0.33)
		
		await tween.finished
		if State == States.MOVING:
			$UserInstructions.hide()
			State = States.CLOSED



func set_text(text):
	%HelpText.text = text


func _on_auto_close_timer_timeout():
	if not persist:
		if State == States.OPEN and not hover:
			close()



func _on_help_button_pressed():
	if State == States.CLOSED:
		popup()
	elif State == States.OPEN:
		close()


func _on_user_instructions_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			close()

func _on_user_instructions_mouse_entered():
	
	#popup()
	hover = true

func _on_user_instructions_mouse_exited():
	if not persist:
		close()
	hover = false
