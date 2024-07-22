extends Node3D

var health: int = 4
var data_arrows: int = 0
var wumpvision_goggles := false
var discovered_rooms: Array[Room]

signal inventory_updated(health: int, arrows: int, goggles: bool)

func _ready():
	_pickup_arrow(3)
	_update_ui()

func has_arrow():
	return data_arrows > 0

func use_arrow():
	if data_arrows > 0:
		data_arrows -= 1
		_update_ui()
	else:
		printerr("No arrows to shoot. You must check has_arrow() first.")

func has_goggles():
	return wumpvision_goggles

func _pickup_arrow(n: int):
	data_arrows += n
	_update_ui()

func _pickup_goggles():
	wumpvision_goggles = true
	_update_ui()

func take_damage(n: int):
	health -= n
	if health <= 0:
		get_parent().get_parent().end_game(GlobalData.DEATH_WUMP)
	_update_ui()
	
func pickup(item_type: String, n: int = 1):
	print("pickup, item: " + item_type + " x" + str(n))
	if item_type == "arrow":
		_pickup_arrow(n)
	elif item_type == "goggles":
		_pickup_goggles()
	_update_ui()
	
func _update_ui():
	inventory_updated.emit(health, data_arrows, wumpvision_goggles)
