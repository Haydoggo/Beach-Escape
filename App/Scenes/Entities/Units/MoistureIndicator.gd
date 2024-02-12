extends Node2D

var moisture : int:
	set = set_moisture
var max_moisture : int:
	set = set_max_moisture

@onready var droplet_template: TextureRect = $DropletTemplate
@onready var droplet_container: HBoxContainer = $DropletContainer

func _ready() -> void:
	droplet_template.hide()

func set_max_moisture(v : int):
	max_moisture = v
	for droplet in droplet_container.get_children():
		droplet.queue_free()
	for i in max_moisture:
		var droplet = droplet_template.duplicate()
		droplet.show()
		droplet_container.add_child(droplet)
	set_moisture(moisture)

func set_moisture(v : int):
	moisture = clampi(v, 0, max_moisture)
	for i in max_moisture:
		var droplet = droplet_container.get_child(i)
		if i < moisture:
			droplet.modulate = Color.WHITE
		else:
			droplet.modulate = Color.DIM_GRAY

