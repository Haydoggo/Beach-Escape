extends Resource
class_name UnitMetadata

@export var game_scene : PackedScene
@export var icon_texture : Texture2D


func generate_icon():
	var icon = Sprite2D.new()
	icon.texture = icon_texture
	return icon

func generate_game_scene():
	var game_scene = game_scene.instantiate()
	return game_scene
