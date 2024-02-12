extends Node2D


func _on_tick():
	for weapon in $Components/Weapons.get_children():
		weapon._on_tick()
	
