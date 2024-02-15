extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():	
	await owner.ready
	if get_parent() is AnimatedSprite2D:
		sprite_frames = get_parent().sprite_frames
		global_scale = get_parent().global_scale
		show_behind_parent = true
		position = Vector2(5, 5)
	else:
		queue_free()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animation = get_parent().animation
	frame = get_parent().frame
	
	
