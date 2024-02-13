extends BaseUnit

const INFLATION_DURATION = 2
var inflated_countdown = 0
var is_inflated = false

func _on_hit(attack_packet : AttackPacket):
	inflated_countdown = INFLATION_DURATION
	if is_inflated:
		attack_packet = attack_packet.duplicate() # dont want to nerf the source
		attack_packet.damage *= 0.2
	else:
		$AnimationPlayer.play("Inflate")
		is_inflated = true
	super._on_hit(attack_packet)

func _on_tick():
	if inflated_countdown > 0:
		inflated_countdown -= 1
		if inflated_countdown == 0:
			$AnimationPlayer.play("Deflate")
			await $AnimationPlayer.animation_finished
			is_inflated = false
	super._on_tick()

func do_movement():
	if inflated_countdown == 0:
		super.do_movement()
