extends "res://App/Scenes/Entities/Towers/StaticTrap_OnTick.gd"

var direction = Vector2(2,-1)
var speed : float = 250.0

func _ready():
	$Sprite2D/FishSprite.hide()

func _process(delta):
	if State == States.DISABLED: # reeling in fish
		global_position += direction * speed * delta
		if not is_in_viewport():
			queue_free()
			
func is_in_viewport():
	return get_viewport_rect().has_point(global_position)

func _on_attacked():
	State = States.DISABLED
	var tween = create_tween()
	tween.tween_property($Sprite2D/FishSprite, "rotation", PI/2.0, 0.3)
	
	
