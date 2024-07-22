class_name UI extends Control

const health_string := "Health: %s"
const arrow_string := "ByteArrows™️: %s"
const goggles_string := "WumpVision goggles collected"

func _ready():
	%Player/Inventory.inventory_updated.connect(_inventory_update)
	
func _inventory_update(health: int, arrows: int, goggles: bool):
	var newtext = ""
	var healthbar = ""
	for i in range(health):
		healthbar += "♥"
	for i in range(4 - health):
		healthbar += "♡"
	newtext += health_string % healthbar + "\n"
	newtext += arrow_string % arrows + "\n"
	if goggles:
		newtext += goggles_string + "\n"
		newtext += "Find the DataWump in room " + str(GlobalData.hidden_room_source)
	$MarginContainer/Inventory.text = newtext
