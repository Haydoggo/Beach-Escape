extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_beat_timer_timeout():
	for fish in $Dancers.get_children():
		if fish.has_method("_on_tick"):
			fish._on_tick()
			
