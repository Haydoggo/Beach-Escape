extends BaseUnit

const PIT_ATTACK = preload("res://App/Scenes/Entities/Towers/PitTrapAttack.tres")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func move_forward(pos : Vector2):
	super.move_forward(pos)
	if path_index == 1:
		tunnel_down()
	elif path_index == 2:
		tunnel_up()

func attack_tower(tower):
	if path_index == 2:
		tunnel_up()
	else:
		super.attack_tower(tower)

func on_blocked(target_position):
	if path_index == 2:
		tunnel_up()
	else:
		super.on_blocked(target_position)

func _on_hit(attack_packet : AttackPacket):
	if attack_packet == PIT_ATTACK:
		path_index = 1
		
	else:
		super._on_hit(attack_packet)

func tunnel_down():
	animation_player.play("TunnelDown")
	disable_collision_areas()
	await get_tree().create_timer(0.4).timeout
	super.move_forward(global_position + Vector2(128,0).rotated(rotation))
	

func tunnel_up():
	animation_player.play("TunnelUp")
	await animation_player.animation_finished
	enable_collision_areas()

func do_drying():
	pass
