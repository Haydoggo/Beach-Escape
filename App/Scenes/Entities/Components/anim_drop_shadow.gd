extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	if get_parent() is AnimatedSprite2D:
		sprite_frames = get_parent().sprite_frames
		scale = get_parent().scale
	else:
		queue_free()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animation = get_parent().animation
	frame = get_parent().frame
	
	
