extends Sprite2D

var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active:
		#var zone = get_parent()
		var mouse_pos = get_global_mouse_position() - get_parent().global_position
		#var constraints : Rect2 = zone.get_node("CollisionShape2D").shape.get_rect()
		#if constraints.has_point(mouse_pos):
			#global_position = mouse_pos.snapped(Vector2(128,128))
		var snap = Vector2(128, 128)
		position = (mouse_pos - snap/2).snapped(snap) + snap/2
		
		
func activate():
	active = true
func deactivate():
	active = false
