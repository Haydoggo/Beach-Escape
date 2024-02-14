extends Container

var hover : bool = false
var persist : bool = false

enum States { CLOSED, MOVING, OPEN }
var State = States.CLOSED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func popup():
	if State == States.CLOSED:
		State = States.MOVING
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", Vector2(position.x, 0), 0.33)
		await tween.finished
		State = States.OPEN
		if not persist:
			$AutoCloseTimer.start()
	
	
func close():
	if State == States.OPEN:
		State = States.MOVING
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", Vector2(position.x, -240), 0.33)
		await tween.finished
		State = States.CLOSED


func _on_mouse_entered():
	popup()
	hover = true


func _on_mouse_exited():
	if not persist:
		close()
	hover = false

func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			close()
			
func set_text(text):
	$TexturePanel/Label.text = text


func _on_auto_close_timer_timeout():
	if not persist:
		if State == States.OPEN and not hover:
			close()

