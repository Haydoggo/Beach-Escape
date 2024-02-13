# move forward, snatch a fish.
# change parent animation frame,
# hold fish for 2 ticks
# respawn the fish.


extends Node2D

var active : bool = false
var captive_fish : Array[BaseUnit]
@export var sprite : Sprite2D
@export var hold_duration : int = 3
var hold_ticks_remaining : int = 0

func activate():
	active = true
	
func deactivate():
	active = false

func _on_tick():
	if active and captive_fish.is_empty():
		# there's a fish in front of you.
		# move the sprite forward and snatch the fish
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "position", sprite.position + Vector2.LEFT * Globals.tile_size, 0.2 )
		tween.tween_interval(0.4)
		tween.tween_property(sprite, "position", sprite.position, 0.2)
		sprite.frame = 1
		for area in $FishGrabArea.get_overlapping_areas():
			if area.owner and area.owner.is_in_group("Units"):
				catch_fish(area.owner)
	elif not captive_fish.is_empty():
		hold_ticks_remaining -= 1
		if hold_ticks_remaining <= 0:
			release_fish()
	
func catch_fish(fish):
	if fish.owner and is_instance_valid(fish):
		captive_fish.push_back(fish)
		hold_ticks_remaining = hold_duration
		fish.get_parent().remove_child(fish)

func release_fish():
	for fish in captive_fish:
		Globals.current_level.fish_container.add_child(fish)
		fish.global_position = global_position + Vector2.RIGHT * Globals.tile_size
		sprite.frame = 0
