extends Sprite2D

@onready var parent_sprite = get_parent()
var position_last_frame : Vector2
var move_magnitude : float = 0.03

var original_scale : Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = get_parent().texture
	hframes = parent_sprite.hframes
	vframes = parent_sprite.vframes
	frame = parent_sprite.frame
	if parent_sprite != null and is_instance_valid(parent_sprite):
		original_scale = parent_sprite.scale
	
func _process(_delta):
	if parent_sprite != null and is_instance_valid(parent_sprite):
		if Engine.get_process_frames() % 20 == 0:
			frame = get_parent().frame
		give_illusion_of_lift()

func give_illusion_of_lift():
		var travel_distance_sq = parent_sprite.global_position.distance_squared_to(position_last_frame)
		position = Vector2(5,5) + Vector2.ONE * travel_distance_sq * move_magnitude
		#parent_sprite.scale = original_scale * (1 + ( travel_distance_sq * scale_magnitude))

		position_last_frame = parent_sprite.global_position
		
