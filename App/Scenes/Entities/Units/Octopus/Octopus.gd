extends BaseUnit

@export var hugging_time : int = 999999
var hugging = false
var hugged_tower : BaseTower
var time_spent_hugging = 0

func attack_tower(tower : BaseTower):
	if tower.State == tower.States.ACTIVE:
		move_forward(tower.global_position)
		hugging = true
		tower.State = tower.States.DISABLED
		hugged_tower = tower
		time_spent_hugging = 0

func do_movement():
	if hugging:
		time_spent_hugging += 1
		if time_spent_hugging >= hugging_time or not is_instance_valid(hugged_tower):
			hugging = false
			if is_instance_valid(hugged_tower):
				hugged_tower.State = BaseTower.States.ACTIVE
			hugged_tower = null
				
		else:
			pass
			#do_drying()
	else:
		super.do_movement()

func begin_dying():
	if is_instance_valid(hugged_tower):
		hugged_tower.State == BaseTower.States.ACTIVE
	super.begin_dying()
