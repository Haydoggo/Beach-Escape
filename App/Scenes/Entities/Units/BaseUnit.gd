class_name BaseUnit extends Node2D

@export var icon : Texture2D = preload("res://icon.svg")

var path : Array[Vector2] = []
var path_position := 0 # tracks the index of the path 

func _ready() -> void:
	path = get_path_points(global_position)

# override this method for path generation
func get_path_points(origin : Vector2) -> Array[Vector2]:
	return [origin]

func move():
	path_position += 1
	var next_position = path[path_position]
	create_tween().tween_property(self, "global_position", next_position, 0.3).set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_CUBIC)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_M:
			move()

func generate_icon():
	var new_icon = TextureRect.new()
	new_icon.size = Vector2(128,128)
	new_icon.texture = icon
	return new_icon
