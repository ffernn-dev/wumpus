extends Node3D

var data_arrows: int = 3
var wumpvision_goggles := false
var discovered_rooms: Array[Room]

func use_arrow():
	data_arrows -= 1

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
