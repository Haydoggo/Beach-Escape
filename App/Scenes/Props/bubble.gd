extends Sprite2D

@export var velocity : Vector2 = Vector2.UP
@export var speed : float = 220.0
var sin_drift_magnitude = 128
var sin_velocity_modifier : float = 1000
var original_x_position : float

# Called when the node enters the scene tree for the first time.
func _ready():
	speed *= randf_range(0.8, 1.25)
	original_x_position = position.x
	sin_drift_magnitude = randf_range(0, 24)
	sin_velocity_modifier = randf_range(800, 2500)
	scale *= randf_range(0.5, 1.33)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += velocity * speed * delta
	position.x = original_x_position + sin(Time.get_ticks_msec()/sin_velocity_modifier) * sin_drift_magnitude
	if is_outside_rect():
		global_position.y = get_viewport_rect().size.y

func is_outside_rect():
	return global_position.y < -128
	#return !get_viewport_rect().has_point(global_position)
	
