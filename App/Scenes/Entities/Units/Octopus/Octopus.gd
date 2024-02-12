extends BaseUnit

var hugging = false
var hugged_tower : BaseTower

func attack_tower(tower : BaseTower):
	if tower.State == tower.States.ACTIVE:
		move_forward(tower.global_position)
		hugging = true
		tower.State = tower.States.DISABLED
		hugged_tower = tower

func do_movement():
	if hugging:
		if not is_instance_valid(hugged_tower):
			hugging = false
			hugged_tower = null
	if not hugging:
		super.do_movement()

func begin_dying():
	if is_instance_valid(hugged_tower):
		hugged_tower.State == BaseTower.States.ACTIVE
	super.begin_dying()
