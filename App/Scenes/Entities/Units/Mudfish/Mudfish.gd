extends BaseUnit


func move_forward(pos : Vector2):
	super.move_forward(pos)
	if path_index == 1:
		tunnel_down()
	elif path_index == 2:
		global_position = pos
		tunnel_up()

func attack_tower(tower):
	if path_index == 2:
		tunnel_up()
	else:
		super.attack_tower(tower)

func on_blocked():
	if path_index == 2:
		tunnel_up()
	else:
		super.on_blocked()

func tunnel_down():
	$Hitbox.monitorable = false
	create_tween().tween_property(self, "modulate:a", 0.5, 0.5)

func tunnel_up():
	moisture = unit_info.moisture
	moisture_indicator.moisture = moisture
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	await tween.finished
	$Hitbox.monitorable = true
	
