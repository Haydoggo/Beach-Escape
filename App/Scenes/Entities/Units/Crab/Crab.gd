extends BaseUnit

func _ready():
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("spawn"):
		$AnimationPlayer.play("spawn")
