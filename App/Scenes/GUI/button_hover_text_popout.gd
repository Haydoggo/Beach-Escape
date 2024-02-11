extends Panel

var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position

func popup(newText):
	$UnitDescription.text = newText
	var tween = create_tween()
	var height = get_rect().size.y
	tween.tween_property(self, "position", original_position + Vector2.UP * height, 0.2)

func close():
	$UnitDescription.text = ""
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.1)
	
