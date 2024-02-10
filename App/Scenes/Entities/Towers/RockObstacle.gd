extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hit(attack_packet):
	$HealthComponent._on_hit(attack_packet)
	$AnimationPlayer.play("hurt")
	
func begin_dying():
	queue_free()
	
