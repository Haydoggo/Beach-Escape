@tool
extends ReferenceRect
var available_spaces = []


var fish_hook_probability = 0.05

@export var deployment_area_width : int = 3:
	set(value):
		deployment_area_width = value
		expand_deployment_area()

@export var play_space_size := Vector2i(8, 4):
	set(v):
		if not is_node_ready():
			return
		play_space_size = v
		size = Vector2(play_space_size) * tile_size
		expand_deployment_area()

@export var snap : bool:
	set(v):
		play_space_size = Vector2i((size/tile_size).round())

@export_category("Scaling")
@export var tile_size = 128
@export var texture_tile_size = 1952 :
	set(v):
		if not(is_node_ready() and owner.is_node_ready()):
			return
		texture_tile_size = v
		var scale_factor = float(tile_size) / texture_tile_size
		$Scaler.scale = Vector2.ONE * scale_factor
		print(scale_factor)
		$Scaler.anchor_right = 1/scale_factor
		$Scaler.anchor_bottom = 1/scale_factor
		$Scaler.anchor_left = 0
		$Scaler.anchor_top = 0

func expand_deployment_area():
	$DeploymentZone.expand(play_space_size, deployment_area_width, tile_size)
	#var collision_shape = $DeploymentZone/CollisionShape2D
	#collision_shape.shape.size = Vector2(deployment_area_width * tile_size, play_space_size.y * tile_size)
	#collision_shape.position = collision_shape.shape.size / 2.0
	#$DeploymentZone/ColorRect.size = collision_shape.shape.size
	#$DeploymentZone/DeploymentZoneTitle.size.x = collision_shape.shape.size.x
	$Borders/BottomBorder.position.y = (play_space_size.y + 0.25) * tile_size
	if has_node("CrabBlocker"):
		$CrabBlocker.position.y = (play_space_size.y - 1) * tile_size + 64


func _ready():
	if not Engine.is_editor_hint(): # in-game only
		Globals.tile_size = tile_size
		snap = true
		expand_deployment_area() 	# make sure changes are applied to scenes that haven't
									# been opened in editor since update to code
		fish_hook_probability += Globals.arcade_difficulty_level / 20.0

func spawn_random_towers():
	if Globals.game_mode == Globals.game_modes.ARCADE:
		var num_towers = min(2 + Globals.arcade_difficulty_level * 2, get_squares_count())
		generate_available_spaces_list() # no duplicates
		for i in range(num_towers):
			spawn_random_tower()
	

func generate_available_spaces_list():
	for row in range(play_space_size.y):
		for col in range(play_space_size.x - deployment_area_width):
			var y_pos = row
			var x_pos = (col + deployment_area_width)
			available_spaces.push_back(global_position + Vector2(x_pos, y_pos)*Globals.tile_size)
	available_spaces.shuffle()
	
func spawn_random_tower():
	if available_spaces.is_empty():
		return
	
	var square_position = available_spaces.pop_back()
	var random_tower_path = Globals.tower_paths.values().pick_random()
	var random_tower = load(random_tower_path).instantiate()
	random_tower.position = square_position
	add_child(random_tower)

	if random_tower is SeagullPerch:
		var second_perch = random_tower.duplicate()
		if not available_spaces.is_empty():
			second_perch.position = available_spaces.pop_back()
			add_child(second_perch)
		else: # no space left for a perch
			random_tower.queue_free()

func get_squares_count():
	return (play_space_size.x - deployment_area_width) * play_space_size.y
	

func _on_tick():
	if Globals.game_mode == Globals.game_modes.ARCADE:
		if randf() < fish_hook_probability:
			spawn_fish_hook()
			#
func spawn_fish_hook():
	var new_fish_hook = load("res://App/Scenes/Entities/Towers/NewFishingHook_YeetTower.tscn").instantiate()
	$Towers.add_child(new_fish_hook)
	var x_pos = (randi()%(play_space_size.x - deployment_area_width) + deployment_area_width) * Globals.tile_size + Globals.tile_size/2
	var y_pos = (randi()%(play_space_size.y)) * Globals.tile_size + Globals.tile_size/2
	new_fish_hook.position = Vector2(x_pos, y_pos)

func is_inside_rect(point):
	
	var ps_rect = get_playable_rect()
	var has_point = ps_rect.has_point(point)
	#queue_redraw()
	return has_point
	
func get_playable_rect():
	var ps_rect = get_rect()
	ps_rect.size.x -= deployment_area_width * tile_size
	ps_rect.position.x += deployment_area_width * tile_size
	var fudge_vector = Vector2(-tile_size/2.0, -tile_size/2.0)
	ps_rect.position += fudge_vector # I'm not sure why the rectable is off by 1/2 of a tile - plex
	return ps_rect
	
func _draw():
	pass
	#draw_rect(get_playable_rect(), Color.RED, false, 5)
	
	
		
