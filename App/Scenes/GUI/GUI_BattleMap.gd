extends CanvasLayer

# move some of the gui methods here?

func _ready():
	show() # we likely want it hidden in the inspector most of the time

func show_unit_info_card(unitInfo):
	$UnitInfoCard.popup(unitInfo)

