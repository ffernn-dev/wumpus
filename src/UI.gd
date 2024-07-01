class_name UI extends Control


const arrow_string := "ByteArrows™️: %s"
const goggles_string := "WumpVision goggles collected"

func _ready():
	print("connecting signal")
	%Player/Inventory.inventory_updated.connect(_inventory_update)
	print("connected signal")
	
func _inventory_update(arrows: int, goggles: bool):
	print("signal recieved")
	var newtext = ""
	newtext += arrow_string % arrows + "\n"
	if goggles:
		newtext += goggles_string
	$MarginContainer/Inventory.text = newtext
