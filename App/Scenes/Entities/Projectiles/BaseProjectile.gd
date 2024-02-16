extends Area2D

@export var speed = 120.0
@export var damage = 5
var velocity : Vector2
@export var rotate_to_face_velocity : bool = false



enum States { INITIALIZING, MOVING, EXPLODING, DEAD } 
var State = States.INITIALIZING

@export var duration_in_ticks : int = 5
var ticks_elapsed : int = 0



func _ready():
	top_level = true
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("spawn"):
		$AnimationPlayer.play("spawn")

func activate(direction : Vector2 = Vector2.LEFT):
	velocity = direction * speed
	State = States.MOVING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MOVING:
		global_position += velocity * delta
		if rotate_to_face_velocity:
			$Sprite2D.rotation = velocity.angle()

func explode():
	State = States.EXPLODING
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("explode")
		await $AnimationPlayer.animation_finished
	else:
		var tween = create_tween()
		tween.tween_property(self, "scale", scale * 2.0, 0.3)
		await tween.finished
	State = States.DEAD
	queue_free()

func create_attack_packet():
	var attack_packet = AttackPacket.new()
	attack_packet.damage = damage
	attack_packet.impact_vector = velocity
	attack_packet.damage_type = attack_packet.damage_types.IMPACT
	return attack_packet
	
func _on_body_entered(_body):
	pass
	#if State == States.MOVING:
		#if body.is_in_group("Units"):
			#if body.has_method("_on_hit"):
				#body._on_hit(create_attack_packet())
			#explode()


func _on_area_entered(area):
	if State == States.MOVING:
		if area.owner != null and area.owner.is_in_group("Units"):
			if area.owner.has_method("_on_hit"):
				area.owner._on_hit(create_attack_packet())
			explode()

func _on_tick() :
	ticks_elapsed += 1
	
	if ticks_elapsed > duration_in_ticks:
		queue_free()
	


func _on_animation_player_animation_finished(_anim_name):
	pass


	
