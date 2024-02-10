extends Node2D

@export var health_max : float = 4.0
var health = health_max
var actor

func _ready():
	actor = owner
	update_health_bar()

func update_health_bar():
	$HealthBar.max_value = health_max
	$HealthBar.value = health


func _on_hit(attack_packet):
	health -= attack_packet.damage
	update_health_bar()
	if health <= 0:
		if actor.has_method("begin_dying"):
			actor.begin_dying()



