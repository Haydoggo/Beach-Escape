## For the procreate cutscene. Hides new units behind it.


extends Node2D

var hover : bool = false
enum States { IDLE, DRAGGING, FALLING }
var State = States.IDLE
var fall_speed : float = 20.0
var gravity : float = 4.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.IDLE:
		if Input.is_action_just_pressed("drag_procreator") and hover:
			State = States.DRAGGING
			spawn_new_procreators()
	
	elif State == States.DRAGGING:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("drag_procreator"):
			State = States.FALLING
			$Area2D.monitoring = false
			
	
	elif State == States.FALLING:
		fall_speed += gravity * delta
		$Sprite2D.global_position += Vector2.DOWN * fall_speed * delta
		if global_position.y > get_viewport_rect().size.y:
			queue_free()

func _on_area_2d_mouse_entered():
	hover = true


func _on_area_2d_mouse_exited():
	hover = false
	
func spawn_new_procreators():
	var unit_info = Globals.unit_metadata.pick_random()

	for i in range(3):
		var newProcreator = load("res://App/Scenes/Entities/Units/Procreator.tscn").instantiate()
		newProcreator.activate(unit_info)
		add_child(newProcreator)
		
		var jitter = Vector2(randf_range(-64, 64), randf_range(-64, 64))
		newProcreator.global_position = global_position + jitter
		
