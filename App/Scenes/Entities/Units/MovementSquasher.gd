class_name Squasher extends Node

var target : Node2D


func _ready() -> void:
	target = get_parent()

func do_squash():
	var tween = target.create_tween()
	var base_scale = target.scale
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "scale", base_scale * 0.9, 0.1)
	tween.tween_property(target, "scale", base_scale * 1.1, 0.05)
	tween.tween_property(target, "scale", base_scale, 0.1)
	
