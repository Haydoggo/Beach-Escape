extends BaseUnit

const INFLATION_DURATION = 1
var inflated_countdown = 0
var is_inflated = false

func _on_hit(attack_packet : AttackPacket):
	if is_inflated:
		attack_packet = attack_packet.duplicate() # dont want to nerf the source
		attack_packet.damage *= 0.2
	else:
		$AnimationPlayer.play("Inflate")
		inflated_countdown = INFLATION_DURATION
		is_inflated = true
	super._on_hit(attack_packet)

func _on_tick():
	if inflated_countdown > 0:
		inflated_countdown -= 1
		if inflated_countdown == 0:
			$AnimationPlayer.play("Deflate")
			await $AnimationPlayer.animation_finished
			is_inflated = false
	else:
		super._on_tick()
