extends Node2D

@export var description : String = "Campfire. Hot! Causes persistent moisture loss."
@export var animation_player : Node

enum States { IDLE, ATTACKING, DISABLED }
var State = States.IDLE

func _on_tick():
	if State in [ States.IDLE ]:
		for weapon in $Components/Weapons.get_children():
			weapon._on_tick()
	
func _on_attacked():
	if animation_player != null and animation_player.has_animation("attack"):
		animation_player.play("attack")
