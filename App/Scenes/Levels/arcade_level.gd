## Procedurally generated level for endless mode with increasing difficulty
## most of the code is already in BaseLevel, so there's not much to do here.

extends BaseLevel


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if Globals.game_mode == Globals.game_modes.ARCADE:
		spawn_random_towers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	

