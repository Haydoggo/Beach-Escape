# Trap catches 1 unit then closes up forever
# Doesn't respond to normal attacks from units


extends Node2D

const MUDFISH_INFO = preload("res://App/Scenes/Entities/Units/Mudfish/MudfishInfo.tres")
@export var attack_packet : AttackPacket
@export var description : String = "Pit trap: grabs the first fish it encounters."
enum States { OPEN, CLOSED }
var State = States.OPEN

var fish_in_trap : BaseUnit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_hit_box_area_entered(area):
	if State == States.OPEN:
		if area.owner != null and area.owner.is_in_group("Units"):
			# kill the unit and close the trap forever
			fish_in_trap = area.owner
			if fish_in_trap.unit_info == MUDFISH_INFO:
				queue_free() # not great but it'll do the job
			else:
				$AnimationPlayer.play("close")
				State = States.CLOSED
				fish_in_trap.is_dying = true


func trap_fish():
	fish_in_trap.hide()
	if fish_in_trap != null and fish_in_trap.has_method("_on_hit"):
		fish_in_trap._on_hit(attack_packet)
			

func disappear():
	trap_fish()
	
	var tween = create_tween()
	$Lid.z_index = 0
	tween.tween_property(self, "self_modulate", Color(1,1,1,0), 0.33)
	await tween.finished
	queue_free()

func _on_tick():
	pass
	
