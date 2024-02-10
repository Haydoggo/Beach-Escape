extends Area2D

@export var speed = 120.0
var velocity : Vector2

enum States { INITIALIZING, MOVING, EXPLODING, DEAD } 
var State = States.INITIALIZING

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true

func activate(direction : Vector2 = Vector2.LEFT):
	velocity = direction * speed
	State = States.MOVING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MOVING:
		global_position += velocity * delta



func _on_body_entered(body):
	var attack_packet = AttackPacket.new()
	attack_packet.damage = 5
	attack_packet.impact_vector = velocity
	attack_packet.damage_type = attack_packet.damage_types.IMPACT
	if body.is_in_group("PlayerUnits"):
		if body.has_method("_on_hit"):
			body._on_hit(attack_packet)
