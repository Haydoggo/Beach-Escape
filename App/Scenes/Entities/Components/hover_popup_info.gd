extends Node2D

var hovering : bool = false
signal hovered
signal mouse_exited

func _ready():
	await get_tree().create_timer(0.5).timeout
	# wait for current_level ancestor to load
	delayed_ready()
	
func delayed_ready():
	hovered.connect(Globals.current_level._on_tower_hovered)
	mouse_exited.connect(Globals.current_level._on_tower_mouse_exited)

func _on_area_2d_mouse_entered():
	hovering = true
	if owner and owner.get("description"):
		hovered.emit(owner.description)

func _on_area_2d_mouse_exited():
	hovering = false
	if owner and owner.get("description"):
		mouse_exited.emit()
