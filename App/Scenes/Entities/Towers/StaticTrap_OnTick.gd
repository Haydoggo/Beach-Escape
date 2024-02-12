extends Node2D

@export var description : String = "Fishing Hook: injury from this causes persistent bleed damage."
func _on_tick():
	for weapon in $Components/Weapons.get_children():
		weapon._on_tick()
	
