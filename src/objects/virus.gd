class_name Virus extends Node

var spreadable_rooms
var age: int = 0

func _init(id: int):
	var connected_rooms = GlobalData.connections[str(id)]
	for i in connected_rooms.keys():
		if _is_room_valid(int(i)):
			spreadable_rooms[i] = connected_rooms[i]


func _is_room_valid(room_id: int):
	var valid = true
	
	# The room next to the datawump's room is invalid
	if room_id == GlobalData.hidden_room_source:
		valid = false
	
	var room = GlobalData.rooms[room_id]
	if room.contents.any(func(x): x is Virus):
		valid = false
	
	return valid

func tick():
	age += 1
	if age > 6:
		spread_attempt()
	
func spread_attempt():
	var target_room = spreadable_rooms.keys().choose_random()
	if spreadable_rooms[target_room] == GlobalData.CONNECTION_BLOCKED:
		spreadable_rooms.erase(target_room)
		return
	if not _is_room_valid(int(target_room)):
		spreadable_rooms.erase(target_room)
		return
	
	GlobalData.rooms[int(target_room)].create_virus()
