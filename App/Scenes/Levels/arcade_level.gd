## Procedurally generated level for endless mode with increasing difficulty
## most of the code is already in BaseLevel, so there's not much to do here.

extends BaseLevel


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if Globals.game_mode == Globals.game_modes.ARCADE:
		var width = min(6 + Globals.arcade_difficulty_level, 13)
		var height = min(2 + Globals.arcade_difficulty_level, 6)
		$PlaySpace.play_space_size = Vector2i(width, height)
		$PlaySpace.spawn_random_towers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	

