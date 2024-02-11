extends AnimatedSprite2D

var position_last_frame : Vector2 = Vector2.ZERO



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if position_last_frame.x < global_position.x:
		flip_h = false
	elif position_last_frame.x > global_position.x:
		flip_h = true
	else:
		pass # .x unchanged: leave the sprite alone
	position_last_frame = global_position
