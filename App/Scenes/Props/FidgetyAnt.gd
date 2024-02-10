extends Node2D

var speed = 90.0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = randf_range(80, 120)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Path2D/PathFollow2D.progress_ratio < 1.0:
		$Path2D/PathFollow2D.progress += speed * delta
	else:
		$AnimationPlayer.play("idle")

func _on_hit(attackPacket):
	queue_free()
