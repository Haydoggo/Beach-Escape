## Indestructible Obstacle

extends Node2D
@export var description = "Obstruction"



func _on_hit(_attack_packet):
	pass
	#$HealthComponent._on_hit(attack_packet)
	#$AnimationPlayer.play("hurt")


func begin_dying():
	pass
	#queue_free()
	
