## Towers are mostly static. They have a turret which may or may not rotate.

class_name BaseTower extends Node2D

@export var projectile : PackedScene
enum turret_types { STATIC, ROTATING, AoE }
@export var turret_type = turret_types.STATIC





