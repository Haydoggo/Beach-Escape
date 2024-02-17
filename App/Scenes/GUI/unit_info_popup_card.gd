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


extends Control

var unit_info : UnitInfo
var fields = {}
enum States { IDLE, TWEENING }
var State = States.IDLE

func _ready():
	hide()

func activate(unitInfo):
	show()
	unit_info = unitInfo
	$Panel/VBoxContainer/Icon.texture = unitInfo.icon
	fields["name"] = unitInfo.name
	fields["movement"] = unitInfo.movement_description
	fields["health"] = "%d" % ceil(unit_info.health/20.0)
	if unit_info.melee_attack != null:
		fields["damage"] = str(unit_info.melee_attack.damage)
	else:
		fields["damage"] = "none"

	for field in $Panel/VBoxContainer/Fields.get_children():
		field.queue_free()
	for field_name in fields.keys():
		spawn_info_field(field_name, fields[field_name] )
	
func spawn_info_field(title, description):
	var new_info_field = load("res://App/Scenes/GUI/unit_info_form_field.tscn").instantiate()
	new_info_field.activate(title, description)
	$Panel/VBoxContainer/Fields.add_child(new_info_field)

func popup(unitInfo):
	activate(unitInfo)
	#tween_open()
	
func tween_open():
	# Can't get these to look nice, so I'm not using them yet
	if State == States.IDLE:
		State = States.TWEENING
		var tween = create_tween()
		tween.tween_property(self, "rotation", 0.25, 0.4)
		await tween.finished
		if State == States.TWEENING:
			State = States.IDLE
	
func close():
	#tween_closed()
	hide()


func tween_closed():
	# Can't get these to look nice, so I'm not using them yet
	if State == States.IDLE:
		State = States.TWEENING
		var tween = create_tween()
		tween.tween_property(self, "rotation", PI/2.0, 0.4)
		await tween.finished
		if State == States.TWEENING:
			State = States.IDLE
			hide()
