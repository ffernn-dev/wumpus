class_name WorldManager extends Node3D

enum {CONNECTION_CLEAR, CONNECTION_BLOCKED, CONNECTION_INVISIBLE}

var rooms = []
# ROOM ID STARTS INDEXING AT 1, SAME WITH NUMBERS IN CONNECTIONS
# {"1": {"5": clear, "2": clear, "8": blocked}}
var connections = {}


func _ready():
	create_rooms()
	create_conections()
	# TODO: populate virus first so that Wump room can't connect to virus room
	create_hidden_room(randi_range(1, 20))


func create_rooms():
	# Standard dodecahedron rooms
	for i in range(20):
		var vertex_position = DodecahedronData.vertices[i]
		# Id starts indexing at 1, hence i+1
		var room = Room.new(i + 1, vertex_position)
		rooms.append(room)

func create_conections():
	for edge in DodecahedronData.edges:
		var start = str(edge[0] + 1)
		var end = str(edge[1] + 1)
		if not connections.get(start): connections[start] = {}
		if not connections.get(end): connections[end] = {}
		connections[start][end] = CONNECTION_CLEAR
		connections[end][start] = CONNECTION_CLEAR

func create_hidden_room(connecting_room_id):
	var connecting_room = rooms[connecting_room_id - 1]
	var _connecting_room_direction = connecting_room.world_position.normalized()
	var _connecting_room_distance = connecting_room.world_position.distance_to(Vector3.ZERO)
	var hidden_room_position = _connecting_room_direction * (_connecting_room_distance + 1)
	
	var hidden_room = Room.new(21, hidden_room_position)
	
	connections["21"] = {}
	connections["21"][str(connecting_room_id)] = CONNECTION_CLEAR
	connections[str(connecting_room_id)]["21"] = CONNECTION_INVISIBLE

func _on_tunnel_body_entered(body):
	print("portal entered by " + str(body))
	
