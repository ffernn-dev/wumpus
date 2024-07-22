class_name Virus extends Node

var spreadable_rooms = {}
var room_id: int
var age: int = 0

func _init(id: int):
	room_id = id
	var connected_rooms = GlobalData.connections[str(id)]
	spreadable_rooms = connected_rooms

func _is_room_valid(target_room_id: int):
	var valid = true
	
	# Rooms connected by blocked connections are invalid
	if spreadable_rooms.get(str(target_room_id)) == GlobalData.CONNECTION_BLOCKED:
		print("virus can't spread, path blocked!")
		valid = false
	
	# The room next to the datawump's room is invalid
	if room_id == GlobalData.hidden_room_source:
		print("tried to virus into wump room")
		valid = false
	
	# Rooms with viruses already are invalid
	var room = GlobalData.rooms[target_room_id]
	if room.contents.any(func(x): return x is Virus):
		print("Already virus there!")
		valid = false
	
	return valid

func tick():
	age += 1
	if age > 6:
		spread_attempt()
	
func spread_attempt():
	if spreadable_rooms == {}:
		return
	var target_room = spreadable_rooms.keys().pick_random()
	
	if not _is_room_valid(int(target_room)):
		spreadable_rooms.erase(target_room)
		return
	
	for item in GlobalData.rooms[int(target_room)].contents:
		if item is Goggles:
			GlobalData.goggles_destroyed = true
	GlobalData.rooms[int(target_room)].create_virus()
