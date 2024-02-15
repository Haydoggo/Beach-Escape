extends Panel

var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position

func popup(newText : String):
	if newText == null or newText.is_empty():
		return
	
	%UnitDescription.text = newText
	var tween = create_tween()
	var height = get_rect().size.y + 174
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", original_position + Vector2.UP * height, 0.2)

func close():
	#$UnitDescription.text = ""
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", original_position, 0.1)
	
