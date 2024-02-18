extends Node2D

func enable():
	for collision_shape in find_children("", "CollisionShape2D"):
		collision_shape.set_deferred("disabled", false)
	show()
	
func disable():
	for collision_shape in find_children("", "CollisionShape2D"):
		collision_shape.set_deferred("disabled", true)
	hide()
