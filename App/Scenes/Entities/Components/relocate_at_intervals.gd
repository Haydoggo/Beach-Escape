extends Node2D

var elapsed_ticks = 0
@export var ticks_between_relocations : int = 5
@export var chance_of_relocating : float = 0.33

var target_point : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func relocate():
	var directions = [
		Vector2(1,0),
		Vector2(1,1),
		Vector2(0,1),
		Vector2(-1,1),
		Vector2(-1,0),
		Vector2(-1,-1),
		Vector2(0, -1),
		Vector2(1, -1),
	]
	var destination = directions.pick_random() * Globals.tile_size

	$TowerDetector.position = destination
	$TowerDetector.force_shapecast_update()
	if $TowerDetector.is_colliding():
		var collisions = $TowerDetector.collision_result
		if not collisions_contains_tower(collisions):
			$TowerDetector.position = Vector2.ZERO
			# collisions, but no towers
			if Globals.current_level.is_inside_playspace(global_position + destination):
				owner.position += destination
	else: # no collisions to report
		if Globals.current_level.is_inside_playspace(global_position + destination):
			owner.position += destination

func collisions_contains_tower(collisions):
	var tower_detected : bool = false
	for collision in collisions:
		var groups_of_concern = [
				"EnemyTowerHitbox", 
				"BlockerHitbox", 
				"TrapHitbox",
				]
		for group_name in groups_of_concern:
			if collision.collider.is_in_group(group_name):
				tower_detected = true
	return tower_detected
	

func _on_tick():
	if Globals.game_mode == Globals.game_modes.ARCADE:
		elapsed_ticks += 1
		if elapsed_ticks % ticks_between_relocations == 0:
			if randf()<chance_of_relocating:
				relocate()
		
