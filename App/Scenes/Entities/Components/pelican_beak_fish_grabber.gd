# move forward, snatch a fish.
# change parent animation frame,
# hold fish for 2 ticks
# respawn the fish.


extends Node2D

var active : bool = false
var captive_fish : Array[BaseUnit]
@export var sprite : AnimatedSprite2D
@export var hold_duration : int = 3
var hold_ticks_remaining : int = 0
var original_sprite_position : Vector2 # global_coords

signal captured
signal released

func _ready():
	original_sprite_position = sprite.global_position
	
	
func activate():
	active = true
	
func deactivate():
	active = false

func _on_tick():
	var caught_fish = false
	if active and captive_fish.is_empty():
		# there's a fish in front of you.
		# move the sprite forward and snatch the fish
		for area in $FishGrabArea.get_overlapping_areas():
			var fish = area.owner
			if area.monitoring and fish and fish.is_in_group("Units"):
				if fish.get("is_captive") and fish.is_captive:
					return
				catch_fish(area.owner)
				caught_fish = true
	if caught_fish:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "position", sprite.position + Vector2.LEFT * Globals.tile_size, 0.2 )
		tween.tween_interval(0.4)
		tween.tween_property(sprite, "global_position", original_sprite_position, 0.2)
		sprite.frame = 1

	elif hold_ticks_remaining > 0:
		hold_ticks_remaining -= 1
		if hold_ticks_remaining == 0:
			release_fish()
	
func catch_fish(fish):
	if fish.get_parent() and is_instance_valid(fish):
		#captive_fish.push_back(fish.unit_info)
		hold_ticks_remaining = hold_duration
		if fish.has_method("_on_captured"):
			captured.connect(fish._on_captured)
			released.connect(fish._on_released)
			captured.emit()
			captured.disconnect(fish._on_captured)
		

func release_fish():
	var num_squares_to_move_forward = 1
	released.emit(num_squares_to_move_forward)
	for connection in released.get_connections():
		released.disconnect(connection["callable"])
