## send one of these with every _on_hit() request.
## it's a place to hold parameters like knockback, impact_vector, damage_type, extra effects, etc.

class_name AttackPacket extends Node

enum damage_types { IMPACT, WATER, GLUE }

var impact_vector : Vector2 = Vector2.LEFT
var damage_type : damage_types = damage_types.IMPACT
var damage : float = 5.0


