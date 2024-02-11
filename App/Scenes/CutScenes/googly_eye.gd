extends Sprite2D

var original_position : Vector2
@export var distance : float = 4.0
# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = original_position.move_toward(get_global_mouse_position(), distance)
