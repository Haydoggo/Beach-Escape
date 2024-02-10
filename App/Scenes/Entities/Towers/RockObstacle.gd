extends Node2D




func _on_hit(attack_packet):
	$HealthComponent._on_hit(attack_packet)
	$AnimationPlayer.play("hurt")
	
func begin_dying():
	queue_free()
	
