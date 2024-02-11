@tool
extends ReferenceRect

const TILE_SIZE = 128
const TEXTURE_TILE_SIZE = 1952

@export var play_space_size := Vector2i(8, 4):
	set(v):
		play_space_size = v
		size = Vector2(play_space_size) * TEXTURE_TILE_SIZE

@export var snap : bool:
	set(v):
		play_space_size = Vector2i((size/TEXTURE_TILE_SIZE).round())

func _ready() -> void:
	resized.connect(func():print(size))
