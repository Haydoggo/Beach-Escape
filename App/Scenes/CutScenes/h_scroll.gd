extends TextureRect

@export var speed : float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.LEFT * speed * delta
	if position.x < 0 - get_rect().size.x:
		position.x = get_viewport_rect().size.x + get_rect().size.x
