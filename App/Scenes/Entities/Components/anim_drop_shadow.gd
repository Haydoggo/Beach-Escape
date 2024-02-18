extends AnimatedSprite2D

var parent_sprite
var position_last_frame : Vector2
var move_magnitude : float = 0.05
var scale_magnitude : float = 0.05
var original_scale : Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():	
	await owner.ready
	if get_parent() is AnimatedSprite2D:
		parent_sprite = get_parent()
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
	give_illusion_of_lift()
	
func give_illusion_of_lift():
		var travel_distance_sq = parent_sprite.global_position.distance_squared_to(position_last_frame)
		position = Vector2.ONE * travel_distance_sq * move_magnitude
		#parent_sprite.scale = original_scale * (1 + ( travel_distance_sq * scale_magnitude))

		position_last_frame = parent_sprite.global_position
		
