extends Sprite2D

var original_scale : Vector2
var original_position : Vector2
var duration : float = 0.625

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = global_position
	original_scale = scale
	

func wobble():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(original_scale.x, original_scale.y * randf_range(0.8, 1.25)), randf_range(duration * 0.8, duration))

func _on_tick():
	wobble()
