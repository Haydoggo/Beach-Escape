@tool
class_name SeagullPerch extends Node2D

const PERCHES_GROUP = &"SeagullPerches"
const SEAGULL_SCENE = preload("res://App/Scenes/Entities/Towers/SeagullTrap.tscn")
@onready var label: Label = $PanelContainer/Label
var description = "Seagulls are scary. Perched gulls cause moisture loss."

func _ready() -> void:
	deferred_ready.call_deferred()

func deferred_ready():
	if Engine.is_editor_hint():
		get_tree().call_group(PERCHES_GROUP, "update_number")
	else:
		$PanelContainer.hide()
		if self == get_tree().get_first_node_in_group(PERCHES_GROUP):
			var seagull = SEAGULL_SCENE.instantiate()
			add_sibling(seagull)


func _exit_tree() -> void:
	if Engine.is_editor_hint() and get_parent() is TileMap:
		remove_from_group(PERCHES_GROUP)
		get_tree().call_group(PERCHES_GROUP, "update_number")

func update_number():
	label.text = str(get_tree().get_nodes_in_group(PERCHES_GROUP).find(self) + 1)
