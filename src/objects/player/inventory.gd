extends Node3D

var data_arrows: int = 0
var wumpvision_goggles := false
var discovered_rooms: Array[Room]

signal inventory_updated(arrows: int, goggles: bool)

func _ready():
	_pickup_arrow(3)
	inventory_updated.emit(data_arrows, wumpvision_goggles)

func has_arrow():
	return data_arrows > 0

func use_arrow():
	if data_arrows > 0:
		data_arrows -= 1
	else:
		printerr("No arrows to shoot. You must check has_arrow() first.")

func has_goggles():
	return wumpvision_goggles

func _pickup_arrow(n: int):
	data_arrows += n

func _pickup_goggles():
	wumpvision_goggles = true

func pickup(item_type: String, n: int = 1):
	if item_type == "arrow":
		_pickup_arrow(n)
	elif item_type == "wumpvision_goggles":
		_pickup_goggles()
	inventory_updated.emit(data_arrows, wumpvision_goggles)
	
