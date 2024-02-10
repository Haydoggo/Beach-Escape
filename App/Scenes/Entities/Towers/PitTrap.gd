# Trap catches 1 unit then closes up forever
# Doesn't respond to normal attacks from units

extends Node2D

@export var attack_packet : AttackPacket

enum States { OPEN, CLOSED }
var State = States.OPEN

var fish_in_trap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_hit_box_area_entered(area):
	if State == States.OPEN:
		if area.owner != null and area.owner.is_in_group("Units"):
			# kill the unit and close the trap forever
			fish_in_trap = area.owner
			$AnimationPlayer.play("close")
			State = States.CLOSED


func trap_fish():
	if fish_in_trap != null and fish_in_trap.has_method("_on_hit"):
		fish_in_trap._on_hit(attack_packet)
			

func disappear():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.33)
	await tween.finished
	queue_free()
	
