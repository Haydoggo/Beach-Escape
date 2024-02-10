## send one of these with every _on_hit() request.
## it's a place to hold parameters like knockback, impact_vector, damage_type, extra effects, etc.

class_name AttackPacket extends Resource

enum damage_types { IMPACT, WATER, GLUE }

var impact_vector : Vector2 = Vector2.LEFT
@export var damage_type : damage_types = damage_types.IMPACT
@export var damage : float = 5.0


