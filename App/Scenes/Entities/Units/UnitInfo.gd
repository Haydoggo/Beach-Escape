class_name UnitInfo extends Resource

@export var name : String
@export_multiline var description : String
@export var path : PackedVector2Array
@export var icon : Texture2D
@export var health : int
@export var moisture : int = 5
@export var melee_attack : AttackPacket
@export_file("*.tscn") var packed_scene_path
var packed_scene:
	get:
		if packed_scene == null:
			packed_scene = load(packed_scene_path)
		return packed_scene
