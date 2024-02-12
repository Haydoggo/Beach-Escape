extends Marker2D

var queued_units = []
var max_queue_size : int = 5

signal unit_spawned

func _ready():
	# wait for current_level to register itself with Globals
	await get_tree().create_timer(0.5).timeout
	delayed_ready()

func delayed_ready():
	var current_level = Globals.current_level
	if current_level != null and current_level.has_method("_on_unit_spawned"):
		unit_spawned.connect(current_level._on_unit_spawned)
	else:
		printerr("Lane get current_level from Globals?")

func spawn(unit_info : UnitInfo):
	var new_unit = unit_info.packed_scene.instantiate() as BaseUnit
	assert( $QueuedUnits.get_child_count() > 0)
	add_child(new_unit)
	new_unit.global_position = global_position
	$QueuedUnits.get_child(0).queue_free() # remove the icon
	unit_spawned.emit()
	var tween = new_unit.create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(new_unit, "scale", Vector2.ONE, 0.3).from(Vector2.ZERO)

func _on_tick():
	pass
	#if queued_units.size() > 0:
		#spawn(queued_units.pop_front())


func queue_spawn(unit_info : UnitInfo):
	if queued_units.size() < max_queue_size:
		var icon = TextureRect.new()
		icon.texture = unit_info.icon
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.custom_minimum_size = Vector2(128,128)
		$QueuedUnits.add_child(icon)
		queued_units.push_back(unit_info)
		return true
	else:
		return false
