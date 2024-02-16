## Fishing hook "tower". May be spawned on level start or at intervals.
## In arcade mode only: should go away after a certain number of ticks.
extends "res://App/Scenes/Entities/Towers/StaticTrap_OnTick.gd"

var direction = Vector2(2,-1)
var speed : float = 250.0

var duration_in_ticks : int = 10
var ticks_elapsed : int = 0

func _ready():
	$Sprite2D/FishSprite.hide()

func _process(delta):
	if State == States.DISABLED: # reeling in fish
		global_position += direction * speed * delta
		if not is_in_viewport():
			queue_free()
			
func is_in_viewport():
	return get_viewport_rect().has_point(global_position)


func reel_in():
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(get_viewport_rect().size.x + 128, -128), 0.3125)
	


func _on_attacked():
	State = States.DISABLED
	var tween = create_tween()
	tween.tween_property($Sprite2D/FishSprite, "rotation", PI/2.0, 0.3)
	

	
func _on_tick():
	super()
	ticks_elapsed += 1
	if Globals.game_mode == Globals.game_modes.ARCADE:
		if ticks_elapsed > duration_in_ticks:
			reel_in()
	
