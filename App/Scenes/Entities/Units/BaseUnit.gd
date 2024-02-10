extends Node2D

@export var icon : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_icon():
	var new_icon = TextureRect.new()
	new_icon.size = Vector2(128,128)
	new_icon.texture = icon
	return new_icon
	
