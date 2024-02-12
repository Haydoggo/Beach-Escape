extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in randi_range(3, 12):
		var newBubble = preload("res://App/Scenes/Props/bubble.tscn").instantiate()
		var jitter = Vector2.RIGHT.rotated(randf()*TAU) * randf_range(0, 250)
		newBubble.position = jitter
		add_child(newBubble)
	

