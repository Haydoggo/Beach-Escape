extends Node2D

enum States { IDLE, MOVING, WAITING, DYING, DEAD }
enum TravelPatterns {PING_PONG, LOOP}

## Can manually add SeagullPerches to this property in case you want multiple seagulls with their own perchs
@export var perches : Array[SeagullPerch]
@export var travel_pattern : TravelPatterns
@export var description : String = "Seagull moves between tiles. Dangerous."
@export var speed = 150.0
@export var attack_packet : AttackPacket
@export var health_max : float = 50.0
@export var flight_dist_per_tick : int = 10000
@export var tick_delay_between_moves : int = 2

var State = States.IDLE
var direction : int = 1
var health = health_max
var ticks_spent_waiting = 0
var perch_index = 0
var target_perch : SeagullPerch = null

@onready var seagull_sprite: AnimatedSprite2D = $Seagull
@onready var health_component: Node2D = $Components/HealthComponent
@onready var attack_area: Area2D = $AttackArea
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D



func _ready():
	if perches.is_empty():
		perches.append_array(get_tree().get_nodes_in_group(SeagullPerch.PERCHES_GROUP))
	assert(perches.size() > 1, "Seagull must have more than one perch")
	global_position = perches[0].global_position
	select_next_perch()


func idle():
	State = States.IDLE
	seagull_sprite.play("idle")
	hitbox_shape.disabled = false
	ticks_spent_waiting = 0


func _on_hit(attackPacket):
	if not State in [ States.DYING, States.DEAD ]:
		health_component._on_hit(attackPacket)


func begin_dying():
	seagull_sprite.play("die")
	State = States.DYING
	await get_tree().create_timer(5).timeout
	queue_free()


func move_next():
	var perch = perches[perch_index]
	seagull_sprite.play("fly")
	hitbox_shape.disabled = true
	
	var target_position = global_position.move_toward(target_perch.global_position, flight_dist_per_tick)
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target_position, 0.3)
	tween.tween_callback(_on_move_end)


func _on_move_end():
	if global_position == target_perch.global_position:
		select_next_perch()
		idle()


func select_next_perch():
	perch_index += direction
	if travel_pattern == TravelPatterns.PING_PONG:
		if perch_index == perches.size()-1:
			direction = -1
		if perch_index == 0:
			direction = 1
	if travel_pattern == TravelPatterns.LOOP:
		perch_index %= perches.size()
	target_perch = perches[perch_index]


func attack():
	for area in attack_area.get_overlapping_areas():
		if area.owner != null and area.owner.is_in_group("Units"):
			if area.owner.has_method("_on_hit"):
				area.owner._on_hit(attack_packet)


func _on_tick():
	if State == States.IDLE and ticks_spent_waiting >= tick_delay_between_moves:
		State = States.MOVING
	
	if State == States.MOVING:
		move_next()
	if State == States.IDLE:
		ticks_spent_waiting += 1
		attack()
