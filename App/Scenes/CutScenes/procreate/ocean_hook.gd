extends Area2D

enum States { INITIALIZING, HUNTING, REELING, DONE }
var State = States.INITIALIZING

var velocity : Vector2
var speed : float = 65.0

var fish_hooked

# Called when the node enters the scene tree for the first time.
func _ready():
	#State = States.HUNTING
	$DecisionTimer.start()
	velocity = Vector2.RIGHT.rotated( randf()*TAU )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State in [States.HUNTING, States.INITIALIZING, States.REELING]:
		global_position += velocity * speed * delta
	
	
	if State == States.REELING:
		if is_instance_valid(fish_hooked):
			fish_hooked.global_position += velocity * speed * delta
		else:
			queue_free()

func reel_in(fish):
	State = States.REELING
	velocity = Vector2.UP
	$CollisionShape2D.set_deferred("disabled", true)
	fish_hooked = fish
	speed *= 3.5
	
func _on_area_entered(area):
	if State == States.HUNTING:
		if area.has_method("_on_hooked") and area.State == area.States.IDLE:
			area._on_hooked(self)
			reel_in(area)




func _on_decision_timer_timeout():
	if State == States.INITIALIZING:
		State = States.HUNTING
		$DecisionTimer.start()
	elif State == States.HUNTING:
		velocity = Vector2.RIGHT.rotated(randf()*TAU)
		$DecisionTimer.start()
