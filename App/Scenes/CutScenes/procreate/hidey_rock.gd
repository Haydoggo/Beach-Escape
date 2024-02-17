## For the procreate cutscene. Hides new units behind it.


extends Node2D

var hover : bool = false
enum States { IDLE, DRAGGING, FALLING }
var State = States.IDLE
var fall_speed : float = 20.0
var gravity : float = 4.5
var unit_info : UnitInfo

@export var show_fish : bool = false
@export var floating : bool = false
@export var speed : float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_info = Globals.unit_metadata.pick_random()
	if show_fish and has_node("TrappedFish"):
		$TrappedFish.texture = unit_info.icon
		$TrappedFish.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.IDLE:
		if floating:
			position.y -= speed * delta
			if position.y < 0:
				position.y = get_viewport_rect().size.y
				
		if Input.is_action_just_pressed("drag_procreator") and hover:
			State = States.DRAGGING
			spawn_new_procreators()
			
	
	elif State == States.DRAGGING:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("drag_procreator"):
			State = States.FALLING
			$Area2D.monitoring = false
			if has_node("Bubble"):
				pop_bubble()
			
	
	elif State == States.FALLING:
		fall_speed += gravity * delta
		global_position += Vector2.DOWN * fall_speed * delta
		if global_position.y > get_viewport_rect().size.y:
			queue_free()

func wiggle():
	var tween = create_tween()
	tween.tween_property(self, "rotation", -0.3, 0.1)
	tween.tween_property(self, "rotation", 0.3, 0.2)
	tween.tween_property(self, "rotation", 0.0, 0.1)

func pop_bubble():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.1)
	tween.tween_callback(queue_free)
	
func _on_area_2d_mouse_entered():
	hover = true
	if State == States.IDLE:
		wiggle()


func _on_area_2d_mouse_exited():
	hover = false
	
func spawn_new_procreators():
	if has_node("TrappedFish"):
		$TrappedFish.hide()
	

	for i in randi_range(2,5):
		var newProcreator = load("res://App/Scenes/Entities/Units/Procreator.tscn").instantiate()
		var jitter = Vector2(randf_range(-64, 64), randf_range(-64, 64))
		add_sibling(newProcreator)
		newProcreator.global_position = global_position + jitter
		newProcreator.start_iframes()
		newProcreator.activate(unit_info)
		

