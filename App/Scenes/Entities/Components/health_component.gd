extends Node2D

const HEALTH_PER_HEART = 20

@export var health_max : float = 60:
	set = set_max_health

var health : float:
	set = set_health

var actor : Node
@onready var heart_container: HBoxContainer = $HeartContainer
@onready var heart_template: Control = $HeartTemplate


func _ready():
	heart_template.hide()
	actor = owner
	if actor.get("health_max"):
		health_max = actor.health_max
	set_max_health(health_max)
	health = health_max
	update_health_bar()
	


func update_health_bar():
	var total_num_hearts = health_max/HEALTH_PER_HEART
	var current_num_hearts = health/HEALTH_PER_HEART
	for i in total_num_hearts:
		var heart = heart_container.get_child(i)
		if i < current_num_hearts:
			heart.modulate = Color.WHITE
		else:
			heart.modulate = Color.DIM_GRAY
	
	$HealthBar.max_value = health_max
	$HealthBar.value = health
	$HealthBar/PanelContainer/MarginContainer/Label.text = "%d/%d" % [health/HEALTH_PER_HEART, health_max/HEALTH_PER_HEART]
	

func _on_hit(attack_packet):
	health -= attack_packet.damage
	update_health_bar()
	if health <= 0:
		if actor.has_method("begin_dying"):
			actor.begin_dying()

func set_max_health(value : float):
	health_max = value
	for heart in heart_container.get_children():
		heart.queue_free()
	for i in health_max/HEALTH_PER_HEART:
		var heart = heart_template.duplicate()
		heart.show()
		heart_container.add_child(heart)
	set_health(health)


func set_health(value : float):
	health = clampf(value, 0, health_max)
	if roundi(health) % HEALTH_PER_HEART != 0:
		printerr("%s is on %d health, should be multiple of %d" %[owner.name, health, HEALTH_PER_HEART])
		print_stack()

