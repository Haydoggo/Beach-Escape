extends Sprite2D

@onready var parent_sprite = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = get_parent().texture
	hframes = parent_sprite.hframes
	vframes = parent_sprite.vframes
	frame = parent_sprite.frame
	
func _process(_delta):
	if parent_sprite != null and is_instance_valid(parent_sprite):
		if Engine.get_process_frames() % 20 == 0:
			frame = get_parent().frame
