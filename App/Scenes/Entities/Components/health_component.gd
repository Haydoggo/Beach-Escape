extends Node2D

@export var health_max : float = 4.0
var health
var actor

func _ready():
	actor = owner
	if owner.get("health_max"):
		health_max = owner.health_max
	health = health_max
	update_health_bar()
	


func update_health_bar():
	$HealthBar.max_value = health_max
	$HealthBar.value = health
	$HealthBar/PanelContainer/MarginContainer/Label.text = "%d/%d" % [health, health_max]

func _on_hit(attack_packet):
	health -= attack_packet.damage
	update_health_bar()
	if health <= 0:
		if actor.has_method("begin_dying"):
			actor.begin_dying()



