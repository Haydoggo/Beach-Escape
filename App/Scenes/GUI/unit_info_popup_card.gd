## Display vital unit stats to users,
## like a baseball card

'''
@export var name : String
@export_multiline var description : String
@export var movement_description : String
@export var path : PackedVector2Array
@export var icon : Texture2D
@export var health : int
@export var moisture : int = 5
@export var melee_attack : AttackPacket
'''	


extends Panel

var unit_info : UnitInfo
var fields = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate(unitInfo):
	unit_info = unitInfo
	$VBoxContainer/Icon.texture = unitInfo.icon
	fields["name"] = unitInfo.name
	fields["movement"] = unitInfo.movement_description
	fields["health"] = str(unit_info.health)
	fields["moisture"] = str(unit_info.moisture)
	if unit_info.melee_attack != null:
		fields["damage"] = str(unit_info.melee_attack.damage)
	else:
		fields["damage"] = "none"

	for field in $VBoxContainer/Fields.get_children():
		field.queue_free()
	for field_name in fields.keys():
		spawn_info_field(field_name, fields[field_name] )
	
func spawn_info_field(title, description):
	var new_info_field = load("res://App/Scenes/GUI/unit_info_form_field.tscn").instantiate()
	new_info_field.activate(title, description)
	$VBoxContainer/Fields.add_child(new_info_field)

func popup(unitInfo):
	activate(unitInfo)
	
func close():
	pass
