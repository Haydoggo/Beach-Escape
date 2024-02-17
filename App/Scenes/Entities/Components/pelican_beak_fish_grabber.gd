# move forward, snatch a fish.
# change parent animation frame,
# hold fish for 2 ticks
# respawn the fish.


extends Node2D

var active : bool = false
#var captive_fish : Array[BaseUnit] # removed per requirements. issue #26 may only capture a single fish
var captive_fish : BaseUnit
var damage_on_release : int = 20
var damage_per_tick : int = 20
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
	if active and captive_fish == null:
		# if there's a fish near you.
		# move the sprite toward it and snatch the fish
		var fish = get_first_available_fish()
		if fish:
			catch_fish(fish)
	elif captive_fish != null and hold_ticks_remaining > 0:
		if captive_fish and captive_fish.unit_info and captive_fish.unit_info.melee_attack:
			var damage = captive_fish.unit_info.melee_attack.damage
			hurt_yourself(damage)
		hold_ticks_remaining -= 1
		#print("Pelican taking : ", damage, " damage.")
		if hold_ticks_remaining == 0:
			release_fish()

func hurt_yourself(damage):
	if owner.get("health") != null:
		# might need to grab health from the health component instead.
		if owner.health < damage:
			if captive_fish != null:
				released.emit(global_position, damage_per_tick * (hold_duration-hold_ticks_remaining))
			# die and spawn a fish, with 20 less health
	if owner.has_method("_on_hit"):
		var ap = AttackPacket.new()
		ap.damage = damage
		owner._on_hit(ap)

func get_first_available_fish():
	for fish_detector in get_children():
		var collisions = fish_detector.collision_result
		if not collisions.is_empty():
			if not has_tower(collisions):
				for collision in collisions:
					var possible_fish = collision["collider"].owner
					if collision["collider"].monitoring and possible_fish and possible_fish.is_in_group("Units"):
						var confirmed_fish = possible_fish
						if not confirmed_fish.is_captive:
							return confirmed_fish
	

func has_tower(collisionList):
	for collision in collisionList:
		var node = collision["collider"]
		if node.is_in_group("EnemyTowerHitbox") or node.is_in_group("BlockerHitBox"):
			return true
	



func catch_fish(fish):
	if fish.get_parent() and is_instance_valid(fish):
		#captive_fish.push_back(fish.unit_info)
		if fish.has_method("_on_captured"):
			captive_fish = fish
			hold_ticks_remaining = hold_duration
		
			captured.connect(fish._on_captured)
			released.connect(fish._on_released)
			captured.emit()
			captured.disconnect(fish._on_captured)
			move_toward_fish_and_back(fish)
			
			
			
func move_toward_fish_and_back(fish):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "global_position", sprite.position + fish.global_position, 0.2 )
	tween.tween_interval(0.4)
	tween.tween_property(sprite, "global_position", original_sprite_position, 0.2)
	sprite.frame = 1


func release_fish():
	captive_fish = null
	var location = global_position
	released.emit(location, damage_on_release)
	for connection in released.get_connections():
		released.disconnect(connection["callable"])
